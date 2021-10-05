//
//  PersonalViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import CoreData

class PersonalViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var aboutUsBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var changePwView: UIView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var userdata : [UserInformationClass] = []
    var w = UIScreen.main.bounds.width
    

    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.setBottomBorder()
        nameField.delegate = self
        nickNameField.delegate = self
        emailField.delegate = self
        nickNameField.setBottomBorder()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        queryFromCoreData()
        downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(userdata[0].userId)/person_photo")! )
        print("userId: \(userdata[0].userId)")
        nameField.text = userdata[0].name
        nickNameField.text = userdata[0].nickname
        phoneLabel.text = userdata[0].phone
        emailField.text = userdata[0].email
        phoneLabel.text = userdata[0].phone
    }
    override func viewDidLayoutSubviews() {
        headImageView.layer.cornerRadius = headImageView.bounds.width/2
        editBtn.layer.cornerRadius = editBtn.bounds.width/2
        
    }
    func downloadImage(from url: URL) {
        
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.headImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    @IBAction func logout(_ sender: Any) {
        
        let moc = CoreDataHelper.shared.managedObjectContext()
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInformationClass")
                if  let result = try?  moc.fetch(fetchRequest){
                    for object in result {
                        moc.delete(object as! NSManagedObject)
                    }
                }
                do{
                    try moc.save()
                    print("saved")
                }catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
//        CoreDataHelper.shared.saveContext()
        queryFromCoreData()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
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
    // textfield return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
      }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    @IBAction func imageEditBtn(_ sender: Any) {
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        let resizeImage = self.resizeImage(image: image!, targetSize: CGSize(width: 128.0, height: 128.0))
    headImageView.image = resizeImage
        postPhotoImage()
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
    func postPhotoImage() {
        do {
                let url = URL(string: "https://www.surveyx.tw/funchip/upload_image.php")
                
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
                
                let boundary = generateBoundaryString()

              //define the multipart request type

                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
            if (self.headImageView.image == nil)
                {
                    return
                }
                
            let image_data = self.headImageView.image!.pngData()
                
                
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
            body.append("Content-Disposition:form-data; name=\"phone_no\"; filename=\"\(phoneLabel.text!)\"\r\n".data(using: String.Encoding.utf8)!)
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
                                    
                }
                
                task.resume()
                
                
            }
            
            
            func generateBoundaryString() -> String
            {
                return "Boundary-\(NSUUID().uuidString)"
            }
    }
    
    func updateCoredata() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<UserInformationClass>(entityName: "UserInformationClass")

        do {
            let results =
              try moc.fetch(fetchRequest)
            

            if results.count > 0 {
                results[0].name = nameField.text!
                results[0].nickname = nickNameField.text!
                results[0].email = emailField.text!
                try moc.save()
            }
        } catch {
            fatalError("\(error)")
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func editBtn(_ sender: Any) {
        self.title = "修改個人資料"
        nameField.isEnabled = true
        nickNameField.isEnabled = true
        emailField.isEnabled = true
        editButton.isHidden = true
        changePwView.isHidden = false
        returnButton.isHidden = false
        saveButton.isHidden = false
        aboutUsBtn.isHidden = true
        logoutBtn.isHidden = true
    }
    
    @IBAction func changePwBtn(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "changePassword")
        let navigationController = UINavigationController(rootViewController: controller!)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
    }
    @IBAction func returnBtn(_ sender: Any) {
        self.title = "個人資料"
        nameField.isEnabled = false
        nickNameField.isEnabled = false
        emailField.isEnabled = false
        editButton.isHidden = false
        changePwView.isHidden = true
        returnButton.isHidden = true
        saveButton.isHidden = true
        aboutUsBtn.isHidden = false
        logoutBtn.isHidden = false
    }
    @IBAction func saveBtn(_ sender: Any) {
        if nameField.text == "" {
            let controller = UIAlertController(title: "姓名欄位不可為空白", message: "請填入姓名", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if nickNameField.text == "" {
            let controller = UIAlertController(title: "暱稱欄位不可為空白", message: "請填入暱稱", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else {
        let url = URL(string: "https://www.surveyx.tw/funchip/update_user_information.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
            json = [
                "name": "\(nameField.text!)",
                "nickname": "\(nickNameField.text!)",
                "email": "\(emailField.text ?? "(非必填)")",
                "userId": "\(userdata[0].userId)"
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
        }
        task.resume()
            
            updateCoredata()
        self.title = "個人資料"
        nameField.isEnabled = false
        nickNameField.isEnabled = false
        emailField.isEnabled = false
        editButton.isHidden = false
        changePwView.isHidden = true
        returnButton.isHidden = true
        saveButton.isHidden = true
        aboutUsBtn.isHidden = false
        logoutBtn.isHidden = false
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


extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}
