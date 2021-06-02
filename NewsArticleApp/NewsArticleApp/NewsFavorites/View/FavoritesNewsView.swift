import SwiftUI

struct FavoritesNewsView: View {
//    @ObservedObject var favoriteItems = FavoriteItems()
    @ObservedObject var viewModel : FavoritesNewsViewModel
    
    var emptyListView: some View {
        Text("no data...").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.5, alignment: .center)
    }
    
    var NewsListView: some View {
        List(self.viewModel.newsFavoritesList,id: \.id) { item in
            NewsViewCell(item: NewsModel(title: item.title ?? "", description: item.description ?? "", source: item.source, url: item.url ?? "", urlToImage: item.urlToImage ?? "", publishedAt: item.publishedAt ?? "", content: item.content ?? ""))
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
        listView.navigationBarTitle("Favorites News")
    }
}

struct FavoritesNewsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesNewsView(viewModel: FavoritesNewsViewModel())
    }
}
