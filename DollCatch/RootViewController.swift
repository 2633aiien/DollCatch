//
//  RootViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/18.
//

import UIKit

class RootViewController: UIViewController {
    let fullScreenSize = UIScreen.main.bounds.size
    var loginBtn = UIButton(type: .system)
    var announcementBtn = UIButton(type: .system)
    var QABtn = UIButton(type: .system)
    var privacyBtn = UIButton(type: .system)
    var contactBtn = UIButton(type: .system)
    var photoImageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 255/255, green: 170/255, blue: 0/255, alpha: 1.0)
        
        photoImageView = UIImageView(frame: CGRect(x: 80, y: 230, width: 90, height: 90))
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 45
        photoImageView.image = UIImage(named: "image")
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.backgroundColor = .white
        self.view.addSubview(photoImageView)
        
        loginBtn = UIButton(frame: CGRect(x: 170, y: 230, width: 140, height: 90))
        loginBtn.setTitle("   登入        >", for: .normal)
        loginBtn.setTitleColor(.label, for: .normal)
        loginBtn.contentHorizontalAlignment = .left
        //loginBtn.backgroundColor = .green
        //loginBtn.setImage(UIImage(named: "user-1"), for: .normal)
        self.view.addSubview(loginBtn)
        
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
    @objc func AnnouncementBtnPressed() {
        announcementBtn.backgroundColor = .tertiaryLabel
        QABtn.backgroundColor = .clear
        privacyBtn.backgroundColor = .clear
        contactBtn.backgroundColor = .clear
        
        print("公告")
    }
    @objc func QABtnPressed() {
        announcementBtn.backgroundColor = .clear
        QABtn.backgroundColor = .tertiaryLabel
        privacyBtn.backgroundColor = .clear
        contactBtn.backgroundColor = .clear
        print("Q&A")
    }
    @objc func privacyBtnPressed() {
        announcementBtn.backgroundColor = .clear
        QABtn.backgroundColor = .clear
        privacyBtn.backgroundColor = .tertiaryLabel
        contactBtn.backgroundColor = .clear
        print("隱私權協議")
    }
    @objc func contactBtnPressed() {
        announcementBtn.backgroundColor = .clear
        QABtn.backgroundColor = .clear
        privacyBtn.backgroundColor = .clear
        contactBtn.backgroundColor = .tertiaryLabel
        print("聯絡我們")
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
