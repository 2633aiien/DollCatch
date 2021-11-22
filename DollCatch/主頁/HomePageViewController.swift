//
//  ViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import SideMenu
import CoreData
import MapKit


class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewMachineModelDelegate, NewShopModelDelegate, CLLocationManagerDelegate, NewFollowModelDelegate {
    
    
    @IBOutlet weak var adCollectionView: UICollectionView!
    
    @IBOutlet weak var hottestCollectionView: UICollectionView!
    
    @IBOutlet weak var newestCollectionView: UICollectionView!
    
    @IBOutlet weak var newestShopCollectionView: UICollectionView!
    @IBOutlet weak var mineManageBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var myStackView: UIStackView!
    
    var notiNum = 0
    
    var cellWidth = 270
    var cellHeight = 120
    
    var width = Int(UIScreen.main.bounds.width - 20)
    var height = Int(UIScreen.main.bounds.height - 10)
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentIndex : NSInteger = 0
    var timer = Timer()
    var screenW = UIScreen.main.bounds.width
    var index = 1
    var lastTimeOffsetX : CGFloat?
    var swipe = UISwipeGestureRecognizer()
    
    var bool = true
    
    var followModel = NewFollowModel()
    var followArr : [FollowShopMachine] = []
    @IBOutlet weak var followMoreNum: UILabel!
    
    var newMachineModel = NewMachineModel()
    var newMachines = [newMachine]()
    var newShopModel = NewShopModel()
    var newShops = [newShop]()
    var userData : [UserInformationClass] = []
    
    var nameOfTableView = ""
    
    var adUrlArr : [String] = []
    var imageIndex = 0
//    var imageViewArray : [UIImageView] = []
    var positionArr : [String] = []
    
    var myLocationManager :CLLocationManager!
    var my_latitude : Double! = 0
    var my_longitude : Double! = 0
    func itemsDownloaded(shops: [FollowShopMachine]) {
        self.followArr = shops
        print("follow: \(followArr.count)")
        DispatchQueue.main.async {
            self.hottestCollectionView.reloadData()
        }
    }
    
