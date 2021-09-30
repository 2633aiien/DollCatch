//
//  MoreFollowViewController.swift
//  DollCatch
//
//  Created by allen on 2021/9/17.
//

import UIKit

class MoreFollowViewController: UIViewController {
    @IBOutlet var containers: [UIView]!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentControl.selectedSegmentIndex = 0
        firstView.isHidden = false
        secondView.isHidden = true
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func mapBtn(_ sender: Any) {
    }
    @IBAction func segmentControlTap(_ sender: UISegmentedControl) {
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
