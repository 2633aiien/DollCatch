//
//  RegisterVerificationCodeViewController.swift
//  DollCatch
//
//  Created by allen on 2021/9/2.
//

import UIKit

class RegisterVerificationCodeViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var firstTextField: MyTextField!
    @IBOutlet weak var secondTextField: MyTextField!
    @IBOutlet weak var thirdTextField: MyTextField!
    @IBOutlet weak var fourthTextField: MyTextField!
    @IBOutlet weak var fifthTextField: MyTextField!
    @IBOutlet weak var sixthTextField: MyTextField!
    
    var tempPhotoImage : UIImage!
    var tempNameLabel = ""
    var tempNicknameLabel = ""
    var tempEmailLabel = ""
    var tempPhoneLabel = ""
    var tempAccountLabel = ""
    var tempPasswordLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = tempPhotoImage
        nameLabel.text = "姓名：\(tempNameLabel)"
        nicknameLabel.text = "暱稱：\(tempNicknameLabel)"
        emailLabel.text = "電子信箱：\(tempEmailLabel)"
        phoneLabel.text = "手機號碼：\(tempPhoneLabel)"
        accountLabel.text = "帳號：\(tempAccountLabel)"
        passwordLabel.text = "密碼：\(tempPasswordLabel)"
        
    }
    override func viewDidLayoutSubviews() {
        photoImageView.layer.cornerRadius = photoImageView.bounds.width/2
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    @IBAction func sendVeriCodeBtnPressed(_ sender: Any) {
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
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
