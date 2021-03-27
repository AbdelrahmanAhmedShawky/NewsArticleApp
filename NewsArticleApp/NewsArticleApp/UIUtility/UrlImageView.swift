import SwiftUI
import Combine

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel

    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }

    var body: some View {
        Image(uiImage: urlImageModel.image ?? UrlImageView.defaultImage!)
            .resizable()
            .scaledToFill()
    }

    static var defaultImage = UIImage(named: "picture")
    
}

class UrlImageModel: ObservableObject,NewsResultService {
    var apiSession: APIService
    
    @Published var image: UIImage?
    var urlString: String?
    
    var cancellables = Set<AnyCancellable>()
    
    init(urlString: String?,apiSession: APIService = APISession()) {
        self.urlString = urlString
        self.apiSession = apiSession
        loadImage()
    }
    
    func loadImage() {
        loadImageFromUrl()
    }
    
    func loadImageFromUrl() {
        
        guard let urlString = urlString else {
            return
        }
        getImageFromResponse(urlString: urlString)
        
    }
    
    func getImageFromResponse(urlString: String) {
        let cancellable = apiSession.requestImage(with: urlString)
            .sink(receiveCompletion: { (result) in
                print(result)
            }) { (image) in
                self.image = image
            }
        cancellables.insert(cancellable)
    
    }
    
}
