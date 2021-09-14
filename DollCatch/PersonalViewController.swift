//
//  PersonalViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import CoreData

class PersonalViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
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
        nameField.text = userdata[0].name
        nickNameField.text = userdata[0].nickname
        emailField.text = userdata[0].email
        
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
