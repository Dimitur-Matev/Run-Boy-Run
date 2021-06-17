//
//  Trip.swift
//  RunBoyRun
//
//  Created by Dimo Popov on 17/06/2021.
////
//func getIntenseSongs(){
//    //HIGH BPM HIGH Q
//}
//func getJoggingSongs(){
//    //Medium BPM High Q
//}
//func getWalkingSongs(){
//    //Low BPM Medium Q
//}
//func getRelaxSongs(){
//    //LOW BPM LOW Q
//}
//}

import Foundation

class TripManager{
    let tracks: TrackJSON
    let program: ProgramJSON
    var inteseTracks: [ProgramJSONElement]
    var joggingTracks: [ProgramJSONElement]
    var walkingTracks: [ProgramJSONElement]
    var relaxTracks: [ProgramJSONElement]
    init(tracks: TrackJSON, program: ProgramJSON){
        self.tracks = tracks
        self.program = program
        self.inteseTracks = []
        self.joggingTracks = []
        self.walkingTracks = []
        self.relaxTracks = []

    }
    
    func sortTracks(){
//        let bestQ: Int
        let bestQ = tracks.max {$0.q < $1.q}
        let lowQ = tracks.min{$0.q > $1.q}
        let highTempo = tracks.max {$0.tempo < $1.tempo}
        let lowTempo = tracks.min {$0.tempo > $1.tempo}
        for track in tracks {
//            if(track.tempo-5.0 <= highTempo?.tempo ?? default value){
//            inteseTracks.append(track)
            }
        }
    
    func matchTrackToSection(){
        
    }
    
    
}
