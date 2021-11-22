//
//  ForgetPasswordViewController.swift
//  DollCatch
//
//  Created by allen on 2021/9/2.
//

import UIKit

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var phoneTextField: UITextField!
    
    var userId = ""
    var isRegistered = true
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTextField.delegate = self
    }
    @IBAction func continueBtnPressed(_ sender: Any) {
        checkPhone()
    }
    
    func checkPhone() {
        let url = URL(string: "https://www.surveyx.tw/funchip/check_phone_no.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        
            json = [
                "phone_no":"\(phoneTextField.text ?? "")"
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                self.userId = responseJSON["userId"] as? String ?? ""
                self.isRegistered = responseJSON["result"] as? Bool ?? true
                if self.isRegistered == false {
                    let controller = UIAlertController(title: "此電話號碼無註冊", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    DispatchQueue.main.async {
                        self.present(controller, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "verify") as? VerificationCodeViewController {
                        controller.userId = self.userId
                        controller.phoneNumber = self.phoneTextField.text ?? ""
                        let navigationController = UINavigationController(rootViewController: controller)
                        navigationController.modalPresentationStyle = .fullScreen
                            self.present(navigationController, animated: true, completion: nil)
                        }
                    }
                }
                
            }
        }
        task.resume()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
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
