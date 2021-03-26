import Foundation
import Combine

enum ApiErorr:Error {
    case decodeingError
    case httpError(Int)
    case unKnown
}
