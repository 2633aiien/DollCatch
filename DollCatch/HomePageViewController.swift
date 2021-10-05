//
//  ViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import SideMenu
import CoreData


class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewMachineModelDelegate, NewShopModelDelegate {
    
    @IBOutlet weak var adScrollView: UIScrollView!
    @IBOutlet weak var firstImageVIew: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var hottestCollectionView: UICollectionView!
    
    @IBOutlet weak var newestCollectionView: UICollectionView!
    
    @IBOutlet weak var newestShopCollectionView: UICollectionView!
    
    var cellWidth = 270
    var cellHeight = 120
    
    var width = Int(UIScreen.main.bounds.width - 20)
    var height = Int(UIScreen.main.bounds.height - 10)
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentIndex : NSInteger = 0
    var imageArray : [UIImage] = []
    var timer = Timer()
    var screenW = UIScreen.main.bounds.width
    var index = 1
    var lastTimeOffsetX : CGFloat?
    var swipe = UISwipeGestureRecognizer()
    
    var bool = true
    
    var followArr : [FollowShopMachine] = []
    
    var newMachineModel = NewMachineModel()
    var newMachines = [newMachine]()
    var newShopModel = NewShopModel()
    var newShops = [newShop]()
    var userData : [UserInformationClass] = []
    
    var nameOfTableView = ""
    
    var adUrlArr : [String] = []
    
