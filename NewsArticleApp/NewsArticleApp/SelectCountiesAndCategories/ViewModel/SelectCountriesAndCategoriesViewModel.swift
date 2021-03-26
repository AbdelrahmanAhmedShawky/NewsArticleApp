
import Foundation
import Combine

class SelectCountriesAndCategoriesViewModel: ObservableObject,CountriesAndCategoriesService {
    var fileManagerHandler: FileManagerHandlerProtocol
    
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var countriesList = [Country]()
    @Published var categoriesList = [String]()
    @Published var isShowLoader: Bool
    @Published var isShowAlert: Bool
    @Published var alertMessage = ""
    var searchTerm: String = ""
    
    init(fileManagerHandler: FileManagerHandlerProtocol = FileManagerHandler()) {
        self.fileManagerHandler = fileManagerHandler
        isShowLoader = false
        isShowAlert = false
        getCountriesList()
        getCategoriesList()
    }
    
    func getCountriesList() {
        let cancellable = self.getCountries().sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                self.isShowLoader = false
                self.isShowAlert = true
                self.alertMessage = error.localizedDescription
            case .finished:
                self.isShowLoader = false
                break
            }
        }) { (countriesList) in
            self.isShowLoader = false
            self.isShowAlert = false
            self.countriesList = countriesList.articles ?? []
        }
        cancellables.insert(cancellable)

        
    }
    
    func getCategoriesList() {
        
        let cancellable = self.getCategories().sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                self.isShowLoader = false
                self.isShowAlert = true
                self.alertMessage = error.localizedDescription
            case .finished:
                self.isShowLoader = false
                break
            }
        }) { (categoriesList) in
            self.isShowLoader = false
            self.isShowAlert = false
            self.categoriesList = categoriesList.categories ?? []
        }
        cancellables.insert(cancellable)

    }
}
