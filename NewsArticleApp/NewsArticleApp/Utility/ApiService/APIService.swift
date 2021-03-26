import Foundation
import Combine
import UIKit

protocol APIService {
    func request<T:Decodable>(with build: RequestBuilder) -> AnyPublisher<T,ApiErorr>
    func requestImage(with url:String) -> AnyPublisher<UIImage,ApiErorr>
}
