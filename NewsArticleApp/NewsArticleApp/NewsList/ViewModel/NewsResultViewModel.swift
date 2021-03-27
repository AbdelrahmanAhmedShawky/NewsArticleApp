import Foundation
import Combine
import UIKit

class NewsResultViewModel: ObservableObject,NewsResultService {
    
    var apiSession: APIService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var newsList = [NewsModel]()
    @Published var searchNewsList = [NewsModel]()
    @Published var isShowLoader: Bool
    @Published var isShowAlert: Bool
    @Published var alertMessage = ""
    @Published var selection = 0
    var searchTerm: String = ""
    let selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry") ?? "us"
    let selectedCategories: [String] = UserDefaults.standard.object(forKey: "selectedCategories") as? [String] ?? []
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        isShowLoader = false
        isShowAlert = false
        getNewsList()
    }

    func getNewsList() {
        isShowLoader = true
        
        let cancellable = self.getNewsList(country: selectedCountry, category: selectedCategories[selection]).sink(receiveCompletion: { result in
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
            self.newsList = repositoryList.articles
            print(self.newsList)
        }
        cancellables.insert(cancellable)
    }
        
    func searchingNewsList() {
        isShowLoader = true
        let cancellable = self.searchNewsList(searchText: searchTerm,country: selectedCountry, category: selectedCategories[selection])
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
                self.searchNewsList = finalResult.articles
            }
        cancellables.insert(cancellable)
    }
        
}

