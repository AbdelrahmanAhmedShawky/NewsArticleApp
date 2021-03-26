import Foundation
import Combine
import UIKit

struct APISession:APIService {
    
    func request<T>(with build: RequestBuilder) -> AnyPublisher<T, ApiErorr> where T : Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: build.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unKnown }
            .flatMap { data, response -> AnyPublisher<T, ApiErorr> in
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) {
                        return Just(data)
                            .decode(type: T.self, decoder: decoder)
                            .mapError { _ in .decodeingError }
                        .eraseToAnyPublisher()
                    } else {
                        return Fail(error: ApiErorr.httpError(response.statusCode))
                        .eraseToAnyPublisher()
                    }
                }
                return Fail(error: ApiErorr.unKnown)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    func requestImage(with url:String) -> AnyPublisher<UIImage,ApiErorr> {
        guard let url = URL(string: url) else {
            return Fail(error: .decodeingError)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unKnown }
            .flatMap { (data,response) -> AnyPublisher<UIImage,ApiErorr> in
                if let image = UIImage(data: data) {
                    return Just(image)
                        .mapError { _ in .decodeingError }
                    .eraseToAnyPublisher()
                }else {
                     return Fail(error: ApiErorr.unKnown)
                                   .eraseToAnyPublisher()
                }
        }.eraseToAnyPublisher()
    }
    
}
