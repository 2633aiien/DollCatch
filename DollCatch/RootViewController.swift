//
//  RootViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/18.
//

import UIKit
import CoreData

class RootViewController: UIViewController {
    let fullScreenSize = UIScreen.main.bounds.size
    var loginBtn = UIButton(type: .system)
    var announcementBtn = UIButton(type: .system)
    var QABtn = UIButton(type: .system)
    var privacyBtn = UIButton(type: .system)
    var contactBtn = UIButton(type: .system)
    var photoImageView : UIImageView!
    var userData : [UserInformationClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        queryFromCoreData()
        
        view.backgroundColor = UIColor(red: 255/255, green: 170/255, blue: 0/255, alpha: 1.0)
        
        announcementBtn = UIButton(frame: CGRect(x: 80, y: 350, width: 230, height: 60))
        announcementBtn.setTitle("   公告", for: .normal)
        announcementBtn.setTitleColor(.label, for: .normal)
        announcementBtn.contentHorizontalAlignment = .left
        announcementBtn.addTarget(self, action: #selector(AnnouncementBtnPressed), for: .touchUpInside)
        self.view.addSubview(announcementBtn)
        
        QABtn = UIButton(frame: CGRect(x: 80, y: 410, width: 230, height: 60))
        QABtn.setTitle("   Q&A", for: .normal)
        QABtn.setTitleColor(.label, for: .normal)
        QABtn.contentHorizontalAlignment = .left
        QABtn.addTarget(self, action: #selector(QABtnPressed), for: .touchUpInside)
        self.view.addSubview(QABtn)
        
        privacyBtn = UIButton(frame: CGRect(x: 80, y: 470, width: 230, height: 60))
        privacyBtn.setTitle("   隱私權協議", for: .normal)
        privacyBtn.setTitleColor(.label, for: .normal)
        privacyBtn.contentHorizontalAlignment = .left
        privacyBtn.addTarget(self, action: #selector(privacyBtnPressed), for: .touchUpInside)
        self.view.addSubview(privacyBtn)
        
        contactBtn = UIButton(frame: CGRect(x: 80, y: 530, width: 230, height: 60))
        contactBtn.setTitle("   聯絡我們", for: .normal)
        contactBtn.setTitleColor(.label, for: .normal)
        contactBtn.contentHorizontalAlignment = .left
        contactBtn.addTarget(self, action: #selector(contactBtnPressed), for: .touchUpInside)
        self.view.addSubview(contactBtn)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        photoImageView = UIImageView(frame: CGRect(x: 80, y: 230, width: 90, height: 90))
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 45
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.backgroundColor = .white
        photoImageView.image = UIImage(named: "image")
        loginBtn = UIButton(frame: CGRect(x: 170, y: 230, width: 140, height: 90))
        loginBtn.setTitleColor(.label, for: .normal)
        loginBtn.contentHorizontalAlignment = .left
        if userData.isEmpty {
            photoImageView.image = UIImage(named: "image")
        loginBtn.setTitle("   登入        >", for: .normal)
        loginBtn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        } else {
            
            downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(userData[0].userId)/person_photo")! )
            loginBtn.setTitle("   \(userData[0].nickname)        >", for: .normal)
            loginBtn.addTarget(self, action: #selector(personalInformation), for: .touchUpInside)
        }
        self.view.addSubview(photoImageView)
        self.view.addSubview(loginBtn)
        
    }
    @objc func loginBtnPressed() {
        print("login")
        if let controller = storyboard?.instantiateViewController(withIdentifier: "login") {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
        }
            
    }
    @objc func personalInformation() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "personalInformation") {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
        }
    }
    @objc func AnnouncementBtnPressed() {
        let urlString = "http://www.surveyx.tw/funchip/announcement.html"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        announcementBtn.backgroundColor = .tertiaryLabel
        QABtn.backgroundColor = .clear
        privacyBtn.backgroundColor = .clear
        contactBtn.backgroundColor = .clear
        
        print("公告")
    }
    @objc func QABtnPressed() {
        let urlString = "http://www.surveyx.tw/funchip/qa.html"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        announcementBtn.backgroundColor = .clear
        QABtn.backgroundColor = .tertiaryLabel
        privacyBtn.backgroundColor = .clear
        contactBtn.backgroundColor = .clear
        print("Q&A")
    }
    @objc func privacyBtnPressed() {
        let urlString = "http://www.surveyx.tw/funchip/privacy.html"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        announcementBtn.backgroundColor = .clear
        QABtn.backgroundColor = .clear
        privacyBtn.backgroundColor = .tertiaryLabel
        contactBtn.backgroundColor = .clear
        print("隱私權協議")
    }
    @objc func contactBtnPressed() {
        let urlString = "http://www.surveyx.tw/funchip/contact_us.html"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        announcementBtn.backgroundColor = .clear
        QABtn.backgroundColor = .clear
        privacyBtn.backgroundColor = .clear
        contactBtn.backgroundColor = .tertiaryLabel
        print("聯絡我們")
    }
    
    func queryFromCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<UserInformationClass>(entityName: "UserInformationClass")
        
        moc.performAndWait {
            do{
                self.userData = try moc.fetch(fetchRequest)//查詢，回傳為[Note]
            }catch{
                print("error \(error)")
                self.userData = []//如果有錯，回傳空陣列
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
                print("data: \(data),\(response?.url)")
                self?.photoImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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

