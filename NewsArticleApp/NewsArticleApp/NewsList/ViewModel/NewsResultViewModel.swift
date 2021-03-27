import Foundation
import Combine
import UIKit

class NewsResultViewModel: ObservableObject,NewsResultService {
    
    var apiSession: APIService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var repositoryList = [NewsModel]()
    @Published var searchRepositoryList = [NewsModel]()
    @Published var isShowLoader: Bool
    @Published var isShowAlert: Bool
    @Published var alertMessage = ""
    var searchTerm: String = ""
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        isShowLoader = false
        isShowAlert = false
//        gettingData()
        getNewsList()
    }

//    func gettingData(){
//
//        let url = URL(string: "https://newsapi.org/v2/top-headlines?apiKey=f0b310a6e5f349838307ddd53bfa66c0&country=de&category=business")!
//        let session = URLSession.shared
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//            guard error == nil else {
//                return
//            }
//            guard let data = data else {
//                return
//            }
//            do {
//                 let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let response = try decoder.decode(NewsResult.self, from: data)
//                print(response)
//
//            } catch {
//                print(error)
//            }
//        })
//        task.resume()
//    }

    func getNewsList() {
        isShowLoader = true
        let cancellable = self.getNewsList().sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                self.isShowLoader = false
                self.isShowAlert = true
                self.alertMessage = error.localizedDescription
            case .finished:
                self.isShowLoader = false
                break
            }
        }) { (repositoryList) in
            self.isShowLoader = false
            self.isShowAlert = false
            self.repositoryList = repositoryList.articles
            print(self.repositoryList)
        }
        cancellables.insert(cancellable)
    }
        
    func searchNewsList() {
        let cancellable = self.searchNewsList(searchText: searchTerm)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    self.isShowLoader = false
                    if !self.searchTerm.isEmpty {
                        self.isShowAlert = true
                        self.alertMessage = error.localizedDescription
                    }
                case .finished:
                    self.isShowLoader = false
                    break
                }
            }) { finalResult in
                self.isShowLoader = false
                self.isShowAlert = false
                self.searchRepositoryList = finalResult.articles
            }
        cancellables.insert(cancellable)
    }
        
}

