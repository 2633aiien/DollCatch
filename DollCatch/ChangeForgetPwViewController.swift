//
//  ChangeForgetPwViewController.swift
//  DollCatch
//
//  Created by allen on 2021/9/2.
//

import UIKit

class ChangeForgetPwViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    var userId = ""
    var phone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPasswordTextField.delegate = self
        rePasswordTextField.delegate = self

        downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(userId)/person_photo")! )
    }
    override func viewDidLayoutSubviews() {
        photoImageView.layer.cornerRadius = photoImageView.bounds.width/2
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                let image = UIImage(data: data)
                let resizeImage = self?.resizeImage(image: image!, targetSize: CGSize(width: 128, height: 128))
                self?.photoImageView.image = image
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    @IBAction func continueBtnPressed(_ sender: Any) {
        if newPasswordTextField.text == "" {
            let controller = UIAlertController(title: "新密碼欄位尚未輸入", message: "請填入新密碼", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if newPasswordTextField.text != rePasswordTextField.text{
            let controller = UIAlertController(title: "請確認密碼是否輸入相同", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else {
            postNewPassword()
        }
        
    }
    
    func postNewPassword() {
        if newPasswordTextField.text != "" && rePasswordTextField.text != "" {
            let url = URL(string: "https://www.surveyx.tw/funchip/forget_password_update.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let json: [String: Any] = [
                "phone_no": "\(phone)",
                "new_password": "\(newPasswordTextField.text!)"
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
                        DispatchQueue.main.async {
                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "beginTabbar") as? UITabBarController {
                                controller.modalPresentationStyle = .fullScreen
                                self.present(controller, animated: false, completion: nil)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            let controller = UIAlertController(title: "密碼更新失敗", message: "請稍後再試", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                }
                
            }
            task.resume()
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
