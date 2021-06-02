//
//  DataManager.swift
//  NewsArticleApp
//
//  Created by Abdelrahman Shawky on 01/06/2021.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func fetchFavoritesListList() -> [NewsModelDB]
    func addFavoritesItem(
        title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String)
    func deleteFavoritesItem(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String)
}

extension DataManagerProtocol {
    func fetchFavoritesListList() -> [NewsModelDB] {
        fetchFavoritesListList()
    }
}

class DataManager {
    static let shared: DataManagerProtocol = DataManager()
    
    var dbHelper: CoreDataHelper = CoreDataHelper.shared
    
    private init() { }
    
    private func getItem(for todo: NewsModelDB) -> TodoMO? {
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
        
    func deleteFavoritesItem(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        guard let todoMO = getItem(for: NewsModelDB(title: title, description: description, source: SourceModel(name: sourceName), url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)) else {
            return
        }
        dbHelper.delete(todoMO)
    }
    
    func addFavoritesItem(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        let entity = TodoMO.entity()
        let newTodo = TodoMO(entity: entity, insertInto: dbHelper.context)
        newTodo.title = title
        newTodo.uuid = UUID()
        newTodo.content = content
        newTodo.descriptions = description
        newTodo.sourceName = sourceName
        newTodo.publishedAt = publishedAt
        newTodo.url = url
        newTodo.urlToImage = urlToImage
        dbHelper.create(newTodo)
    }
    
    func fetchFavoritesListList() -> [NewsModelDB] {
        let result: Result<[TodoMO], Error> = dbHelper.fetch(TodoMO.self)
        switch result {
        case .success(let todoMOs):
            return todoMOs.map { $0.convertToTodo() }
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    
}
