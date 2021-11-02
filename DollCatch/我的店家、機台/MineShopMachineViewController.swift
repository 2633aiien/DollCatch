//
//  MineShopViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import CoreData

class MineShopMachineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var isStore = false
    var userData : [UserInformationClass] = []
    
    var width = Int(UIScreen.main.bounds.width)-40
    var height = 180
    var mineArr : [FollowShopMachine] = []
    var objectIdArr : [String] = []

    @IBOutlet weak var myCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        queryFromCoreData()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        //CollectionViewLayout
        let firstLayout = UICollectionViewFlowLayout()
        firstLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        firstLayout.minimumInteritemSpacing = 8
        firstLayout.scrollDirection = .vertical
        firstLayout.itemSize = CGSize(width: width, height: height)
        
        myCollectionView.collectionViewLayout = firstLayout
        
        myCollectionView.register(
            FirstCollectionViewCell.self,
            forCellWithReuseIdentifier: "FirstCollectionViewCell")
        
        let secondLayout = UICollectionViewFlowLayout()
        secondLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        secondLayout.minimumInteritemSpacing = 8
        secondLayout.scrollDirection = .vertical
        secondLayout.itemSize = CGSize(width: width - 20, height: height)
        
        myCollectionView.collectionViewLayout = secondLayout
        
        myCollectionView.register(
            SecondCollectionViewCell.self,
            forCellWithReuseIdentifier: "SecondCollectionViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        getMineItems()
        self.myCollectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        if userData .isEmpty {
            let controller = storyboard?.instantiateViewController(withIdentifier: "login")
            let navigationController = UINavigationController(rootViewController: controller!)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mineArr.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCollectionViewCell", for: indexPath) as! FirstCollectionViewCell
        return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondCollectionViewCell", for: indexPath) as! SecondCollectionViewCell
            cell.myImageView.image = UIImage(named: "withoutImage")
            cell.myTitleLabel.text = mineArr[indexPath.row-1].title
            cell.myLocationLabel.text = "\(mineArr[indexPath.row-1].address_city)\(mineArr[indexPath.row-1].address_area)"
            cell.myNameLabel.text = mineArr[indexPath.row-1].manager
            cell.myTimeLabel.text = mineArr[indexPath.row-1].updateDate
            cell.myPushTimeLabel.text = "推播剩餘次數：\(mineArr[indexPath.row-1].remaining_push)"
            cell.editBtn.tag = indexPath.row-1
            cell.editBtn.addTarget(self, action: #selector(editBtnPressed), for: .touchUpInside)
            cell.pushBtn.tag = Int(mineArr[indexPath.row-1].id) ?? -1
            cell.pushBtn.addTarget(self, action: #selector(pushBtnPressed(_ :)), for: .touchUpInside)
            cell.backgroundColor = .white
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            insertMineItems()
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
    func getMineItems() {
        // web service Url
        if userData .isEmpty {
            userData.first?.userId = ""
        }
        var url = URL(string: "https://www.surveyx.tw/funchip/get_my_store.php")!
        if isStore == false {
        url = URL(string: "https://www.surveyx.tw/funchip/get_my_machine.php")!
        }
        // json data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "userId" : "\((userData.first?.userId ?? ""))"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                // succceeded
                
                // Call the parse json function on the data
                self.parseMineShopJson(data: data!)
                
            } else {
                print("error: \(error)")
            }
        }
        // start the task
        task.resume()
        
    }
    func parseMineShopJson(data: Data) {
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
                let latitude : String = jsonDict["latitude"] as? String ?? ""
                let longitude : String = jsonDict["longitude"] as? String ?? ""
                let createDate : String = jsonDict["createDate"] as! String
                let updateDate : String = jsonDict["updateDate"] as! String
                
                // Create new Machine and set its properties
                let shop = FollowShopMachine(isStore: isStore, id: id, userId: userId, title: title, description: description, address_city: address_city, address_area: address_area, address_name: address_name, store_name: "", big_machine_no: big_machine_no, machine_no: machine_no, manager: manager, air_condition: air_condition, fan: fan, wifi: wifi, phone_no: phone_no, line_id: line_id, activity_id: activity_id, remaining_push: remaining_push, announceDate: announceDate, clickTime: clickTime, latitude: latitude, longitude: longitude, createDate: createDate, updateDate: updateDate)
                //Add it to the array
                mineArr.append(shop)
                
            }
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
                    print("myCollectionView")
            }
        }
        catch {
            print("There was an error")
        }
    }
    
    func insertMineItems() {
        // web service Url
        if userData .isEmpty {
            userData.first?.userId = ""
        }
        var url = URL(string: "https://www.surveyx.tw/funchip/insert_new_store.php")!
        if isStore == false {
        url = URL(string: "https://www.surveyx.tw/funchip/insert_new_machine.php")!
        }
        // json data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "userId" : "\((userData.first?.userId ?? ""))"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                // succceeded
                
                // Call the parse json function on the data
                self.parseInsertMineJson(data: data!)
                
            } else {
                print("error: \(error)")
            }
        }
        // start the task
        task.resume()
        
    }
    func parseInsertMineJson(data: Data) {
        // Parse the data into struct
        do {
            // Parse the data into a jsonObject
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: [])
            var result : Bool!
            var id : String!
            var resultMesg : String!
                // json result as a dictionary
                let jsonDict = jsonArray as! [String:Any]
                result = jsonDict["result"] as? Bool
                id = jsonDict["id"] as? String
                resultMesg = jsonDict["resultMesg"] as? String
            if result == true {
                if let controller = storyboard?.instantiateViewController(withIdentifier: "editMineShop") as? EditMineShopViewController {
                    controller.objectId = id
                    controller.isStore = isStore
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.async {
                        self.present(navigationController, animated: false, completion: nil)
                    }
                }
            } else if resultMesg == "無法新增編輯頁，請先繳費"{
                let controller = UIAlertController(title: resultMesg, message: "", preferredStyle: .alert)
                let payAction = UIAlertAction(title: "前往繳費", style: .default) { _ in
                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "choosePlan") as? ChoosePlanViewController {
                        let navigationController = UINavigationController(rootViewController: controller)
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true, completion: nil)
                    }
                }
                let okAction = UIAlertAction(title: "取消", style: .default, handler: nil)
                controller.addAction(payAction)
                controller.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        catch {
            print("There was an error")
        }
    }
    func iOSNotify(id: Int) {
        let url = URL(string: "https://www.surveyx.tw/funchip/noti.php")!
        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let json: [String: Any] = [
//            "isStore" : "\(isStore)",
//            "objectId" : "\(id)"
//        ]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        
//        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
            }
        }
        task.resume()
    }
    func pushMineItems(id: Int) {
        // web service Url
        if userData .isEmpty {
            userData.first?.userId = ""
        }
        var url = URL(string: "https://www.surveyx.tw/funchip/push_store.php")!
        if isStore == false {
        url = URL(string: "https://www.surveyx.tw/funchip/push_machine.php")!
        }
        // json data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "id" : "\(id)"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                // succceeded
                
                // Call the parse json function on the data
                self.parsePushMineJson(data: data!, id: id)
                
            } else {
                print("error: \(error)")
            }
        }
        // start the task
        task.resume()
        
    }
   
    func parsePushMineJson(data: Data, id: Int) {
        // Parse the data into struct
        do {
            // Parse the data into a jsonObject
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: [])
            var result : Bool!
            var resultMesg : String!
                // json result as a dictionary
                let jsonDict = jsonArray as! [String:Any]
                result = jsonDict["result"] as? Bool
                resultMesg = jsonDict["resultMesg"] as? String
            if result == true {
                let controller = UIAlertController(title: "推播成功", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
                controller.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(controller, animated: true, completion: nil)
                    self.mineArr.removeAll()
                    self.getMineItems()
                    self.myCollectionView.reloadData()
                }
            } else if resultMesg == "推播次數不足"{
                let controller = UIAlertController(title: resultMesg, message: "", preferredStyle: .alert)
                let storedValueAction = UIAlertAction(title: "前往儲值", style: .default) { _ in
                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "planViewController") as? MachinePlanViewController {
                        if self.isStore == true {
                            controller.machineOrShop = "店家"
                        } else {
                            controller.machineOrShop = "機台"
                        }
                        controller.tempId = id
                        let navigationController = UINavigationController(rootViewController: controller)
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true, completion: nil)
                    }
                }
                let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
                controller.addAction(storedValueAction)
                controller.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        catch {
            print("There was an error")
        }
    }
    @objc func editBtnPressed(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "editMineShop") as? EditMineShopViewController {
            controller.information = mineArr[sender.tag]
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
        }
    }
    @objc func pushBtnPressed(_ sender : UIButton) {
        iOSNotify(id: sender.tag)
        pushMineItems(id: sender.tag)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
