import SwiftUI

struct NewsListView: View {
    @ObservedObject var viewModel = NewsResultViewModel()
    @State private var showCancelButton: Bool = false
    
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
            NewsViewCell(item: item)
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
                }.navigationBarTitle("News Articls")
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
