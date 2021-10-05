//
//  RegisterViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    
    var frameView: UIView!
    
    var isRegistered = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourBackImage = UIImage(named: "back tabbar")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = .black

        nameTextField.setBottomBorder()
        nicknameTextField.setBottomBorder()
        
        // keyboard
        self.frameView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
                self.view.addGestureRecognizer(tap)
        nameTextField.delegate = self
        nicknameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        rePasswordTextField.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidLayoutSubviews() {
        photoImageView.layer.cornerRadius = photoImageView.bounds.width/2
        editBtn.layer.cornerRadius = editBtn.bounds.width/2
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1 :
            let theTxtField = self.view?.viewWithTag(2) as? UITextField
            theTxtField?.becomeFirstResponder()
        case 2 :
            let theTxtField = self.view?.viewWithTag(3) as? UITextField
            theTxtField?.becomeFirstResponder()
        case 3 :
            let theTxtField = self.view?.viewWithTag(4) as? UITextField
            theTxtField?.becomeFirstResponder()
        case 4 :
            let theTxtField = self.view?.viewWithTag(5) as? UITextField
            theTxtField?.becomeFirstResponder()
        case 5 :
            let theTxtField = self.view?.viewWithTag(6) as? UITextField
            theTxtField?.becomeFirstResponder()
        case 6 :
            self.view.endEditing(true)
        default:
            break
        }
        return true
    }
    
    @objc func dismissKeyBoard() {
            self.view.endEditing(true)
        }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        let resizeImage = self.resizeImage(image: image!, targetSize: CGSize(width: 128.0, height: 128.0))
    photoImageView.image = resizeImage
    dismiss(animated: true, completion: nil)
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

    @IBAction func editPhotoBtnPressed(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        
        let imageAlertController = UIAlertController(title: "選擇相片", message: "", preferredStyle: .actionSheet)
        let imageFromLibAction = UIAlertAction(title: "從相簿選取", style: .default) { (Void) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imageController.sourceType = .photoLibrary
                self.present(imageController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "照相", style: .default) { (Void) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imageController.sourceType = .camera
                self.present(imageController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            imageController.dismiss(animated: true, completion: nil)
        }
        imageAlertController.addAction(imageFromCameraAction)
        imageAlertController.addAction(imageFromLibAction)
        imageAlertController.addAction(cancelAction)
        
        present(imageAlertController, animated: true, completion: nil)
    }
    @IBAction func checkBtnPressed(_ sender: Any) {
        if checkBtn.tag == 1{
            checkBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            checkBtn.tag = 2
        } else {
            checkBtn.setImage(UIImage(systemName: "square"), for: .normal)
            checkBtn.tag = 1
        }
    }
    @IBAction func userTermsBtnPressed(_ sender: Any) {
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
        checkPhone()
        
        if nameTextField.text?.isEmpty == true {
           let controller = UIAlertController(title: "姓名欄位不可為空白", message: "請填入姓名", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           controller.addAction(okAction)
           present(controller, animated: true, completion: nil)
    } else if nicknameTextField.text?.isEmpty == true {
        let controller = UIAlertController(title: "暱稱欄位不可為空白", message: "請填入暱稱", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
 } else if phoneTextField.text?.isEmpty == true {
     let controller = UIAlertController(title: "手機號碼欄位不可為空白", message: "請填入手機號碼", preferredStyle: .alert)
     let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
     controller.addAction(okAction)
     present(controller, animated: true, completion: nil)
 } else if isRegistered == true {
     let controller = UIAlertController(title: "此電話號碼已註冊過", message: "", preferredStyle: .alert)
     let backToHomeAction = UIAlertAction(title: "回首頁", style: .default) { _ in
         if let controller = self.storyboard?.instantiateViewController(withIdentifier: "beginTabbar") as? UITabBarController {
//             let navigationController = UINavigationController(rootViewController: controller)
//             navigationController.modalPresentationStyle = .fullScreen
//             self.present(navigationController, animated: true, completion: nil)
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: false, completion: nil)
         }
     }
     let reInputAction = UIAlertAction(title: "重新輸入", style: .default, handler: nil)
     controller.addAction(backToHomeAction)
     controller.addAction(reInputAction)
     present(controller, animated: true, completion: nil)
     
 } else if passwordTextField.text?.isEmpty == true {
    let controller = UIAlertController(title: "密碼欄位不可為空白", message: "請填入密碼", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    controller.addAction(okAction)
    present(controller, animated: true, completion: nil)
} else if rePasswordTextField.text != passwordTextField.text {
    let controller = UIAlertController(title: "請再次確認密碼是否輸入相同", message: "", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    controller.addAction(okAction)
    present(controller, animated: true, completion: nil)
} else if checkBtn.tag == 1 {
    let controller = UIAlertController(title: "請勾選同意條款", message: "", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    controller.addAction(okAction)
    present(controller, animated: true, completion: nil)
} else {
    if let controller = storyboard?.instantiateViewController(withIdentifier: "registerVeri") as? RegisterVerificationCodeViewController {
        controller.tempPhotoImage = photoImageView.image
        controller.tempNameLabel = nameTextField.text ?? ""
        controller.tempNicknameLabel = nicknameTextField.text ?? ""
        if emailTextField.text == "" {
            controller.tempEmailLabel = "(非必填)"
        } else {
        controller.tempEmailLabel = emailTextField.text ?? ""
        }
        controller.tempPhoneLabel = phoneTextField.text ?? ""
        controller.tempAccountLabel = phoneTextField.text ?? ""
        controller.tempPasswordLabel = passwordTextField.text ?? ""
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true, completion: nil)
    }
}
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
                
                self.isRegistered = responseJSON["result"]! as? Bool ?? true
                
            }
        }
        task.resume()
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
