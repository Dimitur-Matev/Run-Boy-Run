//
//  AppDelegate.swift
//  RunBoyRun
//
//  Created by Dimo Popov on 10/06/2021.
//
let programString = """
    [
        {
            "name": "Example 1",
            "description": "This training program will make you feel better. I promise ;)",
            "sections": [
                {
                    "duration": 3.5,
                    "type": 1
                },
                {
                    "duration": 3.0,
                    "type": 2
                },
                {
                    "duration": 8.4,
                    "type": 5
                },
                {
                    "duration": 4.0,
                    "type": 1
                },
                {
                    "duration": 3.5,
                    "type": 4
                }
            ]
        },
        {
            "name": "Example 2",
            "description": "This training program will make you feel better. I promise ;)",
            "sections": [
                {
                    "duration": 3.5,
                    "type": 1
                },
                {
                    "duration": 3.0,
                    "type": 2
                },
                {
                    "duration": 8.4,
                    "type": 5
                },
                {
                    "duration": 4.0,
                    "type": 1
                },
                {
                    "duration": 3.5,
                    "type": 4
                }
            ]
        }
    ]

"""

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //let jsonData = jsonString.data(using: .utf8)
    let jsonProgram = programString.data(using: .utf8)
    let decoder = JSONDecoder()
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do{
            //let tracks = try decoder.decode(TrackJSON.self, from: jsonData!)
            let programs = try decoder.decode(ProgramJSON.self, from: jsonProgram!)
            //print(tracks[0].analysisURL)
            //print(programs[1].name)
            print("READING THE JSON FILE")
            let data = readLocalFile(forName: "suggested_playlist")
            //var tracksJson: Data = Data()
            //var tripManager: TripManager
            
            if let unwrappedData = data{
                print("---UNWRAPED---")
                let tracks = parse(jsonData: unwrappedData)
                var tripManager = TripManager(tracks: tracks)
                print("--Trip Manager-- IS -- READY")
                
                tripManager.getIntenseSongs()
                tripManager.getRelaxSongs()
                tripManager.getJoggingSongs()
                tripManager.getWalkingSongs()
                
            }else{
                print("ERROR in SORTING the TRACKS")
            }
            
            

        }catch{
            print(error.localizedDescription)
        }
       
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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
    
    private func parse(jsonData: Data) -> [TrackJSONElement]{
        var decodedData: [TrackJSONElement] = []
        do {
            decodedData = try JSONDecoder().decode([TrackJSONElement].self,
                                                       from: jsonData)
            
            print("===================================")
        } catch {
            print("decode error")
        }
        return decodedData
    }


}

