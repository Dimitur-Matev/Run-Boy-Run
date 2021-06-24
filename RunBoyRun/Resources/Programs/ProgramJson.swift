import Foundation

struct ProgramJSONElement: Codable {
    let name, welcomeDescription: String
    let sections: [Section]

    enum CodingKeys: String, CodingKey {
        case name
        case welcomeDescription = "description"
        case sections
    }
}

// MARK: - Section
struct Section: Codable {
    let duration: Double
    let type: Int
}

typealias ProgramJSON = [ProgramJSONElement]
