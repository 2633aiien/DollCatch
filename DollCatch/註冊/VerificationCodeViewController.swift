//
//  VerificationCodeViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import FirebaseAuth

class VerificationCodeViewController: UIViewController,UITextFieldDelegate, MyTextFieldDelegate {
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
    
    @IBOutlet weak var first: MyTextField!
    @IBOutlet weak var second: MyTextField!
    @IBOutlet weak var third: MyTextField!
    @IBOutlet weak var fourth: MyTextField!
    @IBOutlet weak var fifth: MyTextField!
    @IBOutlet weak var sixth: MyTextField!
    
    var activeTextField = UITextField()
    
    var userId = ""
    var phoneNumber = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+886\(phoneNumber)" , uiDelegate: nil) { verificationID, error in
              if let error = error {
                  print("error: \(error)")
                  return
                  }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            print("phone: \(self.phoneNumber)")
              print("get code success")
            }
    

        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChange(textField: UITextField){

        let text = textField.text

        if (text?.utf16.count)! >= 1{
            switch textField{
            case first:
                second.becomeFirstResponder()
            case second:
                third.becomeFirstResponder()
            case third:
                fourth.becomeFirstResponder()
            case fourth:
                fifth.becomeFirstResponder()
            case fifth:
                sixth.becomeFirstResponder()
            case sixth:
                sixth.resignFirstResponder()
            default:
                break
            }
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
    
    @IBAction func continueBtn(_ sender: Any) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let verificationCode = "\(first.text ?? "0")\(second.text ?? "0")\(third.text ?? "0")\(fourth.text ?? "0")\(fifth.text ?? "0")\(sixth.text ?? "0")"
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
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "changeForgetPw") as? ChangeForgetPwViewController {
                controller.userId = self.userId
                controller.phone = self.phoneNumber
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: false, completion: nil)
            }
            print("maybe post success")
            
        }
        
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
