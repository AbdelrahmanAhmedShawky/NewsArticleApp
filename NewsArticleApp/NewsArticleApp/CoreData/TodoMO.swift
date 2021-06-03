//
//  TodoMO.swift
//  NewsArticleApp
//
//  Created by Abdelrahman Shawky on 23/05/2021.
//

extension TodoMO {
    func convertToTodo() -> NewsModel {
        NewsModel(
            title: title, description: descriptions, source: SourceModel(name: sourceName), url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content
        )
    }
}
