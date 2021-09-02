//
//  NewMachineViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit

class NewMachineViewController: UIViewController {
    @IBOutlet var containers: [UIView]!
    @IBOutlet weak var firstVIew: UIView!
    @IBOutlet weak var secondView: UIView!
    
    var isShop : Bool!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let yourBackImage = UIImage(named: "back tabbar")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = .black
        if isShop == true {
        self.segmentControl.selectedSegmentIndex = 0
            firstVIew.isHidden = true
            secondView.isHidden = false
        } else {
            self.segmentControl.selectedSegmentIndex = 1
            firstVIew.isHidden = false
            secondView.isHidden = true
        }
    }

    @IBAction func shopMachine(_ sender: UISegmentedControl) {
        containers.forEach {
               $0.isHidden = true
            }
        containers[sender.selectedSegmentIndex].isHidden = false
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
