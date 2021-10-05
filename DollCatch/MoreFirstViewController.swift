//
//  MoreFirstViewController.swift
//  DollCatch
//
//  Created by allen on 2021/9/17.
//

import UIKit
import CoreData

class MoreFirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var userData : [UserInformationClass] = []
    var followArr : [FollowShopMachine] = []
    
    var width = Int(UIScreen.main.bounds.width)-40
    var height = 120
    
    var moreInt = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        queryFromCoreData()
        if !userData .isEmpty {
        getFollowShopItems()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        
        myCollectionView.collectionViewLayout = layout
        
        myCollectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: "MineTrackFirstCollectionViewCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !followArr .isEmpty {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineTrackFirstCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(followArr[indexPath.row].userId)/machine_photo_\(followArr[indexPath.row].id)_6")! , imageView: cell.myImageView)
        cell.myTitleLabel.text = followArr[indexPath.row].title
        let str = followArr[indexPath.row].address
        if (str.rangeOfCharacter(from: CharacterSet(charactersIn: "區")) != nil) {
            let index = str.firstIndex(of: "區")
            let str3 = str[...index!]
            cell.myLocationLabel.text = String(str3)
        } else {
            cell.myLocationLabel.text = followArr[indexPath.row].address
        }
        cell.myNameLabel.text = followArr[indexPath.row].manager
        let time = timeStringToDate(followArr[indexPath.row].updateDate)
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
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineTrackFirstCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newF = followArr[indexPath.row]
        if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as? MachineIntroViewController{
            controller.tempIsStore = newF.isStore
            controller.tempTitle = newF.title
            controller.tempId = newF.id
            controller.tempUserId = newF.userId
            controller.tempAddress = newF.address
            controller.tempDescription = newF.description
            controller.tempManager = newF.manager
            controller.tempLine = newF.line_id
            controller.tempPhone = newF.phone_no
            controller.tempBig_machine_no = newF.big_machine_no
            controller.tempMachine_no = newF.machine_no
            controller.tempAir_condition = newF.air_condition
            controller.tempFan = newF.fan
            controller.tempWifi = newF.wifi
            controller.tempStoreName = newF.store_name
            controller.tempIsFollow = newF.isFollow
            
            
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
    }
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

    func getFollowShopItems() {
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
                    self.parseFollowShopJson(data: data!)
                    
                } else {
                    print("error: \(error)")
                }
            }
            // start the task
            task.resume()
        
    }
    func parseFollowShopJson(data: Data) {
        
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
                let address : String = jsonDict["address_store"] as? String ?? "null"
                let big_machine_no : String = jsonDict["big_machine_no"] as? String ?? "null"
                let machine_no : String = jsonDict["machine_no"] as? String ?? "null"
                let manager : String = jsonDict["manager"] as? String ?? "null"
                let air_condition : Bool = jsonDict["air_condition"] as? Bool ?? false
                let fan : Bool = jsonDict["fan"] as? Bool ?? false
                let wifi : Bool = jsonDict["wifi"] as? Bool ?? false
                let phone_no : String = jsonDict["phone_no"] as? String ?? "null"
                let line_id : String = jsonDict["line_id"] as? String ?? "null"
                let activity_id : Int = jsonDict["activity_id"] as? Int ?? 0
                let remaining_push : Int = jsonDict["remaining_push"] as? Int ?? 0
                let announceDate : String = jsonDict["announceDate"] as? String ?? "null"
                let clickTime : Int = jsonDict["clickTime"] as? Int ?? 0
                let latitude : String = jsonDict["latitude"] as? String ?? "0"
                let longitude : String = jsonDict["longitude"] as? String ?? "0"
                let createDate : String = jsonDict["createDate"] as! String
                let updateDate : String = jsonDict["updateDate"] as! String
                
                // Create new Machine and set its properties
                let shop = FollowShopMachine(isFollow: true, isStore: isStore, id: id, userId: userId, title: title, description: description, address: address, store_name: "", big_machine_no: big_machine_no, machine_no: machine_no, manager: manager, air_condition: air_condition, fan: fan, wifi: wifi, phone_no: phone_no, line_id: line_id, activity_id: activity_id, remaining_push: remaining_push, announceDate: announceDate, clickTime: clickTime, latitude: latitude, longitude: longitude, createDate: createDate, updateDate: updateDate)
                //Add it to the array
                followArr.append(shop)
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }
        }
        catch {
            print("There was an error")
        }
    }
    
    @objc func share() {
        let activityVC = UIActivityViewController(activityItems: ["Let me recommend you this application https://www.surveyx.tw/"], applicationActivities: nil)
            // 顯示出我們的 activityVC。
            self.present(activityVC, animated: true, completion: nil)
    }
    @objc func follow(_ sender : UIButton) {
        
        postFollow(index: sender.tag)
        if followArr[sender.tag].isFollow == true {
            followArr[sender.tag].isFollow = false
            sender.setImage(UIImage(named: "unfollow"), for: .normal)
        } else {
            followArr[sender.tag].isFollow = true
            sender.setImage(UIImage(named: "followed"), for: .normal)
        }
    }
    func postFollow(index: Int) {
        let url = URL(string: "https://www.surveyx.tw/funchip/click_follow_machine.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        if followArr[index].isFollow == true {
            json = [
                "userId": "\(userData[0].userId)",
                "objectId": "\(followArr[index].id)"
            ]
        } else {
            json = [
                "isFollow": "\(followArr[index].isFollow)",
                "userId": "\(userData[0].userId)",
                "objectId": "\(followArr[index].id)"
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
