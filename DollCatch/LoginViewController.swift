//
//  LoginViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        continueBtn.layer.cornerRadius = 20
        backView.layer.cornerRadius = 15
//        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 145/255, blue: 0/255, alpha: 1.0)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func continueBtnPressed(_ sender: Any) {
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
