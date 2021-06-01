import Foundation
import Combine

struct FileManagerResource<T> {
    let fileName: String
}

protocol FileManagerServiceProtocol {
    func load<T: Decodable>(resource: FileManagerResource<T>) -> AnyPublisher<T, ApiErorr>
}

struct FileManagerService: FileManagerServiceProtocol {
    func load<T: Decodable>(resource: FileManagerResource<T>) -> AnyPublisher<T, ApiErorr> {
        guard let url =  Bundle.main.path(forResource: resource.fileName, ofType: "json") else {
            return Fail(error: ApiErorr.unKnown).eraseToAnyPublisher()
        }
        return Future<T, ApiErorr> { resolve in
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: url))
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                resolve(.success(jsonData))
            } catch {
                print("error:\(error)")
                resolve(.failure(ApiErorr.unKnown))
            }
        }
        .eraseToAnyPublisher()
    }
}
