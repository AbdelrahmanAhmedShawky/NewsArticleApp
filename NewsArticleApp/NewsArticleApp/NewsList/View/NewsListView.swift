import SwiftUI

struct NewsListView: View {
    @ObservedObject var viewModel = NewsResultViewModel()
    @State private var showCancelButton: Bool = false
    @ObservedObject var favoriteItems = FavoriteItems()
    @State private var showfav = false
    @ViewBuilder
    var searchView:some View {
        
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("search", text: self.$viewModel.searchTerm, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    self.viewModel.searchingNewsList()
                    self.showCancelButton = true
                }).foregroundColor(.primary)
                
                Button(action: {
                    UIApplication.shared.endEditing(true)
                    self.viewModel.searchTerm = ""
                    self.viewModel.getNewsList()
                    self.viewModel.searchNewsList.removeAll()
                    self.showCancelButton = false
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(self.viewModel.searchTerm == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            if self.showCancelButton  {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true)
                    self.viewModel.searchTerm = ""
                    self.viewModel.getNewsList()
                    self.viewModel.searchNewsList.removeAll()
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(self.showCancelButton)
    }
    
    @ViewBuilder
    var segmantControl:some View {
        Picker(selection: $viewModel.selection, label: Text("")) {
            ForEach(0..<viewModel.selectedCategories.count, id: \.self) { index in
                Text(self.viewModel.selectedCategories[index]).tag(index)
            }
        }.onChangeBackwardsCompatible(of: viewModel.selection) { (newIndex) in
            self.viewModel.searchTerm.isEmpty ?
                viewModel.getNewsList() : viewModel.searchingNewsList()
        }
        .pickerStyle(SegmentedPickerStyle()).padding()
    }
    
    var emptyListView: some View {
        Text("no data...").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.5, alignment: .center)
    }
    
    var NewsListView: some View {
        List(viewModel.searchTerm.isEmpty ? self.viewModel.newsList : self.viewModel.searchNewsList,id:\.description) { item in
            VStack {
                NewsViewCell(item: item)
                Button(action: {
                    if self.favoriteItems.favItems.contains(where: {$0.title == item.title }) {
                        self.favoriteItems.favItems.removeAll(where: { $0.title == item.title })
                    }else {
                        self.favoriteItems.favItems.append(item)
                        UserNewsFavoritesManager.shared.favoritesNews = self.favoriteItems.favItems
                        let mySavedPlaces = UserNewsFavoritesManager.shared.favoritesNews
                        print("tesst",mySavedPlaces)
                    }
                }) {
                    Text(self.favoriteItems.favItems.contains(where: {$0.title == item.title }) ? "favorites" :"Add to favorites")
                        .font(.headline)
                        .foregroundColor(self.favoriteItems.favItems.contains(where: {$0.title == item.title }) ? Color.green : Color.blue)
                        .frame(minWidth: 100, maxWidth: UIScreen.main.bounds.size.width/1.2, minHeight: 50)
                }.background(
                    RoundedRectangle(cornerRadius: 15).shadow(color: Color.gray.opacity(0.35), radius: 15, x: 0, y: 0))
            }
        }
    }
    
    @ViewBuilder
    var listView: some View {
        if viewModel.searchTerm.isEmpty {
            if self.viewModel.newsList.isEmpty {
                emptyListView
            } else {
                NewsListView
            }
        }else {
            if self.viewModel.searchNewsList.isEmpty {
                emptyListView
            } else {
                NewsListView
            }
        }
        
    }
    
    var body: some View {
        LoadingView(isShowing: .constant($viewModel.isShowLoader.wrappedValue)) {
            NavigationView {
                Group {
                    VStack {
                        searchView
                        segmantControl
                        listView
                    }
                }.navigationBarTitle("News Articls").toolbar {
                    Button("your Favorites") {
                        print("Help tapped!")
                        self.showfav = true
                    }.sheet(isPresented: self.$showfav) {
                        FavoritesNewsView()
                    }
                }
                .resignKeyboardOnDragGesture()
            }
            .onAppear {
                self.viewModel.getNewsList()
            }
        }.alert(isPresented: $viewModel.isShowAlert) {
            Alert(
                title: Text(""),
                message: Text($viewModel.alertMessage.wrappedValue),
                primaryButton: .destructive(Text("Retry"), action: {
                    UIApplication.shared.endEditing(true)
                    self.viewModel.searchTerm = ""
                    self.viewModel.getNewsList()
                    self.viewModel.searchNewsList.removeAll()
                }),
                secondaryButton: .default(Text("Cancel"), action: {
                    // do something
                })
            )
        }
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView()
    }
}
