import SwiftUI
import Combine

final class DataStore: ObservableObject {
    
    let didChange = PassthroughSubject<DataStore, Never>()
    
    @Published var login: Bool = false
    
    @UserDefault(key: "loggedIn", defaultValue: false)
    var loggedIn: Bool {
        didSet {
            didChange.send(self)
            self.login = self.loggedIn
        }
    }
}
