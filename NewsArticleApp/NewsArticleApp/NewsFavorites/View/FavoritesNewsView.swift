import SwiftUI

struct FavoritesNewsView: View {
    @ObservedObject var favoriteItems = FavoriteItems()
    
    var emptyListView: some View {
        Text("no data...").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.5, alignment: .center)
    }
    
    var NewsListView: some View {
        List(favoriteItems.favItems,id:\.description) { item in
            NewsViewCell(item: item)
        }
    }
    
    @ViewBuilder
    var listView: some View {
        if favoriteItems.favItems.isEmpty {
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
        FavoritesNewsView()
    }
}
