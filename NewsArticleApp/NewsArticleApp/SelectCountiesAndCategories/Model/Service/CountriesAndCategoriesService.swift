import Foundation
import Combine

protocol CountriesAndCategoriesService {
    var fileManagerHandler: FileManagerServiceProtocol {get}
    
    func getCountries() -> AnyPublisher<CountriesModel,ApiErorr>
    func getCategories() -> AnyPublisher<CategoriesModel,ApiErorr>
}

extension CountriesAndCategoriesService {
  
    
    func getCountries() -> AnyPublisher<CountriesModel, ApiErorr> {
        let resource: FileManagerResource<CountriesModel> = {
                    FileManagerResource(fileName: "Countries")
            
        }()
        return fileManagerHandler.load(resource: resource).eraseToAnyPublisher()
    }
    
    func getCategories() -> AnyPublisher<CategoriesModel,ApiErorr> {
         let resource: FileManagerResource<CategoriesModel> = {
            FileManagerResource(fileName: "Categories")
         }()

        return fileManagerHandler.load(resource: resource).eraseToAnyPublisher()
    }

}


