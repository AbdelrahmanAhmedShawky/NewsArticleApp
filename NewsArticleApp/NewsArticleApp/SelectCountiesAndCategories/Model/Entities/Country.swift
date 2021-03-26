import Foundation

struct CountriesModel: Codable, Equatable {
    let articles: [Country]?
}

struct Country: Codable,Equatable {
    let country: String?
    let name: String?
}


