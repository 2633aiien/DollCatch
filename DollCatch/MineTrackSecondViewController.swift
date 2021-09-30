//
//  MineTrackSecondViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/25.
//

import UIKit
import CoreData

class MineTrackSecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var myCollectionView: UICollectionView!
    var width = Int(UIScreen.main.bounds.width)-40
    var height = 120
    var machineArr : [newMachine] = []
    var userData : [UserInformationClass] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return machineArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineTrackSecondCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(machineArr[indexPath.row].userId)/machine_photo_\(machineArr[indexPath.row].id)_6")! , imageView: cell.myImageView)
        cell.myTitleLabel.text = machineArr[indexPath.row].title
        let str = machineArr[indexPath.row].address_machine
        if (str.rangeOfCharacter(from: CharacterSet(charactersIn: "區")) != nil) {
            let index = str.firstIndex(of: "區")
            let str3 = str[...index!]
            cell.myLocationLabel.text = String(str3)
        } else {
            cell.myLocationLabel.text = machineArr[indexPath.row].address_machine
        }
        cell.myNameLabel.text = machineArr[indexPath.row].manager
        let time = timeStringToDate(machineArr[indexPath.row].updateDate)
        cell.myTimeLabel.text = time
        cell.shareBtn.setImage(UIImage(named: "12"), for: .normal)
        
        cell.shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(follow(_ :)), for: .touchUpInside)
            cell.heartBtn.setImage(UIImage(named: "followed"), for: .normal)
        
        cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(14)
        cell.myNameLabel.font = cell.myNameLabel.font.withSize(14)
        cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(14)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let followM = machineArr[indexPath.row]
        if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as? MachineIntroViewController {
            controller.tempIsStore = followM.isStore
            controller.tempTitle = followM.title
            controller.tempId = followM.id
            controller.tempUserId = followM.userId
            controller.tempAddress = followM.address_machine
            controller.tempDescription = followM.description
            controller.tempStoreName = followM.store_name
            controller.tempManager = followM.manager
            controller.tempLine = followM.line_id
            controller.tempPhone = followM.phone_no
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryFromCoreData()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        
        myCollectionView.collectionViewLayout = layout
        
        myCollectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: "MineTrackSecondCollectionViewCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        machineArr.removeAll()
        if !userData .isEmpty {
        getNewMachineItems()
        }
        myCollectionView.reloadData()
    }
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                imageView.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func getNewMachineItems() {
        // web service Url
        let url = URL(string: "https://www.surveyx.tw/funchip/follow_machine.php")!
        // json data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "userId": "\((userData.first?.userId)!)",
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    // succceeded
                    
                    // Call the parse json function on the data
                    self.parseNewMachineJson(data: data!)
                    
                } else {
                    print("error: \(error)")
                }
            }
            // start the task
            task.resume()
    }
    func parseNewMachineJson(data: Data) {
        
        // Parse the data into struct
        do {
            // Parse the data into a jsonObject
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            for jsonResult in jsonArray {
                // json result as a dictionary
                let jsonDict = jsonResult as! [String:Any]
                let isStore : Bool = jsonDict["isStore"] as! Bool
                let id : String = jsonDict["id"] as! String
                let userId : String = jsonDict["userId"] as! String
                let title : String = jsonDict["title"] as? String ?? "null"
                let description : String = jsonDict["description"] as? String ?? "null"
                let address_machine : String = jsonDict["address_machine"] as? String ?? "null"
                let store_name : String = jsonDict["store_name"] as? String ?? "null"
                let manager : String = jsonDict["manager"] as? String ?? "null"
                let phone_no : String = jsonDict["phone_no"] as? String ?? "null"
                let line_id : String = jsonDict["line_id"] as? String ?? "null"
                let activity_id : Int = jsonDict["activity_id"] as? Int ?? 0
                let remaining_push : Int = jsonDict["remaining_push"] as? Int ?? 0
                let announceDate : String = jsonDict["announceDate"] as? String ?? "null"
                let clickTime : Int = jsonDict["clickTime"] as? Int ?? 0
                let latitude : Double = jsonDict["latitude"] as? Double ?? 0
                let longitude : Double = jsonDict["longitude"] as? Double ?? 0
                let createDate : String = jsonDict["createDate"] as! String
                let updateDate : String = jsonDict["updateDate"] as! String
                let isFollow : Bool = jsonDict["isFollow"] as! Bool
                
                // Create new Machine and set its properties
                let machine = newMachine(isFollow: isFollow, isStore: isStore, id: id, userId: userId, title: title, description: description, address_machine: address_machine, store_name: store_name, manager: manager, phone_no: phone_no, line_id: line_id, activity_id: activity_id, remaining_push: remaining_push, announceDate: announceDate, clickTime: clickTime, latitude: latitude, longitude: longitude, createDate: createDate, updateDate: updateDate)
                //Add it to the array
                machineArr.append(machine)
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }
        }
        catch {
            print("There was an error")
        }
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
    
    @objc func share() {
        let activityVC = UIActivityViewController(activityItems: ["Let me recommend you this application https://www.surveyx.tw/"], applicationActivities: nil)
            // 顯示出我們的 activityVC。
            self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func follow(_ sender : UIButton) {
        
        postFollow(index: sender.tag)
        if machineArr[sender.tag].isFollow == true {
            machineArr[sender.tag].isFollow = false
            sender.setImage(UIImage(named: "unfollow"), for: .normal)
        } else {
            machineArr[sender.tag].isFollow = true
            sender.setImage(UIImage(named: "followed"), for: .normal)
        }
    }
    func postFollow(index: Int) {
        let url = URL(string: "https://www.surveyx.tw/funchip/click_follow_machine.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        if machineArr[index].isFollow == true {
            json = [
                "userId": "\(userData[0].userId)",
                "objectId": "\(machineArr[index].id)"
            ]
        } else {
            json = [
                "isFollow": "\(machineArr[index].isFollow)",
                "userId": "\(userData[0].userId)",
                "objectId": "\(machineArr[index].id)"
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

    func timeStringToDate(_ dateStr:String, format: String = "yyyy-MM-dd HH:mm:ss") ->String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale  // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat =  format
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = "MM/dd HH:mm"
        dateFormatter.locale = tempLocale // reset the locale
        guard let getdate = date else {
              return ""
            }

            let dateString = dateFormatter.string(from: getdate)
            return dateString
    }
    
}
