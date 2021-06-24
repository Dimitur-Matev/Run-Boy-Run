//
//  ViewController.swift
//  RunBoyRun
//
//  Created by Dimo Popov on 10/06/2021.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var program1: UIButton!
    @IBOutlet weak var program2: UIButton!
    @IBOutlet weak var program3: UIButton!
    @IBOutlet weak var program4: UIButton!
    @IBOutlet weak var Start: UIButton!
    @IBOutlet weak var spotifyButton: UIButton!
    @IBOutlet weak var playList: UIButton!
    @IBOutlet weak var chooseMusic: UILabel!
    @IBOutlet weak var distance: UIPickerView!
    @IBOutlet weak var pickerView: UIPickerView!


    override func viewDidLoad() {
        program1.layer.cornerRadius = 10
        program1.clipsToBounds = true
        program1.setTitle("Nice and easy", for: .normal)
        program2.layer.cornerRadius = 10
        program2.clipsToBounds = true
        program2.setTitle("Explosive", for: .normal)
        program3.layer.cornerRadius = 10
        program3.clipsToBounds = true
        program3.setTitle("Jogging", for: .normal)
        program4.layer.cornerRadius = 10
        program4.clipsToBounds = true
        program4.setTitle("Hardcore", for: .normal)
        Start.layer.cornerRadius = 10
        Start.clipsToBounds = true
        Start.setTitle("Start", for: .disabled)
        playList.layer.cornerRadius = 10
        playList.clipsToBounds = true
        

        pickerView.delegate = self
        pickerView.dataSource = self
        
//
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
   
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

