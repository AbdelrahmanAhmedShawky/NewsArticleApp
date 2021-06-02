import Foundation

struct NewsResult: Codable {
    let articles: [NewsModel]
    let totalResults: Int
}

// MARK: - NewsModel

struct NewsModel: Codable {
   
    let title: String?
    let description: String?
    let source: SourceModel?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct SourceModel: Codable {
    let name: String?
}

