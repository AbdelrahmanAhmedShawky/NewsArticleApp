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
    func deleteFevoriteItem(item: NewsModel)
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
    
    func deleteFevoriteItem(item: NewsModel) {
        dataManager.deleteFavoritesItem(item: item)
        getFevoriteList()
    }
}
