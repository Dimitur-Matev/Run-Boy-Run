//
//  Track.swift
//  RunBoyRun
//
//  Created by Dimitar Matev on 14/06/2021.
//

import Foundation

struct TrackJson: Codable {
    let uri: String
    let start: Double
    enum CodingKeys: String, CodingKey {
        case uri
        case start
    }
}
