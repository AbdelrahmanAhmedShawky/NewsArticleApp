import Foundation

enum NewsListEndPoints {
    case newsList(String,String)
    case searchNewsList(String,String,String)
}

extension NewsListEndPoints: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .newsList(let country,let category):
            guard let url = URL(string: "\(Constants.BASEURL)?apiKey=\(Constants.ApiKey)&country=\(country)&category=\(category)")
                else {preconditionFailure("Invalid URL format")}
            let request = URLRequest(url: url)
            return request
        case .searchNewsList(let q,let country,let category):
            guard let url = URL(string: "\(Constants.BASEURL)?qInTitle=\(q)&apiKey=\(Constants.ApiKey)&country=\(country)&category=\(category)")
                else {
                preconditionFailure("Invalid URL format")
            }
            let request = URLRequest(url: url)
            return request
        }
    }
    
}