    func itemsDownloaded(machines: [newMachine]) {
        self.newMachines = machines
        
        DispatchQueue.main.async {
            self.newestCollectionView.reloadData()
            self.hottestCollectionView.reloadData()
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
        if collectionView == self.adCollectionView {
            count = positionArr.count
        }else if collectionView == self.hottestCollectionView {
            
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
        if collectionView == self.adCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AdCollectionViewCell
            downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/ad/ad_0\(indexPath.row+1)")!, imageView: cell.myImageView)
            myCell = cell
        }else if collectionView == self.hottestCollectionView{
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
                    cell.myLocationLabel.text = "\(followArr[indexPath.row].address_city)\(followArr[indexPath.row].address_area)"
                cell.myNameLabel.text = followArr[indexPath.row].manager
                let time = followArr[indexPath.row].updateDate
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
            cell.myLocationLabel.text =  "\(newMachines[indexPath.row].address_city)\(newMachines[indexPath.row].address_area)"
            
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

            cell.myLocationLabel.text = "\(newShops[indexPath.row].address_city)\(newShops[indexPath.row].address_area)"
            
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
        if collectionView == self.adCollectionView {
            let urlString = adUrlArr[indexPath.row]
            let url = URL(string: urlString)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }else if collectionView == self.hottestCollectionView {
            let newF = followArr[indexPath.row]
            if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as? MachineIntroViewController{
                controller.tempIsFollow = newF.isFollow
                controller.tempIsStore = newF.isStore
                controller.tempTitle = newF.title
                controller.tempId = newF.id
                controller.tempUserId = newF.userId
                controller.tempAddress_city = newF.address_city
                controller.tempAddress_area = newF.address_area
                controller.tempAddress_name = newF.address_name
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
                controller.tempLatitude = Double(newF.latitude) ?? 0
                controller.tempLongitude = Double(newF.longitude) ?? 0
                
                
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
                controller.tempAddress_city = newM.address_city
                controller.tempAddress_area = newM.address_area
                controller.tempAddress_name = newM.address_name
                controller.tempDescription = newM.description
                controller.tempStoreName = newM.store_name
                controller.tempManager = newM.manager
                controller.tempLine = newM.line_id
                controller.tempPhone = newM.phone_no
                controller.tempLatitude = Double(newM.latitude) ?? 0
                controller.tempLongitude = Double(newM.longitude) ?? 0
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
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        let notifyButton =  UIButton(type: .custom)
        notifyButton.setImage(UIImage(named: "26-1"), for: .normal)
        notifyButton.addTarget(self, action: #selector(notifyAction), for: .touchUpInside)
        notifyButton.frame = CGRect(x: 0, y: 0, width: 30, height: 37)
//        notifyButton.imageEdgeInsets = UIEdgeInsets(top: -1, left: 32, bottom: 1, right: -32)//move image to the right
                  let notifyLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 15, height: 15))
        notifyLabel.font = UIFont.systemFont(ofSize: 10)
        notifyLabel.cornerRadius = 7.5
        notifyLabel.text = "99"
        notifyLabel.textAlignment = .center
        notifyLabel.textColor = .white
        notifyLabel.backgroundColor =  .red
        notifyButton.addSubview(notifyLabel)
        if userData.isEmpty {
            notifyLabel.isHidden = true
        } else {
            notifyLabel.isHidden = false
        }
        
        let barButton2 = UIBarButtonItem(customView: notifyButton)
        let shareButton =  UIButton(type: .custom)
        shareButton.setImage(UIImage(named: "27-1"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        shareButton.frame = CGRect(x: 0, y: 0, width: 30, height: 37)
//        shareButton.imageEdgeInsets = UIEdgeInsets(top: -1, left: 32, bottom: 1, right: -32)//move
        
        let barButton1 = UIBarButtonItem(customView: shareButton)
        
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 30.0
        self.navigationItem.setRightBarButtonItems([barButton1,fixedSpace,barButton2], animated: true)
        
        
        followArr = []
        newMachines = []
        newShops = []
        var userId = ""
        if !userData .isEmpty {
            getNotiNum(label: notifyLabel)
            userId = userData[0].userId
            followModel.getNewFollowItems(userId: userId)
            followModel.delegate = self
        }
        positionArr.removeAll()
        adUrlArr.removeAll()
        getAd()
        
        newMachineModel.getNewMachineItems(userId: userId)
        newMachineModel.delegate = self
        
        newShopModel.getNewShopItems(userId: userId)
        newShopModel.delegate = self
        
//        hottestCollectionView.reloadData()
        newestCollectionView.reloadData()
        newestShopCollectionView.reloadData()
        
//        self.view.layoutIfNeeded()
        
    }
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        locateUser()
        mineManageBtn.setTitle("", for: .normal)
        myStackView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "rootView")
        let menu = SideMenuNavigationController(rootViewController: viewController!)
        queryFromCoreData()
                
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
        
        let layoutAd = UICollectionViewFlowLayout()
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layoutAd.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layoutAd.minimumInteritemSpacing = 0
        layoutAd.scrollDirection = .horizontal
        
        // 設置每個 cell 的尺寸
        layoutAd.itemSize = CGSize(width: screenW, height: 230)
        adCollectionView.collectionViewLayout = layoutAd
        
        hottestCollectionView.collectionViewLayout = layoutHor
        
        newestCollectionView.collectionViewLayout = layoutHor
        
        newestShopCollectionView.collectionViewLayout = layoutVer
        
        
        // 註冊 cell 以供後續重複使用
        adCollectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
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
        adCollectionView.delegate = self
        adCollectionView.dataSource = self
        
        hottestCollectionView.delegate = self
        hottestCollectionView.dataSource = self
        hottestCollectionView.alwaysBounceHorizontal = true
        
        newestCollectionView.delegate = self
        newestCollectionView.dataSource = self
        newestCollectionView.alwaysBounceHorizontal = true
        
        newestShopCollectionView.delegate = self
        newestShopCollectionView.dataSource = self
        
        
    }
    func locateUser() {
        
        // 首次使用 向使用者詢問定位自身位置權限
        switch myLocationManager.authorizationStatus {
        case .notDetermined :
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()
            print("取得")
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        case .denied :
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                    "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(
                alertController,
                animated: true, completion: nil)
        case .authorizedWhenInUse :
            print("WhenInUse")
            myLocationManager.startUpdatingLocation()
        default:
            break
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
        timer.invalidate()
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let currentLocation :CLLocation =
        locations[0] as CLLocation
        
        my_latitude = currentLocation.coordinate.latitude
        my_longitude = currentLocation.coordinate.longitude
        
        print("LL:\(my_latitude!),\(my_longitude!)")
    
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
//    func downloadImage(from url: URL,i: Int) {
//        var image : UIImage!
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            // always update the UI from the main thread
//            DispatchQueue.main.async() {
//    image = UIImage(data: data)
//                let imageView = UIImageView()
//                imageView.image = image
//                imageView.contentMode = .scaleAspectFit
//                imageView.clipsToBounds = true
//                imageView.isUserInteractionEnabled = true
//                self.imageViewArray.append(imageView)
//
//            }
//    }
//    }
    
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
    //MARK: test
    func pushTest() {
        var url = URL(string: "https://www.surveyx.tw/funchip/push_store.php")!
        var request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                print("success")
            } else {
                print("error: \(error)")
            }
        }
        // start the task
        task.resume()
    }
    
    //MARK: 追蹤
    

    func getNotiNum(label: UILabel) {
            let url = URL(string: "https://www.surveyx.tw/funchip/get_notify.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let json: [String: Any] = [
                "userId": "\(userData[0].userId)"
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
                    let num = responseJSON["notifyNo"]! as! Int
                    self.notiNum = num
                }
                print("num: \(self.notiNum)")
                DispatchQueue.main.async {
                    if self.notiNum == 0 {
                        label.isHidden = true
                    } else {
                        label.text = "\(self.notiNum)"
                    }
                }
                
            }
            task.resume()
    }
    
    func getAd() {
        let serviceUrl = "https://www.surveyx.tw/funchip/get_ad.php"
        // json data
        let url = URL(string: serviceUrl)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
            // create a Url session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { data, response, error in
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
                positionArr.append(position)
            }
            DispatchQueue.main.async {
                print("urlArray: \(self.adUrlArr)")
                self.adCollectionView.reloadData()
                self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
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
        if let controller = storyboard?.instantiateViewController(withIdentifier: "searchView") as? SearchViewController{
            controller.my_latitude = my_latitude
            controller.my_longitude = my_longitude
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func notifyAction() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "notify") {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    @objc func shareAction() {
        let activityVC = UIActivityViewController(activityItems: ["Let me recommend you this application https://www.surveyx.tw/"], applicationActivities: nil)
        //            // 顯示出我們的 activityVC。
                    self.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func mineManageBtnPressed(_ sender: Any) {
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
extension HomePageViewController {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == adScrollView {
//            let offsetX = adScrollView.contentOffset.x
//
//            if offsetX == 0 {
//                let contentOffsetMinX = screenW * CGFloat(imageArray.count)
//                  adScrollView.contentOffset = CGPoint(x: contentOffsetMinX, y: 0)
//                   //此時需記錄更改後的最後位置，待會使用
//                   lastTimeOffsetX = contentOffsetMinX
//            }
//            if offsetX == screenW * CGFloat(imageArray.count + 1) {
//               adScrollView.contentOffset = CGPoint(x: screenW, y: 0)
//               //此時需記錄更改後的最後位置，待會使用
//               lastTimeOffsetX = screenW
//            }
//
//            let page = round(scrollView.contentOffset.x / screenW) - 1
//            pageControl.currentPage = Int(page)
//        }
//    }
//
//    // Timer
//    func startTimer() {
//        if timer != nil {
//            timer.invalidate()
//        }
//    }
    @objc func autoScroll() {
        var indexPath: IndexPath
        imageIndex += 1
        if imageIndex < positionArr.count {
            indexPath = IndexPath(item: imageIndex, section: 0)
            adCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            imageIndex = -1
            indexPath = IndexPath(item: imageIndex, section: 0)
            adCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            autoScroll()
        }
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//      //print(“\(scrollView.contentOffset.x)”)
//        timer.invalidate()
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//      //print(“\(scrollView.contentOffset.x)”)
//      guard let lastTimeOffsetX = lastTimeOffsetX else { return }
//      let currentOffsetX = scrollView.contentOffset.x
//      //若有改變方向，變動方向註記
////      if currentOffsetX < lastTimeOffsetX {
////        swipe.direction = .left //往左跑
////      } else {
////        swipe.direction = .right //往右跑
////      }
//        swipe.direction = .left
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//      //print(“\(scrollView.contentOffset.x)”)
//      let contentOffsetMinX = scrollView.contentOffset.x
//      index = Int(contentOffsetMinX / screenW)
//      //重新計算頁數
//      lastTimeOffsetX = scrollView.contentOffset.x
//      //若最後真的有換頁，再重新assign進去
//       startTimer()
//    }
        
}

