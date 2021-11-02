//
//  RegisterVerificationCodeViewController.swift
//  DollCatch
//
//  Created by allen on 2021/9/2.
//

import UIKit
import FirebaseAuth
import Alamofire

class RegisterVerificationCodeViewController: UIViewController,UITextFieldDelegate, MyTextFieldDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var first: MyTextField!
    @IBOutlet weak var second: MyTextField!
    @IBOutlet weak var third: MyTextField!
    @IBOutlet weak var fourth: MyTextField!
    @IBOutlet weak var fifth: MyTextField!
    @IBOutlet weak var sixth: MyTextField!
    
    var tempPhotoImage : UIImage!
    var tempNameLabel = ""
    var tempNicknameLabel = ""
    var tempEmailLabel = ""
    var tempPhoneLabel = ""
    var tempAccountLabel = ""
    var tempPasswordLabel = ""
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().languageCode = "zh-TW"

        photoImageView.image = tempPhotoImage
        nameLabel.text = "姓名：\(tempNameLabel)"
        nicknameLabel.text = "暱稱：\(tempNicknameLabel)"
        emailLabel.text = "電子信箱：\(tempEmailLabel)"
        phoneLabel.text = "手機號碼：\(tempPhoneLabel)"
        accountLabel.text = "帳號：\(tempAccountLabel)"
        passwordLabel.text = "密碼：\(tempPasswordLabel)"
        
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        fifth.delegate = self
        sixth.delegate = self
        
        first.myDelegate = self
        second.myDelegate = self
        third.myDelegate = self
        fourth.myDelegate = self
        fifth.myDelegate = self
        sixth.myDelegate = self
        
    }
    override func viewDidLayoutSubviews() {
        photoImageView.layer.cornerRadius = photoImageView.bounds.width/2
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    @IBAction func sendVeriCodeBtnPressed(_ sender: Any) {
        print("phone: \(tempPhoneLabel)")
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+886\(tempPhoneLabel)" , uiDelegate: nil) { verificationID, error in
              if let error = error {
                  print("error: \(error)")
                  return
                  }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
              print("get code success")
            }
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let verificationCode = "\(first.text!)\(second.text!)\(third.text!)\(fourth.text!)\(fifth.text!)\(sixth.text!)"
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
              let authError = error as NSError
              if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                // The user is a multi-factor user. Second factor challenge is required.
                let resolver = authError
                  .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                var displayNameString = ""
                for tmpFactorInfo in resolver.hints {
                  displayNameString += tmpFactorInfo.displayName ?? ""
                  displayNameString += " "
                }
//                self.showTextInputPrompt(
//                  withMessage: "Select factor to sign in\n\(displayNameString)",
//                  completionBlock: { userPressedOK, displayName in
//                    var selectedHint: PhoneMultiFactorInfo?
//                    for tmpFactorInfo in resolver.hints {
//                      if displayName == tmpFactorInfo.displayName {
//                        selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
//                      }
//                    }
//                    PhoneAuthProvider.provider()
//                      .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
//                                         multiFactorSession: resolver
//                                           .session) { verificationID, error in
//                        if error != nil {
//                          print(
//                            "Multi factor start sign in failed. Error: \(error.debugDescription)"
//                          )
//                        } else {
//                          self.showTextInputPrompt(
//                            withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
//                            completionBlock: { userPressedOK, verificationCode in
//                              let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
//                                .credential(withVerificationID: verificationID!,
//                                            verificationCode: verificationCode!)
//                              let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
//                                .assertion(with: credential!)
//                              resolver.resolveSignIn(with: assertion!) { authResult, error in
//                                if error != nil {
//                                  print(
//                                    "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
//                                  )
//                                } else {
//                                  self.navigationController?.popViewController(animated: true)
//                                }
//                              }
//                            }
//                          )
//                        }
//                      }
//                  }
//                )
              } else {
                print(error.localizedDescription)
                return
              }
              // ...
              return
            }
            // User is signed in
            self.postRegister()
            print("maybe post success")
            
        }
    }
    
    func postRegister() {
        let url = URL(string: "https://www.surveyx.tw/funchip/register.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
            json = [
                "name": "\(tempNameLabel)",
                "nickname": "\(tempNicknameLabel)",
                "phoneNo": "\(tempPhoneLabel)",
                "email":"\(tempEmailLabel)",
                "password":"\(tempPasswordLabel)",
                "device_id":"\(token)"
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            self.postPhotoImage()
            
        }
        task.resume()
        }
    
    func postPhotoImage() {
        do {
                let url = URL(string: "https://www.surveyx.tw/funchip/upload_image.php")
                
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
                
                let boundary = generateBoundaryString()

              //define the multipart request type

                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
            if (self.tempPhotoImage == nil)
                {
                    return
                }
                
            let image_data = self.tempPhotoImage!.pngData()
                
                
                if(image_data == nil)
                {
                    return
                }
                

                var body = Data()
                
                let fname = "test.png"
                let mimetype = "image/png"
                
            //define the data post parameter

            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("hi\r\n".data(using: String.Encoding.utf8)!)

                
                
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"uploaded_file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(image_data!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                
                
                body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            //try

            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"phone_no\"; filename=\"\(tempPhoneLabel)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image_data!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            //
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                
                
            request.httpBody = body
                
                
                
                let session = URLSession.shared

                
            let task = session.dataTask(with: request) {
                    (
                        data, response, error) in
                    
                guard let _:Data = data, let _:URLResponse = response, error == nil else {
                        print("error")
                        return
                    }
                    
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(dataString)
                
                DispatchQueue.main.async {
                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "beginTabbar") as? UITabBarController {
                        
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: false, completion: nil)
                    }
                }
                    
                }
                
                task.resume()
                
                
            }
            
            
            func generateBoundaryString() -> String
            {
                return "Boundary-\(NSUUID().uuidString)"
            }
    }
    
    
    // codeTextField
    
    func textFieldDidDelete() {
        if activeTextField == first {
                print("backButton was pressed in otpTextField1")
                // do nothing
            }

            if activeTextField == second {
                print("backButton was pressed in otpTextField2")
                second.isEnabled = false
                first.isEnabled = true
                first.becomeFirstResponder()
                first.text = ""
            }

            if activeTextField == third {
                print("backButton was pressed in otpTextField3")
                third.isEnabled = false
                second.isEnabled = true
                second.becomeFirstResponder()
                second.text = ""
            }

            if activeTextField == fourth {
                print("backButton was pressed in otpTextField4")
                fourth.isEnabled = false
                third.isEnabled = true
                third.becomeFirstResponder()
                third.text = ""
            }
        if activeTextField == fifth {
            print("backButton was pressed in otpTextField4")
            fifth.isEnabled = false
            fourth.isEnabled = true
            fourth.becomeFirstResponder()
            fourth.text = ""
        }
        if activeTextField == sixth {
            print("backButton was pressed in otpTextField4")
            sixth.isEnabled = false
            fifth.isEnabled = true
            fifth.becomeFirstResponder()
            fifth.text = ""
        }

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {

                // 10. when the user enters something in the first textField it will automatically adjust to the next textField and in the process do some disabling and enabling. This will proceed until the last textField
                if (text.count < 1) && (string.count > 0) {

                    if textField == first {
                        first.isEnabled = false
                        second.isEnabled = true
                        second.becomeFirstResponder()
                    }

                    if textField == second {
                        second.isEnabled = false
                        third.isEnabled = true
                        third.becomeFirstResponder()
                    }

                    if textField == third {
                        third.isEnabled = false
                        fourth.isEnabled = true
                        fourth.becomeFirstResponder()
                    }

                    if textField == fourth {
                        fourth.isEnabled = false
                        fifth.isEnabled = true
                        fifth.becomeFirstResponder()
                    }
                    if textField == fifth {
                        fifth.isEnabled = false
                        sixth.isEnabled = true
                        sixth.becomeFirstResponder()
                    }
                    if textField == sixth {
                        
                    }

                    textField.text = string
                    return false

                } // 11. if the user gets to the last textField and presses the back button everything above will get reversed
                else if (text.count >= 1) && (string.count == 0) {

                    if textField == second {
                        second.isEnabled = false
                        first.isEnabled = true
                        first.becomeFirstResponder()
                        first.text = ""
                    }

                    if textField == third {
                        third.isEnabled = false
                        second.isEnabled = true
                        second.becomeFirstResponder()
                        second.text = ""
                    }

                    if textField == fourth {
                        fourth.isEnabled = false
                        third.isEnabled = true
                        third.becomeFirstResponder()
                        third.text = ""
                    }
                    if textField == fifth {
                        fifth.isEnabled = false
                        fourth.isEnabled = true
                        fourth.becomeFirstResponder()
                        fourth.text = ""
                    }
                    if textField == sixth {
                        sixth.isEnabled = false
                        fifth.isEnabled = true
                        fifth.becomeFirstResponder()
                        fifth.text = ""
                    }

                    if textField == first {
                        // do nothing
                    }

                    textField.text = ""
                    return false

                } // 12. after pressing the backButton and moving forward again you will have to do what's in step 10 all over again
                else if text.count >= 1 {

                    if textField == first {
                        first.isEnabled = false
                        second.isEnabled = true
                        second.becomeFirstResponder()
                    }

                    if textField == second {
                        second.isEnabled = false
                        third.isEnabled = true
                        third.becomeFirstResponder()
                    }

                    if textField == third {
                        third.isEnabled = false
                        fourth.isEnabled = true
                        fourth.becomeFirstResponder()
                    }

                    if textField == fourth {
                        fourth.isEnabled = false
                        fifth.isEnabled = true
                        fifth.becomeFirstResponder()
                    }
                    if textField == fifth {
                        fifth.isEnabled = false
                        sixth.isEnabled = true
                        sixth.becomeFirstResponder()
                    }
                    if textField == sixth {
                        
                    }

                    textField.text = string
                    return false
                }
            }
            return true
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
