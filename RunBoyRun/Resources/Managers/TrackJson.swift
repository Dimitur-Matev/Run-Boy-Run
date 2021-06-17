// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let trackJSON = try? newJSONDecoder().decode(TrackJSON.self, from: jsonData)

import Foundation

// MARK: - TrackJSONElement
struct TrackJSONElement: Codable {
    let acousticness: Double
    let analysisSections: [[String: Double]]
    let analysisURL: String
    let artist: String
    let artistGenres: [String]
    let coverURL: String
    let danceability: Double
    let durationMS: Int
    let energy: Double
    let id: String
    let instrumentalness: Double
    let key: Int
    let liveness, loudness: Double
    let mode: Int
    let q, speechiness, tempo: Double
    let timeSignature: Int
    let track: String
    let trackHref: String
    let type, uri: String
    let valence: Double

    enum CodingKeys: String, CodingKey {
        case acousticness
        case analysisSections = "analysis_sections"
        case analysisURL = "analysis_url"
        case artist
        case artistGenres = "artist_genres"
        case coverURL = "cover_url"
        case danceability
        case durationMS = "duration_ms"
        case energy, id, instrumentalness, key, liveness, loudness, mode, q, speechiness, tempo
        case timeSignature = "time_signature"
        case track
        case trackHref = "track_href"
        case type, uri, valence
    }
}

typealias TrackJSON = [TrackJSONElement]
