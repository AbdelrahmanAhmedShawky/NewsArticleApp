import Foundation

class UserNewsFavoritesManager
{
    // MARK:- Properties

    public static var shared = UserNewsFavoritesManager()

    var favoritesNews: [NewsModel]
    {
        get
        {
            guard let data = UserDefaults.standard.data(forKey: "favorites") else { return [] }
            return (try? JSONDecoder().decode([NewsModel].self, from: data)) ?? []
        }
        set
        {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: "favorites")
        }
    }

    // MARK:- Init

    private init(){}
}


class FavoriteItems: ObservableObject {
    @Published var favItems: [NewsModel] = UserNewsFavoritesManager.shared.favoritesNews
}