    func itemsDownloaded(machines: [newMachine]) {
        self.newMachines = machines
        
        DispatchQueue.main.async {
            self.newestCollectionView.reloadData()
        }
    }
    func itemsDownloaded(shops: [newShop]) {
        self.newShops = shops

        DispatchQueue.main.async {
            self.newestShopCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == self.hottestCollectionView {
            
            if followArr.count <= 10 {
                count = followArr.count

            } else {
                count = 10
            }
        } else if collectionView == self.newestCollectionView {
        if newMachines.count == 0{
            count = newMachines.count
        } else {
            count = 10
            
        }
        } else if collectionView == self.newestShopCollectionView {
            if newShops.count == 0{
                count = newShops.count
            } else {
                count = 10
            }
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var myCell = UICollectionViewCell()
        
        if collectionView == self.hottestCollectionView{
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "HotCell", for: indexPath)
                as! MyCollectionViewCell
            
            // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
            if followArr[indexPath.row].isStore == true {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(followArr[indexPath.row].userId)/store_photo_\(followArr[indexPath.row].id)_6")! , imageView: cell.myImageView)
            } else {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(followArr[indexPath.row].userId)/machine_photo_\(followArr[indexPath.row].id)_6")! , imageView: cell.myImageView)
            }
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
            
            cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(12)
            cell.myNameLabel.font = cell.myNameLabel.font.withSize(12)
            cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(12)
            cell.myTimeLabel.textAlignment = .right
            
            myCell = cell
            
        } else if collectionView == self.newestCollectionView{
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "NewCell", for: indexPath)
                as! MyCollectionViewCell
            
            // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
            
            downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(newMachines[indexPath.row].userId)/machine_photo_\(newMachines[indexPath.row].id)_6")! , imageView: cell.myImageView)

            cell.myTitleLabel.text = newMachines[indexPath.row].title
            let str = newMachines[indexPath.row].address_machine
            if (str.rangeOfCharacter(from: CharacterSet(charactersIn: "區")) != nil) {
                let index = str.firstIndex(of: "區")
                let str3 = str[...index!]
                cell.myLocationLabel.text = String(str3)
            } else {
                cell.myLocationLabel.text = newMachines[indexPath.row].address_machine
            }
            
            cell.myNameLabel.text = newMachines[indexPath.row].manager
            cell.myTimeLabel.text = newMachines[indexPath.row].updateDate
            
            cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(12)
            cell.myNameLabel.font = cell.myNameLabel.font.withSize(12)
            cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(12)
            cell.myTimeLabel.textAlignment = .right
            myCell = cell
        }
        else if collectionView == self.newestShopCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewShopCell", for: indexPath) as! MySecondCollectionViewCell
            
            downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(newShops[indexPath.row].userId)/store_photo_\(newShops[indexPath.row].id)_6")! , imageView: cell.myImageView)
            cell.myTitleLabel.text = newShops[indexPath.row].title
            let str = newShops[indexPath.row].address_shop
            if (str.rangeOfCharacter(from: CharacterSet(charactersIn: "區")) != nil) {
                let index = str.firstIndex(of: "區")
                let str3 = str[...index!]
                cell.myLocationLabel.text = String(str3)
            } else {
                cell.myLocationLabel.text = newShops[indexPath.row].address_shop
            }
            cell.myNameLabel.text = newShops[indexPath.row].manager
            cell.myTimeLabel.text = newShops[indexPath.row].updateDate
            cell.myTitleLabel.numberOfLines = 1
            cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(14)
            cell.myNameLabel.font = cell.myNameLabel.font.withSize(14)
            cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(14)
            myCell = cell
            
        }
        return myCell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.hottestCollectionView {
            let newF = followArr[indexPath.row]
            if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as? MachineIntroViewController{
                controller.tempIsFollow = newF.isFollow
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
                
                
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
            }
        } else if collectionView == self.newestCollectionView {
            let newM = newMachines[indexPath.row]

            if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as? MachineIntroViewController{
                controller.tempIsFollow = newM.isFollow
                controller.tempIsStore = newM.isStore
                controller.tempTitle = newM.title
                controller.tempId = newM.id
                controller.tempUserId = newM.userId
                controller.tempAddress = newM.address_machine
                controller.tempDescription = newM.description
                controller.tempStoreName = newM.store_name
                controller.tempManager = newM.manager
                controller.tempLine = newM.line_id
                controller.tempPhone = newM.phone_no
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
            }

            
        } else if collectionView == self.newestShopCollectionView {
            let newS = newShops[indexPath.row]
            if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as? MachineIntroViewController{
                controller.tempIsFollow = newS.isFollow
                controller.tempIsStore = newS.isStore
                controller.tempTitle = newS.title
                controller.tempId = newS.id
                controller.tempUserId = newS.userId
                controller.tempAddress = newS.address_shop
                controller.tempDescription = newS.description
                controller.tempManager = newS.manager
                controller.tempLine = newS.line_id
                controller.tempPhone = newS.phone_no
                controller.tempBig_machine_no = newS.big_machine_no
                controller.tempMachine_no = newS.machine_no
                controller.tempAir_condition = newS.air_condition
                controller.tempFan = newS.fan
                controller.tempWifi = newS.wifi
                
                
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        for i in 1...8 {
                self.downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/ad/ad_0\(i)")!,i: i)
        }
        followArr = []
        newMachines = []
        newShops = []
        if !userData .isEmpty {
        getFollowShopItems()
        getFollowMachineItems()
        }
        
        var userId = ""
        if !userData .isEmpty {
            userId = userData[0].userId
        }
        newMachineModel.getNewMachineItems(userId: userId)
        newMachineModel.delegate = self
        
        newShopModel.getNewShopItems(userId: userId)
        newShopModel.delegate = self
        
        hottestCollectionView.reloadData()
        newestCollectionView.reloadData()
        newestShopCollectionView.reloadData()
        
        self.view.layoutIfNeeded()
        adScrollView.contentSize = CGSize(width: screenW * CGFloat(imageArray.count + 2), height: 230)
        adScrollView.contentOffset = CGPoint(x: screenW * CGFloat(index), y: 0)
        swipe.direction = .left
    }
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
    
//        let backItem = UIBarButtonItem()
//            backItem.title = ""
//            navigationItem.backBarButtonItem = backItem
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "rootView")
        let menu = SideMenuNavigationController(rootViewController: viewController!)
        queryFromCoreData()
        
        getAd()
        
        // sidebar
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        SideMenuManager.default.leftMenuNavigationController = menu
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // collectionViewFlowLayout
        
        let layoutHor = UICollectionViewFlowLayout()
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layoutHor.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        layoutHor.minimumInteritemSpacing = 8
        layoutHor.scrollDirection = .horizontal
        
