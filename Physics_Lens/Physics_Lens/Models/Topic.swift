import SwiftUI

struct Topic: Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let points: [String]
}
