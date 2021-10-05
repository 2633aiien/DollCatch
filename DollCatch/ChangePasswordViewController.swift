//
//  ChangePasswordViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import CoreData

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var againNewPasswordField: UITextField!
    var userdata : [UserInformationClass] = []
    
    var result = false
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordField.delegate = self
        newPasswordField.delegate = self
        againNewPasswordField.delegate = self
        photoImageView.layer.cornerRadius = photoImageView.bounds.width/2
        queryFromCoreData()
        downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(userdata[0].userId)/person_photo")! )
    }
    @IBAction func returnBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        if self.newPasswordField.text != self.againNewPasswordField.text || self.newPasswordField.text == ""{
                let controller = UIAlertController(title: "請確認新密碼是否輸入相同", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
            DispatchQueue.main.async {
                self.present(controller, animated: true, completion: nil)
            }
            return
        }
        let url = URL(string: "https://www.surveyx.tw/funchip/update_user_password.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
            json = [
                "old_password": "\(oldPasswordField.text!)",
                "new_password": "\(newPasswordField.text!)",
                "userId": "\(userdata[0].userId)"
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
                if responseJSON["result"]! as! Bool == false && responseJSON["message"]! as! String == "密碼錯誤"{
                    let controller = UIAlertController(title: "密碼錯誤", message: "", preferredStyle: .alert)
                    let backToHomeAction = UIAlertAction(title: "上一步", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                        }
                    let reInputAction = UIAlertAction(title: "重新輸入", style: .default, handler: nil)
                    controller.addAction(backToHomeAction)
                    controller.addAction(reInputAction)
                    DispatchQueue.main.async {
                        self.present(controller, animated: true, completion: nil)
                    }
                }  else if responseJSON["result"]! as! Bool == true {
                    
                    let controller = UIAlertController(title: "密碼更改成功", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確認", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    controller.addAction(okAction)
                    DispatchQueue.main.async {
                    self.present(controller, animated: true, completion: nil)
                    }
                }
                    
            }
            
        }
        task.resume()
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func queryFromCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<UserInformationClass>(entityName: "UserInformationClass")
        
        moc.performAndWait {
            do{
                self.userdata = try moc.fetch(fetchRequest)//查詢，回傳為[Note]
            }catch{
                print("error \(error)")
                self.userdata = []//如果有錯，回傳空陣列
            }
        }
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.photoImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // textfield return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
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
