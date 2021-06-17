//
//  Section.swift
//  RunBoyRun
//
//  Created by Dimitar Matev on 14/06/2021.
//

import Foundation

struct Section {
    let type: String
    let duration: Double
//    var playlist: [Track]
    
    init (section: SectionJson){
        self.duration = section.duration
        self.type = section.type
//        playlist = []
    }
    
    func GeneratePlaylist(){
        //TODO: Generate playlist based on type of section
        //-----------------------------
    }
}
