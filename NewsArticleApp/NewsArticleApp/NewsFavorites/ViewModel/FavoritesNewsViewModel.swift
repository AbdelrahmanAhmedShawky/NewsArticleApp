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
    func fetchFavoritesList()
}

final class FavoritesNewsViewModel: ObservableObject {
    @Published var newsFavoritesList = [NewsModel]()
    
    var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
        fetchFavoritesList()
    }
}

// MARK: - FavoritesListViewModelProtocol
extension FavoritesNewsViewModel: FavoritesListViewModelProtocol {
    func fetchFavoritesList() {
        newsFavoritesList = dataManager.fetchFavoritesListList()
    }
}
