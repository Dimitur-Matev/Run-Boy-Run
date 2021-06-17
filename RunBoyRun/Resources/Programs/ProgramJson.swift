struct ProgramJSONElement: Codable {
    let name, programJSONDescription: String
    let sections: [[String: Double]]

    enum CodingKeys: String, CodingKey {
        case name
        case programJSONDescription = "description"
        case sections
    }
}

typealias ProgramJSON = [ProgramJSONElement]
