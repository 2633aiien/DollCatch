//
//  LoginViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/23.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var user = UserInformationStruct(phone: "",result: false, userId: "", name: "", nickname: "", email: "", level: "", photo_position: true)
    
    var userData : [UserInformationClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        continueBtn.layer.cornerRadius = 15
        backView.layer.cornerRadius = 15
        //        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 145/255, blue: 0/255, alpha: 1.0)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
    @IBAction func backBtn(_ sender: Any) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "beginTabbar") as? UITabBarController {
//            let navigationController = UINavigationController(rootViewController: controller)
//            navigationController.modalPresentationStyle = .fullScreen
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if( textField.tag == 10){
            
            let theTxtField = self.view?.viewWithTag(20) as? UITextField
            theTxtField?.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
        return true
    }
    @IBAction func continueBtn(_ sender: Any) {
        if accountTextField.text != "" && passwordTextField.text != "" {
            let url = URL(string: "https://www.surveyx.tw/funchip/log_in.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let json: [String: Any] = [
                "account": "\(accountTextField.text!)",
                "password": "\(passwordTextField.text!)"
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            print("account:\(accountTextField.text!),password:\(passwordTextField.text!)")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON["result"]!)
                    if responseJSON["result"]! as! Bool == true {
                        DispatchQueue.main.async {
                            self.errorLabel.isHidden = true
                            self.errorImage.isHidden = true
                        }
                        DispatchQueue.main.async {
                            self.user.phone = self.accountTextField.text!
                        }
                        
                        self.user.result = responseJSON["result"]! as! Bool
                        self.user.userId = responseJSON["userId"]! as! String
                        self.user.name = responseJSON["name"]! as! String
                        self.user.nickname = responseJSON["nickname"]! as! String
                        self.user.email = responseJSON["email"]! as! String
                        self.user.level = responseJSON["level"]! as! String
                        self.user.photo_position = responseJSON["photo_position"]! as! Bool

                        self.addCoreData()
                        self.queryFromCoreData()
                        print("這裏：\(self.userData[0].email)")
                        DispatchQueue.main.async {
                            self.uploadDeviceId()
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorImage.isHidden = false
                            self.errorLabel.isHidden = false
                        }
                        print("帳號或密碼錯誤")
                    }
                }
                
            }
            task.resume()
        }else {
            print("煤田")
            
        }
        
    }
    func uploadDeviceId() {
        let url = URL(string: "https://www.surveyx.tw/funchip/upload_deviceid.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "device_id": "\(token)",
            "userId": "\(userData[0].userId)"
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
                print(responseJSON["result"]!)
                if responseJSON["result"]! as! Bool == true {
                    print("device upload success.")
                }
    }
        }
        task.resume()
    }
    
    func queryFromCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<UserInformationClass>(entityName: "UserInformationClass")
        
        // let predicate = NSPredicate(format: "text = %@ and imageName != null", "New Note")
        //        let predicate = NSPredicate(format: "text contains[cd] %@","note")
        //        fetchRequest.predicate = predicate
        //排序
        //        let textOrder = NSSortDescriptor(key: "text", ascending: true)
        //        fetchRequest.sortDescriptors = [textOrder]
        
        moc.performAndWait {
            do{
                self.userData = try moc.fetch(fetchRequest)//查詢，回傳為[Note]
            }catch{
                print("error \(error)")
                self.userData = []//如果有錯，回傳空陣列
            }
        }
    }
    
    func addCoreData() {
        let context = CoreDataHelper.shared.managedObjectContext()
        let userC = NSEntityDescription.insertNewObject(forEntityName: "UserInformationClass", into: context) as! UserInformationClass
        userC.phone = user.phone
        userC.result = user.result
        userC.userId = user.userId
        userC.name = user.name
        userC.nickname = user.nickname
        userC.email = user.email
        userC.level = user.level
        userC.photo_position = user.photo_position
        
        CoreDataHelper.shared.saveContext()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }

}
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
