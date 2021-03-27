import Foundation
import Combine

protocol NewsResultService {
    var apiSession: APIService {get}
    
    func getNewsList(country:String,category:String) ->AnyPublisher<NewsResult,ApiErorr>
    func searchNewsList(searchText:String,country:String,category:String) ->AnyPublisher<NewsResult,ApiErorr>
    
}

extension NewsResultService {
    
    func getNewsList(country:String,category:String) ->AnyPublisher<NewsResult,ApiErorr> {
        return apiSession.request(with: NewsListEndPoints.newsList(country, category))
            .eraseToAnyPublisher()
    }
        
    func searchNewsList(searchText:String,country:String,category:String) -> AnyPublisher<NewsResult,ApiErorr> {
        return apiSession.request(with: NewsListEndPoints.searchNewsList(searchText, country, category))
        .eraseToAnyPublisher()
    }
    
}
