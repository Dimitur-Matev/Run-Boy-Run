//
//  Trip.swift
//  RunBoyRun
//
//  Created by Dimo Popov on 17/06/2021.


import Foundation

class TripManager{
    var tracks: TrackJSON
    //let program: ProgramJSON
    var inteseTracks: [TrackJSON]
    var joggingTracks: [TrackJSON]
    var walkingTracks: [TrackJSON]
    var relaxTracks: [TrackJSON]
    
    var highQ: TrackJSONElement?
    var lowQ: TrackJSONElement?
    var middleQ: Double
    
    var highToMidQ: Double
    var MidToLowQ: Double
    
    var highTempo: TrackJSONElement?
    var lowTempo: TrackJSONElement?
    var middleTempo: Double
    
    var highToMidTempo: Double
    var MidToLowTempo: Double
    
    var totalSongs: Int
    var songsPerTypeOfSection: Int
    init(tracks: TrackJSON){
        self.tracks = tracks
        //self.program = program
        self.inteseTracks = []
        self.joggingTracks = []
        self.walkingTracks = []
        self.relaxTracks = []
        
        
        self.highQ = tracks.max {$0.q < $1.q}
        self.lowQ = tracks.min{$0.q > $1.q}
        self.middleQ = (highQ!.q+lowQ!.q)/2
        
        self.highToMidQ = (highQ!.q - middleQ)/2
        self.MidToLowQ = (middleQ - lowQ!.q)/2
        
        self.highTempo = tracks.max {$0.tempo < $1.tempo}
        self.lowTempo = tracks.min {$0.tempo > $1.tempo}
        self.middleTempo = (highTempo!.q+lowTempo!.q)/2
        
        self.highToMidTempo = (highTempo!.q - middleTempo)/2
        self.MidToLowTempo = (middleTempo - lowTempo!.q)/2
        
        self.totalSongs = tracks.count
        print("TOTAL SONGS:" + String(totalSongs))
        self.songsPerTypeOfSection = totalSongs/4
        print("SONGS PER:" + String(songsPerTypeOfSection))

    }
    
    func matchTrackToSection(){
        
    }
    
    //HIGH BPM HIGH Q
    func getIntenseSongs() -> [TrackJSONElement]{

        
        //tracks.sort{$0.tempo < $1.tempo && $0.q < middleQ && $1.q < middleQ && $0.tempo < middleTempo && $1.tempo < middleTempo} // Ascending
        //so the high bpm and q are at the end
        tracks.sort{$0.q < $1.q || $0.tempo < $1.tempo}
        var trackList: [TrackJSONElement] = []
        print("----------------INTENSE-SONGS-----------------")
        for _ in 0...songsPerTypeOfSection{
            
            if let unwrappedTrack = tracks.popLast(){  // here we are poping the last element
                trackList.append(unwrappedTrack)
                print("---" + unwrappedTrack.artist)
                print("---" + String(unwrappedTrack.tempo))
                print("---" + String(unwrappedTrack.q))
                print("-------------------------------------")
            }else{
                print("ERROR in SORTING the TRACKS")
            }
            
        }
        
        //for track in trackList
        print("----------------INTENSE-SONGS-----------------")
        return trackList
    }
    
    //LOW BPM LOW Q
    func getRelaxSongs()-> [TrackJSONElement]{
        
        print("----------------RELAX-SONGS-----------------")
        
        tracks.sort{$0.q > $1.q || $0.tempo > $1.tempo} // desc
        var trackList: [TrackJSONElement] = []
        
        for _ in 0...songsPerTypeOfSection{
            
            if let unwrappedTrack = tracks.popLast(){
                trackList.append(unwrappedTrack)
                print("---" + unwrappedTrack.artist)
                print("---" + String(unwrappedTrack.tempo))
                print("---" + String(unwrappedTrack.q))
            }else{
                print("ERROR in SORTING the TRACKS")
            }
            
        }
        print("----------------RELAX-SONGS-----------------")
        return trackList
    }
    func addVocalNotifications(){
        
    }
    func buildUpLocator(track: TrackJSONElement){
        track.analysisSections.count
        
    }
    
    func getJoggingSongs()-> [TrackJSONElement]{
        print("----------------JOGGING-SONGS-----------------")
        //Medium BPM High Q
        tracks.sort{$0.q < $1.q || $0.tempo < $1.tempo} // Ascending so the high bpm and q are at the end
        var trackList: [TrackJSONElement] = []
        
        for _ in 0...songsPerTypeOfSection{
            
            if let unwrappedTrack = tracks.popLast(){  // here we are poping the last element
                trackList.append(unwrappedTrack)
                print("---" + unwrappedTrack.artist)
                print("---" + String(unwrappedTrack.tempo))
                print("---" + String(unwrappedTrack.q))
            }else{
                print("ERROR in SORTING the TRACKS")
            }
            
        }
        print("----------------JOGGING-SONGS-----------------")
        return trackList
    }
    func getWalkingSongs()-> [TrackJSONElement]{
        
        print("----------------WALKING-SONGS-----------------")
        
        //Low BPM Medium Q
        tracks.sort{$0.q < $1.q || $0.tempo > $1.tempo} // desc
        var trackList: [TrackJSONElement] = []

        for _ in 0...songsPerTypeOfSection{

            if let unwrappedTrack = tracks.popLast(){
                trackList.append(unwrappedTrack)
                print("---" + unwrappedTrack.artist)
                print("---" + String(unwrappedTrack.tempo))
                print("---" + String(unwrappedTrack.q))
            }else{
                print("ERROR in SORTING the TRACKS")
            }

        }
        
        print("----------------WALKING-SONGS-----------------")
        
        return tracks
    }

    
}
