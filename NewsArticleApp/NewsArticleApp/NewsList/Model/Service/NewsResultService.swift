import Foundation
import Combine

protocol NewsResultService {
    var apiSession: APIService {get}
    
    func getNewsList() ->AnyPublisher<NewsResult,ApiErorr>
    func searchNewsList(searchText:String) ->AnyPublisher<NewsResult,ApiErorr>
    
}

extension NewsResultService {
    
    func getNewsList() ->AnyPublisher<NewsResult,ApiErorr> {
        return apiSession.request(with: NewsListEndPoints.newsList("de", "business"))
            .eraseToAnyPublisher()
    }
        
    func searchNewsList(searchText:String) -> AnyPublisher<NewsResult,ApiErorr> {
        return apiSession.request(with: NewsListEndPoints.searchNewsList(searchText, "de", "business"))
        .eraseToAnyPublisher()
    }
    
}
