//
//  MachineIntroViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import CoreData


class MachineIntroViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var followBtn: UIBarButtonItem!
    // both
    var tempIsFollow = false
    var tempIsStore = false
    var tempTitle = "aa"
    var tempId = ""
    var tempUserId = ""
    var tempAddress = "aa"
    var tempDescription = ""
    var tempManager = ""
    var tempLine = ""
    var tempPhone = ""
    var tempClass = ""
    var tempActivity = ""
    // machine
    var tempStoreName = ""
    // store
    var tempBig_machine_no = ""
    var tempMachine_no = ""
    var tempAir_condition = true
    var tempFan = true
    var tempWifi = true
    
    
    var classArr = [Bool]()
    
    var imageArr : [UIImageView] = []
    var imageView = UIImageView()
    
    var imageNameArr : [String] = []
    var imageDescribeArr : [String] = []
    
    var userData : [UserInformationClass] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if tempIsFollow == true {
            followBtn.image = UIImage(named: "followed")
            followBtn.tintColor = .systemPink
        } else {
            followBtn.image = UIImage(named: "unfollow")
            followBtn.tintColor = .black
        }
        queryFromCoreData()
        getClassItems()
        getActivity()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if tempIsStore == true {
            self.title = "店家介紹"
        } else {
            self.title = "機台介紹"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "FirstImageCell", for: indexPath)
            as! FirstImageCollectionViewCell
            if tempIsStore == true {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(tempUserId)/store_photo_\(tempId)_\(indexPath.row+6)")! , imageView: cell.myImageView)
            } else {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(tempUserId)/machine_photo_\(tempId)_\(indexPath.row+6)")! , imageView: cell.myImageView)
            }
            
            return cell
        } else {
            let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "SecondImageCell", for: indexPath)
            as! SecondImageCollectionViewCell
            if tempIsStore == true {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(tempUserId)/store_photo_\(tempId)_\(indexPath.row+1)")! , imageView: cell.myImageView)
            } else {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(tempUserId)/machine_photo_\(tempId)_\(indexPath.row+1)")! , imageView: cell.myImageView)
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "imageIntro") as? ImageIntroViewController {
                controller.index = indexPath.row
                controller.tempIsStore = tempIsStore
                controller.tempUserId = tempUserId
                controller.tempId = tempId
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "firstImage") as! FirstImageTableViewCell
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "firstCustomCell") as! FirstCustomTableViewCell
            cell.setUI(title: tempTitle, address: tempAddress, description: tempDescription)
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "secondCustomCell") as! SecondCustomTableViewCell
            if tempIsStore == true {
                cell.titleLabel.text = "店內資訊"
                cell.shopNameImageView.image = UIImage(named: "joystick-1")
                cell.shopNameLabel.text = "巨無霸台數：\(tempBig_machine_no)"
                cell.machine_no.isHidden = false
                cell.machine_noLabel.isHidden = false
                cell.isACImage.isHidden = false
                cell.ACLabel.isHidden = false
                cell.isFanImage.isHidden = false
                cell.FanLabel.isHidden = false
                cell.isWifiImage.isHidden = false
                cell.wifiLabel.isHidden = false
                cell.classfyImageView.isHidden = true
                cell.classLabel.isHidden = true
                cell.classfyTextView.isHidden = true
                if tempAir_condition == true {
                    cell.isACImage.image = UIImage(named: "画板 – 5")
                } else {
                    cell.isACImage.image = UIImage(named: "画板 – 4-1")
                }
                if tempFan == true {
                    cell.isFanImage.image = UIImage(named: "画板 – 5")
                } else {
                    cell.isFanImage.image = UIImage(named: "画板 – 4-1")
                }
                if tempWifi == true {
                    cell.isWifiImage.image = UIImage(named: "画板 – 5")
                } else {
                    cell.isWifiImage.image = UIImage(named: "画板 – 4-1")
                }
                
                cell.machine_noLabel.text = "標準台數：\(tempMachine_no)"
                
                cell.managerLabel.text = "管理者：\(tempManager)"
                cell.lineLabel.text = "LINE：\(tempLine)"
                cell.phoneLabel.text = "電話：\(tempPhone)"
            } else {
                cell.titleLabel.text = "機台資訊"
                cell.shopNameLabel.text = "店家名稱：\(tempStoreName)"
                cell.managerLabel.text = "管理者：\(tempManager)"
                cell.lineLabel.text = "LINE：\(tempLine)"
                cell.phoneLabel.text = "電話：\(tempPhone)"
                cell.classfyTextView.text = "\(tempClass)"
            }
            
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "thirdCustomCell") as! ThirdCustomTableViewCell
            cell.setUI(description: tempActivity)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "imageCustomCell") as! ImageTableViewCell
            if tempIsStore == true {
                cell.titleLabel.text = "店內機台"
            } else {
                cell.titleLabel.text = "商品介紹"
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.performBatchUpdates(nil)
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? FirstCustomTableViewCell {
            cell.hideDetailView()
        }
    }
    func downloadImage(from url: URL, imageView: UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                if UIImage(data: data) != nil {
                    imageView.image = UIImage(data: data)
                } else {
                    imageView.image = UIImage(named: "withoutImage")
                }
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getClassItems() {
        let url = URL(string: "https://www.surveyx.tw/funchip/get_machine_category.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "userId": "\(tempUserId)",
            "machineId": "\(tempId)"
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
                
                let ccc = responseJSON["ccc"]! as! Bool
                let groceries = responseJSON["groceries"]! as! Bool
                let toy = responseJSON["toy"]! as! Bool
                let figure = responseJSON["figure"]! as! Bool
                let doll = responseJSON["doll"]! as! Bool
                let bulk_goods = responseJSON["bulk_goods"]! as! Bool
                let other = responseJSON["other"]! as! Bool
                
                if ccc == true {
                    self.tempClass.append("3c ")
                }
                
                if groceries == true {
                    self.tempClass.append("雜貨 ")
                }
                if toy == true {
                    self.tempClass.append("玩具 ")
                }
                if figure == true {
                    self.tempClass.append("公仔 ")
                }
                if doll == true {
                    self.tempClass.append("娃娃 ")
                }
                if bulk_goods == true {
                    self.tempClass.append("大貨 ")
                }
                if other == true {
                    self.tempClass.append("其他")
                }
                if self.tempClass.count > 9 {
                    self.tempClass.insert("\n", at: self.tempClass.index(self.tempClass.startIndex, offsetBy: 9))
                    if self.tempClass.count > 19 {
                        self.tempClass.insert("\n", at: self.tempClass.index(self.tempClass.startIndex, offsetBy: 19))
                    }
                }
                
                
                print("字數：\(self.tempClass.count)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func getActivity() {
        let url = URL(string: "https://www.surveyx.tw/funchip/get_activity.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        if tempIsStore == true {
            json = [
                "storeId":"\(tempId)"
            ]
        } else {
            json = [
                "machineId":"\(tempId)"
            ]
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                self.tempActivity = responseJSON["content"]! as? String ?? ""
                
            }
        }
        task.resume()
    }
    
    // MARK: COREDATA
    
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
    
    
    @IBAction func followBtnPressed(_ sender: Any) {
        postFollow()
        if tempIsFollow == true {
            tempIsFollow = false
            followBtn.image = UIImage(named: "unfollow")
            followBtn.tintColor = .black
        } else {
            tempIsFollow = true
            followBtn.image = UIImage(named: "followed")
            followBtn.tintColor = .systemPink
        }
        
    }
    @IBAction func shareBtnPressed(_ sender: Any) {
    }
    
    func postFollow() {
        if tempIsStore == true {
            let url = URL(string: "https://www.surveyx.tw/funchip/click_follow_store.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            var json: [String: Any] = [:]
            if tempIsFollow == true {
                json = [
                    "userId": "\(userData[0].userId)",
                    "objectId": "\(tempId)"
                ]
            } else {
                json = [
                    "isFollow": "\(tempIsFollow)",
                    "userId": "\(userData[0].userId)",
                    "objectId": "\(tempId)"
                ]
            }
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
            }
            task.resume()
        } else {
        let url = URL(string: "https://www.surveyx.tw/funchip/click_follow_machine.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        if tempIsFollow == true {
            json = [
                "userId": "\(userData[0].userId)",
                "objectId": "\(tempId)"
            ]
        } else {
            json = [
                "isFollow": "\(tempIsFollow)",
                "userId": "\(userData[0].userId)",
                "objectId": "\(tempId)"
            ]
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
        }
        task.resume()
        }
    }
    
    
    @IBAction func backIba(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
