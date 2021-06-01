import Foundation
import Combine
import UIKit

protocol NewFavoriteViewModelProtocol {
    func addFevoriteList(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String)
    func getFevoriteList()
    func deleteFevoriteItem(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String)
    func toggleIsCompleted(for item: NewsModel)
}

class NewsResultViewModel: ObservableObject,NewsResultService {
    
    var apiSession: APIService
    var dataManager: DataManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var newsList = [NewsModel]()
    @Published var searchNewsList = [NewsModel]()
    @Published var isShowLoader: Bool
    @Published var isShowAlert: Bool
    @Published var alertMessage = ""
    @Published var selection = 0
    
    @Published var showCompleted = false {
        didSet {
            getFevoriteList()
        }
    }
    
    @Published var newsFevoriteList = [NewsModel]()
    var searchTerm: String = ""
    let selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry") ?? "us"
    let selectedCategories: [String] = UserDefaults.standard.object(forKey: "selectedCategories") as? [String] ?? []
    init(apiSession: APIService = APISession(),dataManager: DataManagerProtocol = DataManager.shared) {
        self.apiSession = apiSession
        self.dataManager = dataManager
        isShowLoader = false
        isShowAlert = false
        getNewsList()
        getFevoriteList()
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
        let cancellable = self.searchNewsList(searchText: searchTerm.trimmingCharacters(in: .whitespacesAndNewlines),country: selectedCountry, category: selectedCategories[selection])
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

extension NewsResultViewModel :NewFavoriteViewModelProtocol {
    
    func toggleIsCompleted(for item: NewsModel) {
        dataManager.toggleIsCompleted(for: item)
        getFevoriteList()
    }
    
    func deleteFevoriteItem(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        dataManager.deleteTodo(title: title, description: description, sourceName: sourceName, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
    }
    
    
    func getFevoriteList() {
        newsFevoriteList = dataManager.fetchTodoList()
    }
    
    func addFevoriteList(title: String, description: String, sourceName: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        dataManager.addTodo(title: title, description: description, sourceName: sourceName, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
    }
    
    
}
