//
//  DataManager.swift
//  NewsArticleApp
//
//  Created by Abdelrahman Shawky on 01/06/2021.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func fetchTodoList(includingCompleted: Bool) -> [NewsModel]
    func addTodo(
        title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String)
    func deleteTodo(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String)
    func toggleIsCompleted(for item: NewsModel)
}

extension DataManagerProtocol {
    func fetchTodoList(includingCompleted: Bool = false) -> [NewsModel] {
        fetchTodoList(includingCompleted: includingCompleted)
    }
}

class DataManager {
    static let shared: DataManagerProtocol = DataManager()
    
    var dbHelper: CoreDataHelper = CoreDataHelper.shared
    
    private init() { }
    
    private func getTodoMO(for todo: NewsModel) -> TodoMO? {
        let predicate = NSPredicate(
            format: "uuid = %@",
            UUID() as CVarArg)
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
    func toggleIsCompleted(for item: NewsModel) {
        func toggleIsCompleted(for item: NewsModel) {
            guard let todoMO = getTodoMO(for: item) else { return }
            todoMO.isCompleted.toggle()
            dbHelper.update(todoMO)
        }
    }
    
    
    func deleteTodo(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        let entity = TodoMO.entity()
        let newTodo = TodoMO(entity: entity, insertInto: dbHelper.context)
        newTodo.title = title
        newTodo.content = content
        newTodo.descriptions = description
        newTodo.sourceName = sourceName
        newTodo.publishedAt = publishedAt
        newTodo.url = url
        newTodo.urlToImage = urlToImage
        dbHelper.delete(newTodo)
    }
    
    func addTodo(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        let entity = TodoMO.entity()
        let newTodo = TodoMO(entity: entity, insertInto: dbHelper.context)
        newTodo.title = title
        newTodo.content = content
        newTodo.descriptions = description
        newTodo.sourceName = sourceName
        newTodo.publishedAt = publishedAt
        newTodo.url = url
        newTodo.urlToImage = urlToImage
        dbHelper.create(newTodo)
    }
    
    func fetchTodoList(includingCompleted: Bool = false) -> [NewsModel] {
        let predicate = includingCompleted ? nil : NSPredicate(format: "isCompleted == false")
        let result: Result<[TodoMO], Error> = dbHelper.fetch(TodoMO.self, predicate: predicate)
        switch result {
        case .success(let todoMOs):
            return todoMOs.map { $0.convertToTodo() }
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    
}
