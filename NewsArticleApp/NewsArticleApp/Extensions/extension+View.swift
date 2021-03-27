import Foundation
import SwiftUI

extension View {
    @ViewBuilder func onChangeBackwardsCompatible<T: Equatable>(of value: T, perform completion: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: completion)
        } else {
            self.onReceive([value].publisher.first()) { (value) in
                completion(value)
            }
        }
    }
}
