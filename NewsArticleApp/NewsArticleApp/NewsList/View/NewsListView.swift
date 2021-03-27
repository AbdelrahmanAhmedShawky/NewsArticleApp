import SwiftUI

struct NewsListView: View {
    @ObservedObject var viewModel = NewsResultViewModel()
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        LoadingView(isShowing: .constant($viewModel.isShowLoader.wrappedValue)) {
            NavigationView {
                Group {
                    VStack {
                        // Search view
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                TextField("search", text: self.$viewModel.searchTerm, onEditingChanged: { isEditing in
//                                    self.viewModel.searchingNewsList()
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
                        Picker(selection: $viewModel.selection, label: Text("")) {
                            ForEach(0..<viewModel.selectedCategories.count, id: \.self) { index in
                                Text(self.viewModel.selectedCategories[index]).tag(index)
                            }
                        }.onChangeBackwardsCompatible(of: viewModel.selection) { (newIndex) in
                            self.viewModel.searchNewsList.isEmpty ?
                                viewModel.getNewsList() : viewModel.searchingNewsList()
                        }
                        .pickerStyle(SegmentedPickerStyle()).padding()
                        List(self.viewModel.searchNewsList.isEmpty ? self.viewModel.newsList : self.viewModel.searchNewsList,id:\.description) { item in
                            NewsViewCell(item: item)
                        }
                        .navigationBarTitle("News Articls")
                        .resignKeyboardOnDragGesture()
                    }
                    
                }}
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
