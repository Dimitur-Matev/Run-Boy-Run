//
//  Section.swift
//  RunBoyRun
//
//  Created by Dimitar Matev on 14/06/2021.
//

import Foundation

struct SectionJson: Codable {
    let type: String
    let duration: Double
    
    enum CodingKeys: String, CodingKey {
        case type
        case duration
    }
}
