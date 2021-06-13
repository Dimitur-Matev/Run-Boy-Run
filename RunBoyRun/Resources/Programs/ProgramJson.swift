//
//  Program.swift
//  RunBoyRun
//
//  Created by Dimitar Matev on 13/06/2021.
//

import Foundation

struct ProgramJson: Codable {
    let name, description: String
    let sections: [SectionJson]

    enum CodingKeys: String, CodingKey {
        case name
        case description = "description"
        case sections
    }
    
    init(name: String, description: String, sections: [SectionJson]) {
        self.name = name
        self.description = description
        self.sections = sections
    }
    
//    init(self :from: )
//    private func parse(jsonData: Data) {
//        do {
//            let decodedData = try JSONDecoder().decode(CodingKeys.self,
//                                                       from: jsonData)
//
//            print("Title: ", decodedData.title)
//            print("Description: ", decodedData.description)
//            print("===================================")
//        } catch {
//            print("decode error")
//        }
//    }
}