        // 設置每一行的間距
        layoutHor.minimumLineSpacing = 8
        // 設置每個 cell 的尺寸
        layoutHor.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let layoutVer = UICollectionViewFlowLayout()
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layoutVer.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        layoutVer.minimumInteritemSpacing = 8
        layoutVer.scrollDirection = .vertical
        
        // 設置每個 cell 的尺寸
        layoutVer.itemSize = CGSize(width: width, height: cellHeight)
        
        
        hottestCollectionView.collectionViewLayout = layoutHor
        
        newestCollectionView.collectionViewLayout = layoutHor
        
        newestShopCollectionView.collectionViewLayout = layoutVer
        
        // 註冊 cell 以供後續重複使用
        hottestCollectionView.register(
            MyCollectionViewCell.self,
            forCellWithReuseIdentifier: "HotCell")
        
        newestCollectionView.register(
            MyCollectionViewCell.self,
            forCellWithReuseIdentifier: "NewCell")
        
        newestShopCollectionView.register(
            MySecondCollectionViewCell.self,
            forCellWithReuseIdentifier: "NewShopCell")
        
        
        
        // 設置委任對象
        hottestCollectionView.delegate = self
        hottestCollectionView.dataSource = self
        hottestCollectionView.alwaysBounceHorizontal = true
        
        newestCollectionView.delegate = self
        newestCollectionView.dataSource = self
        newestCollectionView.alwaysBounceHorizontal = true
        
        newestShopCollectionView.delegate = self
        newestShopCollectionView.dataSource = self
        
