//
//  ProgramManager.swift
//  RunBoyRun
//
//  Created by Dimitar Matev on 14/06/2021.
//

import Foundation

class ProgramManager{
    
//    let programs : [ProgramJson]?
    
    init() {
        //TODO: load programs from file
        //-----------------------------
        
//        let data = readLocalFile(forName: "programs.json")
//        if let unwraped = data {
//            programs = try? JSONDecoder().decode([ProgramJson].self, from: unwraped)
//        }else{
//            programs = []
//        }
//        programs = []
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
//    public func Start(program: Program){
//        //TODO: foreach program.sections and get the playlists
//        // then pass the songs to the Spotify Manager
//        //-----------------------------
//        
//    }
//    
}
