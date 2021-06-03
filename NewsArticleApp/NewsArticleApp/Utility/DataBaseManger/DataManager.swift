//
//  DataManager.swift
//  NewsArticleApp
//
//  Created by Abdelrahman Shawky on 01/06/2021.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func fetchFavoritesListList() -> [NewsModel]
    func addFavoritesItem(item: NewsModel)
    func deleteFavoritesItem(item: NewsModel)
}

extension DataManagerProtocol {
    func fetchFavoritesListList() -> [NewsModel] {
        fetchFavoritesListList()
    }
}

class DataManager {
    static let shared: DataManagerProtocol = DataManager()
    
    var dbHelper: CoreDataHelper = CoreDataHelper.shared
    
    private init() { }
    
    private func getItem(for todo: NewsModel) -> TodoMO? {
        let predicate =  NSPredicate(format: "title == %@", todo.title ?? "")
        let result = dbHelper.fetchFirst(TodoMO.self, predicate: predicate)
        switch result {
        case .success(let todoMO):
            return todoMO
        case .failure(_):
            return nil
        }
    }
}

// MARK: - DataManagerProtocol
extension DataManager: DataManagerProtocol {
        
    func deleteFavoritesItem(item: NewsModel) {
        guard let todoMO = getItem(for: item) else {
            return
        }
        dbHelper.delete(todoMO)
    }
    
    func addFavoritesItem(item: NewsModel) {
        let entity = TodoMO.entity()
        let newTodo = TodoMO(entity: entity, insertInto: dbHelper.context)
        newTodo.title = item.title
        newTodo.uuid = UUID()
        newTodo.content = item.content
        newTodo.descriptions = item.description
        newTodo.sourceName = item.source?.name
        newTodo.publishedAt = item.publishedAt
        newTodo.url = item.url
        newTodo.urlToImage = item.urlToImage
        dbHelper.create(newTodo)
    }
    
    func fetchFavoritesListList() -> [NewsModel] {
        let result: Result<[TodoMO], Error> = dbHelper.fetch(TodoMO.self)
        switch result {
        case .success(let todoMOs):
            return todoMOs.map { $0.convertToTodo() }
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    
}