        adScrollView.delegate = self
        startTimer()
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
    func downloadImage(from url: URL,i: Int) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
    var image = UIImage(data: data)!
                print("imageArray/image: \(self.imageArray)")
                var imageView = UIImageView(frame: CGRect(x: self.screenW * CGFloat(i), y: 0, width: self.screenW, height: 230))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.isUserInteractionEnabled = true
                self.adScrollView.addSubview(imageView)
                self.imageArray.append(image)
            }
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
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //MARK: 追蹤
    
    func getFollowShopItems() {
        // web service Url
        let url = URL(string: "https://www.surveyx.tw/funchip/follow_store.php")!
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
                    self.hottestCollectionView.reloadData()
                }
            }
        }
        catch {
            print("There was an error")
        }
    }
    
    func getFollowMachineItems() {
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
                    self.parseFollowMachineJson(data: data!)
                    
                } else {
                    print("error: \(error)")
                }
            }
            // start the task
            task.resume()
    }
    func parseFollowMachineJson(data: Data) {
        
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
                let address : String = jsonDict["address_machine"] as? String ?? "null"
                let store_name : String = jsonDict["store_name"] as? String ?? "null"
                let manager : String = jsonDict["manager"] as? String ?? "null"
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
                let machine = FollowShopMachine(isFollow: true, isStore: isStore, id: id, userId: userId, title: title, description: description, address: address, store_name: store_name, big_machine_no: "", machine_no: "", manager: manager, air_condition: false, fan: false, wifi: false, phone_no: phone_no, line_id: line_id, activity_id: activity_id, remaining_push: remaining_push, announceDate: announceDate, clickTime: clickTime, latitude: latitude, longitude: longitude, createDate: createDate, updateDate: updateDate)
                //Add it to the array
                followArr.append(machine)
            }
            DispatchQueue.main.async {
                self.hottestCollectionView.reloadData()
            }
        }
        catch {
            print("There was an error")
        }
    }
    
    func getAd() {
        let serviceUrl = "https://www.surveyx.tw/funchip/get_ad.php"
        // json data
        let url = URL(string: serviceUrl)
        
        if let url = url {
            // create a Url session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    // succceeded
                    
                    // Call the parse json function on the data
                    self.parseAdJson(data: data!)
                    
                } else {
                    //Error occurred
                }
            }
            // start the task
            task.resume()
        }
    }
    func parseAdJson(data: Data) {
        
        // Parse the data into struct
        do {
            // Parse the data into a jsonObject
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            for jsonResult in jsonArray {
                // json result as a dictionary
                let jsonDict = jsonResult as! [String:Any]
                let position : String = jsonDict["position"] as! String
                let adUrl : String = jsonDict["adUrl"] as! String
                
                
                // Create new Machine and set its properties
                let ad = AdStruct(position: position, adUrl: adUrl)
                //Add it to the array
                adUrlArr.append(ad.adUrl)
            }
        }
        catch {
            print("There was an error")
        }
    }
    
    @IBAction func moreFollow(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "followMore") as? MoreFollowViewController{
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func moreNewShop(_ sender: Any) {
        bool = true
//        if let controller = storyboard?.instantiateViewController(withIdentifier: "newMachine") {
//            let navigationController = UINavigationController(rootViewController: controller)
//            navigationController.modalPresentationStyle = .fullScreen
//            present(navigationController, animated: true, completion: nil)
//        }
    }
    
    @IBAction func moreNewMachine(_ sender: Any) {
        bool = false
//        if let controller = storyboard?.instantiateViewController(withIdentifier: "newMachine") {
//            let navigationController = UINavigationController(rootViewController: controller)
//            navigationController.modalPresentationStyle = .fullScreen
//            present(navigationController, animated: true, completion: nil)
//        }
        
    }
    
    
    
    @IBAction func hamburgerBtn(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "rootView")
        let menu = SideMenuNavigationController(rootViewController: viewController!)
        menu.leftSide = true
        menu.settings.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        present(menu, animated: true, completion: nil)
        //        dismiss(animated: true, completion: nil)
    }
    @IBAction func searchBtn(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "searchView") {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Let me recommend you this application https://www.surveyx.tw/"], applicationActivities: nil)
            // 顯示出我們的 activityVC。
            self.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func notifyBtn(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "notify") {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? NewMachineViewController
        controller?.isShop = bool
        
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

//page...
extension HomePageViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == adScrollView {
            let offsetX = adScrollView.contentOffset.x
            
            if offsetX == 0 {
                let contentOffsetMinX = screenW * CGFloat(imageArray.count)
                  adScrollView.contentOffset = CGPoint(x: contentOffsetMinX, y: 0)
                   //此時需記錄更改後的最後位置，待會使用
                   lastTimeOffsetX = contentOffsetMinX
            }
            if offsetX == screenW * CGFloat(imageArray.count + 1) {
               adScrollView.contentOffset = CGPoint(x: screenW, y: 0)
               //此時需記錄更改後的最後位置，待會使用
               lastTimeOffsetX = screenW
            }
            
            let page = round(scrollView.contentOffset.x / screenW) - 1
            pageControl.currentPage = Int(page)
        }
    }
    
    // Timer
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    @objc func autoScroll() {
        switch swipe.direction {
        case .left:
        if index == imageArray.count + 1 {
        index = 2
        } else {
        index += 1
        }
        case .right:
          //當跑到位置0時，也就是要從間距２開始跑
          if index == 0 {
          index = imageArray.count - 1
          } else {
            index -= 1
          }
        default:
            break
        
        }
        adScrollView.setContentOffset(CGPoint(x: screenW * CGFloat(index), y: 0), animated: true)
        lastTimeOffsetX = screenW * CGFloat(index)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      //print(“\(scrollView.contentOffset.x)”)
        timer.invalidate()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      //print(“\(scrollView.contentOffset.x)”)
      guard let lastTimeOffsetX = lastTimeOffsetX else { return }
      let currentOffsetX = scrollView.contentOffset.x
      //若有改變方向，變動方向註記
//      if currentOffsetX < lastTimeOffsetX {
//        swipe.direction = .left //往左跑
//      } else {
//        swipe.direction = .right //往右跑
//      }
        swipe.direction = .left
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      //print(“\(scrollView.contentOffset.x)”)
      let contentOffsetMinX = scrollView.contentOffset.x
      index = Int(contentOffsetMinX / screenW)
      //重新計算頁數
      lastTimeOffsetX = scrollView.contentOffset.x
      //若最後真的有換頁，再重新assign進去
       startTimer()
    }
        
}

