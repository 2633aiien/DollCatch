//
//  NewMachineFirstViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/30.
//

import UIKit
import CoreData

class NewMachineFirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewShopModelDelegate {
    func itemsDownloaded(shops: [newShop]) {
        self.newShops = shops
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
            
        }
    }
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var width = Int(UIScreen.main.bounds.width)-40
    var height = 120
    
    var newShopModel = NewShopModel()
    var newShops = [newShop]()
    var moreInt = 0
    
    var userData : [UserInformationClass] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if newShops.count == 0 {
            return newShops.count
        } else {
        return newShops.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == newShops.count && newShops.count != 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreCell", for: indexPath) as! MoreCollectionViewCell
            cell.moreBtn.addTarget(self, action: #selector(getMore), for: .touchUpInside)
            return cell
        } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewMachineCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(newShops[indexPath.row].userId)/store_photo_\(newShops[indexPath.row].id)_6")! , imageView: cell.myImageView)

        cell.myTitleLabel.text = newShops[indexPath.row].title

        cell.myLocationLabel.text = "\(newShops[indexPath.row].address_city)\(newShops[indexPath.row].address_area)"
        
        cell.myNameLabel.text = newShops[indexPath.row].manager
        cell.myTimeLabel.text = newShops[indexPath.row].updateDate
            cell.shareBtn.setImage(UIImage(named: "12"), for: .normal)
            
            cell.shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        
                cell.heartBtn.tag = indexPath.row
                cell.heartBtn.addTarget(self, action: #selector(follow(_ :)), for: .touchUpInside)
            if newShops[indexPath.row].isFollow == true {
                    cell.heartBtn.setImage(UIImage(named: "followed"), for: .normal)
            } else {
                cell.heartBtn.setImage(UIImage(named: "unfollow"), for: .normal)
            }
            
        
        cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(12)
        cell.myNameLabel.font = cell.myNameLabel.font.withSize(12)
        cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(12)
        
        
        return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == newShops.count {
            return
        } else {
        let newS = newShops[indexPath.row]
        let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as! MachineIntroViewController
        
        controller.tempIsStore = newS.isStore
        controller.tempTitle = newS.title
        controller.tempId = newS.id
        controller.tempUserId = newS.userId
        controller.tempAddress_city = newS.address_city
            controller.tempAddress_area = newS.address_area
            controller.tempAddress_name = newS.address_name
        controller.tempDescription = newS.description
        controller.tempManager = newS.manager
        controller.tempLine = newS.line_id
        controller.tempPhone = newS.phone_no
        controller.tempBig_machine_no = newS.big_machine_no
        controller.tempMachine_no = newS.machine_no
        controller.tempAir_condition = newS.air_condition
        controller.tempFan = newS.fan
        controller.tempWifi = newS.wifi
            controller.tempLatitude = Double(newS.latitude) ?? 0
            controller.tempLongitude = Double(newS.longitude) ?? 0
        
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
            forCellWithReuseIdentifier: "NewMachineCollectionViewCell")
        myCollectionView.register(MoreCollectionViewCell.self, forCellWithReuseIdentifier: "moreCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        var userId = ""
        if !userData .isEmpty {
            userId = userData[0].userId
        }
        
        newShopModel.getNewShopItems(userId: userId)
        newShopModel.delegate = self
    }
    
    @objc func share() {
        let activityVC = UIActivityViewController(activityItems: ["Let me recommend you this application https://www.surveyx.tw/"], applicationActivities: nil)
            // ?????????????????? activityVC???
            self.present(activityVC, animated: true, completion: nil)
    }
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @objc func getMore() {
        let url = URL(string: "https://www.surveyx.tw/funchip/new_store.php")!
        // json data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "more_store_no": "\(moreInt)",
        ]
        moreInt += 1
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    // succceeded
                    
                    // Call the parse json function on the data
                    self.parseMoreShopJson(data: data!)
                    
                } else {
                    print("error: \(error)")
                }
            }
            // start the task
            task.resume()
        
    }
    func parseMoreShopJson(data: Data) {
        
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
                let address_city : String = jsonDict["address_city"] as? String ?? "null"
                let address_area : String = jsonDict["address_area"] as? String ?? "null"
                let address_name : String = jsonDict["address_name"] as? String ?? "null"
                let big_machine_no : String = jsonDict["big_machine_no"] as? String ?? "null"
                let machine_no : String = jsonDict["machine_no"] as? String ?? "null"
                let manager : String = jsonDict["manager"] as? String ?? "null"
                let air_condition : Bool = jsonDict["air_condition"] as? Bool ?? false
                let fan : Bool = jsonDict["fan"] as? Bool ?? false
                let wifi : Bool = jsonDict["wifi"] as? Bool ?? false
                let phone_no : String = jsonDict["phone_no"] as? String ?? "null"
                let line_id : String = jsonDict["line_id"] as? String ?? "null"
                let activity_id : Int = jsonDict["activity_id"] as? Int ?? 0
                let remaining_push : String = jsonDict["remaining_push"] as? String ?? "null"
                let announceDate : String = jsonDict["announceDate"] as? String ?? "null"
                let clickTime : Int = jsonDict["clickTime"] as? Int ?? 0
                let latitude : String = jsonDict["latitude"] as? String ?? "0"
                let longitude : String = jsonDict["longitude"] as? String ?? "0"
                let createDate : String = jsonDict["createDate"] as! String
                let updateDate : String = jsonDict["updateDate"] as! String
                let isFollow : Bool = jsonDict["isFollow"] as! Bool
                // Create new Machine and set its properties
                let shop = newShop(isFollow: isFollow,isStore: isStore, id: id, userId: userId, title: title, description: description, address_city: address_city, address_area: address_area, address_name: address_name, big_machine_no: big_machine_no, machine_no: machine_no, manager: manager, air_condition: air_condition, fan: fan, wifi: wifi, phone_no: phone_no, line_id: line_id, activity_id: activity_id, remaining_push: remaining_push, announceDate: announceDate, clickTime: clickTime, latitude: latitude, longitude: longitude, createDate: createDate, updateDate: updateDate)
                //Add it to the array
                newShops.append(shop)
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
                self.userData = try moc.fetch(fetchRequest)//??????????????????[Note]
            }catch{
                print("error \(error)")
                self.userData = []//??????????????????????????????
            }
        }
    }
    
    @objc func follow(_ sender : UIButton) {
        
        postFollow(index: sender.tag)
        if newShops[sender.tag].isFollow == true {
            newShops[sender.tag].isFollow = false
            sender.setImage(UIImage(named: "unfollow"), for: .normal)
        } else {
            newShops[sender.tag].isFollow = true
            sender.setImage(UIImage(named: "followed"), for: .normal)
        }
    }
    func postFollow(index: Int) {
        let url = URL(string: "https://www.surveyx.tw/funchip/click_follow_store.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        if newShops[index].isFollow == true {
            json = [
                "userId": "\(userData[0].userId)",
                "objectId": "\(newShops[index].id)"
            ]
        } else {
            json = [
                "isFollow": "\(newShops[index].isFollow)",
                "userId": "\(userData[0].userId)",
                "objectId": "\(newShops[index].id)"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
