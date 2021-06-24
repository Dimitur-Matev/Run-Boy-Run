//
//  RunViewController.swift
//  RunBoyRun
//
//  Created by Dimitar Matev on 24/06/2021.
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

import SpriteKit
import UIKit

class RunViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

//    @IBOutlet weak var program1: UIButton!
//    @IBOutlet weak var program2: UIButton!
//    @IBOutlet weak var program3: UIButton!
//    @IBOutlet weak var program4: UIButton!
//    @IBOutlet weak var Start: UIButton!
//    @IBOutlet weak var spotifyButton: UIButton!
//    @IBOutlet weak var playList: UIButton!
//    @IBOutlet weak var chooseMusic: UILabel!
//    @IBOutlet weak var distance: UIPickerView!
//    @IBOutlet weak var pickerView: UIPickerView!
    
    
    let jsonProgram = programString.data(using: .utf8)
    let decoder = JSONDecoder()
    let playURI = "spotify:track:4tmIJTSnuvskqsPwB5RCqx"
    
    var intenseSongs: [TrackJSONElement] = []
    var relaxSongs: [TrackJSONElement] = []
    var joggingSongs: [TrackJSONElement] = []
    var walkingSongs: [TrackJSONElement] = []
    
    var seconds = 0
    var timer = Timer()
    var timeStarted = Bool()
        
    override func viewDidLoad() {
//        program1.layer.cornerRadius = 10
//        program1.clipsToBounds = true
//        program1.setTitle("Nice and easy", for: .normal)
//        program2.layer.cornerRadius = 10
//        program2.clipsToBounds = true
//        program2.setTitle("Explosive", for: .normal)
//        program3.layer.cornerRadius = 10
//        program3.clipsToBounds = true
//        program3.setTitle("Jogging", for: .normal)
//        program4.layer.cornerRadius = 10
//        program4.clipsToBounds = true
//        program4.setTitle("Hardcore", for: .normal)
//        Start.layer.cornerRadius = 10
//        Start.clipsToBounds = true
//        Start.setTitle("Start", for: .disabled)
//        playList.layer.cornerRadius = 10
//        playList.clipsToBounds = true
//
//
//        pickerView.delegate = self
//        pickerView.dataSource = self
        
//
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        do{
            let programs = try decoder.decode(ProgramJSON.self, from: jsonProgram!)
            
            
            print("READING THE JSON FILE")
            let data = readLocalFile(forName: "suggested_playlist")
            
            
            
            if let unwrappedData = data{
                print("---UNWRAPED---")
                let tracks = parse(jsonData: unwrappedData)
                var tripManager = TripManager(tracks: tracks)
                print("--Trip Manager-- IS -- READY")
                
                self.intenseSongs = tripManager.getIntenseSongs()
                self.relaxSongs = tripManager.getRelaxSongs()
                self.joggingSongs = tripManager.getJoggingSongs()
                self.walkingSongs = tripManager.getWalkingSongs()
                
                var runCount = 0
                
                for section in programs[0].sections{
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        print("Timer fired!")
                        runCount += 1
                        
                        //spotify.play
                        //sound notifications

                        if Double(runCount)/10.0 >= section.duration {
                            runCount = 0
                            timer.invalidate()
                        }
                    }
                    
                    
                    
                }
                
            }else{
                print("ERROR in SORTING the TRACKS")
            }
            
            

        }catch{
            print(error.localizedDescription)

        }
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
    
    
//    func startRun() {
//
//        startRunTimer()
//        timeStarted = true
//    }
//
//    func resetRun() {
//
//        timeStarted = false
//        stopRunTimer()
//        seconds = 0
//    }

//    func startRunTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
//    }

//    func updateTimer() {
//        seconds += 1
//        //activeTimer.text = timeString(time: TimeInterval(seconds))
//    }

    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i.%02i", hours, minutes, seconds)
    }

//
//    func stopRunTimer() {
//        timer.invalidate()
//        //removeAction(forKey: "timer")
//    }

   
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
        }
    
    
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
    
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return 100
       }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?  {
           return String(row + 1)
       }
    
    
}

