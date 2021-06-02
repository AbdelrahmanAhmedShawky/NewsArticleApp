//
//  FavoritesNewsViewModel.swift
//  NewsArticleApp
//
//  Created by Abdelrahman Shawky on 01/06/2021.
//

import Foundation
import Combine

protocol FavoritesListViewModelProtocol {
    var newsFavoritesList: [NewsModel] { get }
    func getFevoriteList()
    func deleteFevoriteItem(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String)
}

final class FavoritesNewsViewModel: ObservableObject {
    @Published var newsFavoritesList = [NewsModel]()
    
    var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
        getFevoriteList()
    }
}

// MARK: - FavoritesListViewModelProtocol
extension FavoritesNewsViewModel: FavoritesListViewModelProtocol {
    func getFevoriteList() {
        newsFavoritesList = dataManager.fetchFavoritesListList()
    }
    
    func deleteFevoriteItem(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        dataManager.deleteFavoritesItem(title: title, description: description, sourceName: sourceName, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
        getFevoriteList()
    }
}
