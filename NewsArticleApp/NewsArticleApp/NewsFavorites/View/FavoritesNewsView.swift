import SwiftUI

struct FavoritesNewsView: View {
    @ObservedObject var viewModel : FavoritesNewsViewModel
    @Binding var showSheetView: Bool
    var emptyListView: some View {
        Text("no data...").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.5, alignment: .center)
    }
    
    var NewsListView: some View {
        List(self.viewModel.newsFavoritesList,id: \.title) { item in
            VStack {
            NewsViewCell(item: NewsModel(title: item.title ?? "", description: item.description ?? "", source: item.source, url: item.url ?? "", urlToImage: item.urlToImage ?? "", publishedAt: item.publishedAt ?? "", content: item.content ?? ""))
            Button(action: {
                self.viewModel.deleteFevoriteItem(title: item.title ?? "", description: item.description ?? "", sourceName: item.source?.name ?? "", url: item.url ?? "", urlToImage: item.urlToImage ?? "", publishedAt: item.publishedAt ?? "", content: item.content ?? "")
                
            }) {
                Text("delete from favorites")
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .frame(minWidth: 100, maxWidth: UIScreen.main.bounds.size.width/1.2, minHeight: 50)
            }.background(
                RoundedRectangle(cornerRadius: 15).shadow(color: Color.gray.opacity(0.35), radius: 15, x: 0, y: 0))
        }
        }
    }
    
    @ViewBuilder
    var listView: some View {
        if self.viewModel.newsFavoritesList.isEmpty {
            emptyListView
        }else{
            NewsListView
        }
    }
    
    var body: some View {
        NavigationView {
        listView
            .navigationBarTitle(Text("Favorites News"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showSheetView = false
                self.viewModel.getFevoriteList()
            }) {
                Text("Done").bold()
            })
        }
        
    }
}

