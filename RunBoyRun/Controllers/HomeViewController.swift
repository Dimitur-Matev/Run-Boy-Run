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
    @IBAction func startB (sender: UIButton!) {
        
        performSegue(withIdentifier: "second", sender: self)

    }
    @IBOutlet weak var startA: UIButton!
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
        //        StartB.setTitle("Start", for: .normal)
        playList.layer.cornerRadius = 10
        playList.clipsToBounds = true
        playList.setTitle("Select Playlist", for: .normal)
        spotifyButton.setTitle("Spotify", for: .normal)
        spotifyButton.clipsToBounds = true
        spotifyButton.layer.cornerRadius = 10
        

        pickerView.delegate = self
        pickerView.dataSource = self
//        let storyBoard : UIStoryboard = UIStoryboard(name: "main", bundle:nil)

//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "second") as! SecondViewController
//        self.present(nextViewController, animated:true, completion:nil)
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
           return 300
       }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?  {
           return String(row + 1)
       }
    
    
}

extension UIButton {
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
    
}
