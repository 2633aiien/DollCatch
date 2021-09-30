//
//  SearchViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var fourthBtn: UIButton!
    
    
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    var width = Int(UIScreen.main.bounds.width)-40
    var height = 120
    
    var bottomLayer = CALayer()
    
    var numOfTableView : [String] = []
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var allAreaList: [AreaClass] = []
    var countryArr: [String] = []
    var areaArr: [String] = []
    var areaArray: [[String]] = []
    
    var firstSelectedIndex = 0
    var firstDict : [Bool] = [true, true]
    var secondSelectedArray : [String] = []
    var secondAllBool = false
    var secondSelectedIndex = 0
    var tempCountry = ""
    var countryIndexArr : [Int] = []
    var areaIndexArr : [Int] = []
    var thirdSelectedIndex = 0
    var thirdSelectedArray = [true,false,false,false,false,false,false,false]
//    var thirdDict : [Bool] = []
    var numOfCategory = 0
    var fourthSelectedIndex = 0
    var fourthDict : Int = 0
    
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var areaTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    var json: [String: Any] = [:]
    
    var userData : [UserInformationClass] = []
    var searchArr : [FollowShopMachine] = []
    
    var myLocationManager :CLLocationManager!
    var myMapView :MKMapView!
    var my_latitude : Double!
    var my_longitude : Double!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropDownTableView {
            return numOfTableView.count + 1
        } else if tableView == countryTableView {
            return countryArr.count
        } else {
            return areaArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dropDownTableView {
            if indexPath.row == numOfTableView.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SureTableViewCell
                cell.sureBtn.addTarget(self, action: #selector(sure), for: .touchUpInside)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell1",for: indexPath)
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                cell.textLabel?.textColor = .systemGray
                cell.textLabel?.text = numOfTableView[indexPath.row]
                cell.textLabel?.highlightedTextColor = .black
                cell.textLabel?.font = cell.textLabel?.font.withSize(17)
                if tableView.tag == 1 && indexPath.row == firstSelectedIndex{
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                    cell.textLabel?.textColor = .black
                } else if tableView.tag == 3 {
                    for i in 0...thirdSelectedArray.count-1 {
                        if indexPath.row == i && thirdSelectedArray[i] == true{
                            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                            cell.textLabel?.textColor = .black
                        }
                    }
                }else if tableView.tag == 4 && indexPath.row == fourthSelectedIndex {
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                    cell.textLabel?.textColor = .black
                }
                return cell
            }
        } else if tableView == countryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.textLabel?.textColor = .systemGray
            if countryArr.isEmpty {
                cell.textLabel?.text = ""
            } else {
                cell.textLabel?.text = countryArr[indexPath.row]
                for i in countryIndexArr {
                    if indexPath.row == i {
                        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                        cell.textLabel?.textColor = .black
                    }
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.textLabel?.textColor = .systemGray
            if areaArr.isEmpty {
                cell.textLabel?.text = ""
            }else {
                cell.textLabel?.text = areaArr[indexPath.row]
                if !areaIndexArr .isEmpty {
                for i in areaIndexArr {
                    if indexPath.row == i {
                        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                        cell.textLabel?.textColor = .black
                    }
                    }
                }
            }
            if secondAllBool == true && indexPath.row == 0{
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                cell.textLabel?.textColor = .black
            } else if indexPath.row == secondSelectedIndex && indexPath.row != 0 {
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                cell.textLabel?.textColor = .black
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            firstSelectedIndex = indexPath.row
            if indexPath.row == 0 {
                firstDict[0] = true
                firstDict[1] = true
            } else if indexPath.row == 1 {
                firstDict[0] = true
                firstDict[1] = false
            } else {
                firstDict[0] = false
                firstDict[1] = true
            }
            dropDownTableView.reloadData()
        } else if tableView.tag == 3{
            if indexPath.row == 0 {
                thirdSelectedArray = [true,false,false,false,false,false,false,false]
                thirdSelectedIndex = indexPath.row
                dropDownTableView.reloadData()
            } else if indexPath.row != 0 && thirdSelectedArray[0] == true {
                thirdSelectedArray[0] = false
                thirdSelectedArray[indexPath.row] = true
                numOfCategory = 1
                thirdSelectedIndex = indexPath.row
                dropDownTableView.reloadData()
            } else {
                let cell = tableView.cellForRow(at: indexPath)
                if cell?.textLabel?.textColor == .systemGray {
                    thirdSelectedArray[indexPath.row] = true
                    cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                    cell?.textLabel?.textColor = .black
                    numOfCategory += 1
                } else {
                    thirdSelectedArray[indexPath.row] = false
                    cell?.textLabel?.font = UIFont.systemFont(ofSize: 17)
                    cell?.textLabel?.textColor = .systemGray
                    numOfCategory -= 1
                    if numOfCategory == 0 {
                        thirdSelectedArray[0] = true
                        thirdSelectedIndex = 0
                        dropDownTableView.reloadData()
                    }
                }
            }
        } else if tableView.tag == 4 {
            fourthSelectedIndex = indexPath.row
            var index = 0
            switch indexPath.row {
            case 0: index = 0
            case 1: index = 100
            case 2: index = 500
            case 3: index = 1000
            case 4: index = 2000
            case 5: index = 3000
            default: break
            }
            fourthDict = index
            dropDownTableView.reloadData()
        }
        if tableView == countryTableView {
            secondSelectedIndex = 0
            secondAllBool = false
            areaIndexArr.removeAll()
            let cell = tableView.cellForRow(at: indexPath)
            areaTableView.isHidden = false
            if cell?.textLabel?.textColor == .systemGray {
                cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                cell?.textLabel?.textColor = .black
                secondSelectedArray.append(countryArr[indexPath.row])
                countryIndexArr.append(indexPath.row)
                tempCountry = cell?.textLabel?.text ?? ""
            } else {
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 17)
                cell?.textLabel?.textColor = .systemGray
                for str in secondSelectedArray {
                    if str.contains("\(tempCountry)") {
                        secondSelectedArray = secondSelectedArray.filter { $0 != str }
                    }
                }
                countryIndexArr = countryIndexArr.filter { $0 != indexPath.row }
                tempCountry = ""
            }
            areaArr = areaArray[indexPath.row]
            areaTableView.reloadData()
        }
        if tableView == areaTableView {
            let cell = tableView.cellForRow(at: indexPath)
            if cell?.textLabel?.textColor == .systemGray {
                cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                cell?.textLabel?.textColor = .black
                if tempCountry != "" {
                secondSelectedArray.append("\(tempCountry)\(areaArr[indexPath.row])")
                }
                areaIndexArr.append(indexPath.row)
            } else {
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 17)
                cell?.textLabel?.textColor = .systemGray
                secondSelectedArray = secondSelectedArray.filter { $0 != cell?.textLabel?.text }
                areaIndexArr = areaIndexArr.filter { $0 != indexPath.row }
            }
            if indexPath.row == 0 && secondAllBool == false {
                secondAllBool = true
                secondSelectedIndex = 0
                areaIndexArr = []
                for str in secondSelectedArray {
                    if str.contains("\(tempCountry)") {
                        secondSelectedArray = secondSelectedArray.filter { $0 != str }
                    }
                }
                secondSelectedArray.append(tempCountry)
                print("s1")
                areaTableView.reloadData()
            } else if indexPath.row == 0 && secondAllBool == true{
                secondAllBool = false
                print("s2")
                areaTableView.reloadData()
            } else if indexPath.row != 0 && secondAllBool == true{
                secondAllBool = false
                secondSelectedIndex = indexPath.row
                print("s3")
                areaTableView.reloadData()
            }
            print("bool: \(secondAllBool)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightConstraint.constant = dropDownTableView.contentSize.height
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(searchArr[indexPath.row].userId)/store_photo_\(searchArr[indexPath.row].id)_6")! , imageView: cell.myImageView)
        cell.myTitleLabel.text = searchArr[indexPath.row].title
        let str = searchArr[indexPath.row].address
        if (str.rangeOfCharacter(from: CharacterSet(charactersIn: "區")) != nil) {
            let index = str.firstIndex(of: "區")
            let str3 = str[...index!]
            cell.myLocationLabel.text = String(str3)
        } else {
            cell.myLocationLabel.text = searchArr[indexPath.row].address
        }
        cell.myNameLabel.text = searchArr[indexPath.row].manager
        let time = timeStringToDate(searchArr[indexPath.row].updateDate)
        cell.myTimeLabel.text = time
        cell.shareBtn.setImage(UIImage(named: "12"), for: .normal)
        
        cell.shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        
            cell.heartBtn.tag = indexPath.row
        
            cell.heartBtn.addTarget(self, action: #selector(follow(_ :)), for: .touchUpInside)
        
            if searchArr[indexPath.row].isFollow == true {
                    cell.heartBtn.setImage(UIImage(named: "followed"), for: .normal)
            } else {
                cell.heartBtn.setImage(UIImage(named: "unfollow"), for: .normal)
            }
        
        cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(14)
        cell.myNameLabel.font = cell.myNameLabel.font.withSize(14)
        cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(14)
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newF = searchArr[indexPath.row]
        if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as? MachineIntroViewController {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        queryFromCoreData()
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        
        bottomLayer.backgroundColor = UIColor.lightGray.cgColor
        bottomLayer.frame = CGRect(x: 0, y: topView.bounds.maxY, width: UIScreen.main.bounds.width, height: 1)
        
        topView.layer.addSublayer(bottomLayer)
        
        //CollectionViewLayout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        
        myCollectionView.collectionViewLayout = layout
        
        myCollectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: "CollectionViewCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.dataSource = self
        areaTableView.delegate = self
        areaTableView.dataSource = self
        
        searchTextField.delegate = self
        
        myLocationManager = CLLocationManager()
        
        myLocationManager.delegate = self
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        myLocationManager.distanceFilter =
          kCLLocationAccuracyNearestTenMeters

        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy =
          kCLLocationAccuracyBest
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 首次使用 向使用者詢問定位自身位置權限
        switch myLocationManager.authorizationStatus {
        case .notDetermined :
            // 取得定位服務授權
        myLocationManager.requestWhenInUseAuthorization()

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
            myLocationManager.startUpdatingLocation()
        default:
            break
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
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
    
    func getSearchItems() {
        // web service Url
        if userData .isEmpty {
            userData.first?.userId = ""
        }
        let url = URL(string: "https://www.surveyx.tw/funchip/search_text.php")!
        // json data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "userId" : "\((userData.first?.userId)!)",
                "my_latitude": my_latitude!,
                "my_longitude": my_longitude!,
                "only_machine" : firstDict[0],
                "only_store" : firstDict[1],
            "search_text":"\(searchTextField.text ?? "")",
                "address_filter" : secondSelectedArray,
                "category" : thirdSelectedArray,
                "nearby_distance" : fourthDict
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
        print("before: \(searchArr.count)")
        searchArr.removeAll()
        print("after: \(searchArr.count)")
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
                let latitude : Double = jsonDict["latitude"] as? Double ?? 0
                let longitude : Double = jsonDict["longitude"] as? Double ?? 0
                let createDate : String = jsonDict["createDate"] as! String
                let updateDate : String = jsonDict["updateDate"] as! String
                let isFollow : Bool = jsonDict["isFollow"] as! Bool
                
                // Create new Machine and set its properties
                let shop = FollowShopMachine(isFollow: isFollow, isStore: isStore, id: id, userId: userId, title: title, description: description, address: address, store_name: "", big_machine_no: big_machine_no, machine_no: machine_no, manager: manager, air_condition: air_condition, fan: fan, wifi: wifi, phone_no: phone_no, line_id: line_id, activity_id: activity_id, remaining_push: remaining_push, announceDate: announceDate, clickTime: clickTime, latitude: latitude, longitude: longitude, createDate: createDate, updateDate: updateDate)
                //Add it to the array
                searchArr.append(shop)
                
            }
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        }
        catch {
            print("There was an error")
        }
    }
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        print("Download Started")
        imageView.image = UIImage(named: "withoutImage")
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
    // textfield return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
      }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }

    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func share() {
        let activityVC = UIActivityViewController(activityItems: ["Let me recommend you this application https://www.surveyx.tw/"], applicationActivities: nil)
        // 顯示出我們的 activityVC。
        self.present(activityVC, animated: true, completion: nil)
    }
    func postFollow(index: Int) {
        let url = URL(string: "https://www.surveyx.tw/funchip/click_follow_store.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        if searchArr[index].isFollow == true {
            json = [
                "userId": "\(userData[0].userId)",
                "objectId": "\(searchArr[index].id)"
            ]
        } else {
            json = [
                "isFollow": "\(searchArr[index].isFollow)",
                "userId": "\(userData[0].userId)",
                "objectId": "\(searchArr[index].id)"
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
    @objc func follow(_ sender : UIButton) {
        postFollow(index: sender.tag)
        if searchArr[sender.tag].isFollow == true {
            searchArr[sender.tag].isFollow = false
            sender.setImage(UIImage(named: "unfollow"), for: .normal)
        } else {
            searchArr[sender.tag].isFollow = true
            sender.setImage(UIImage(named: "followed"), for: .normal)
        }
    }
    
    @objc func sure() {
        dropDownTableView.isHidden = true
        getSearchItems()
        print("結果：\(firstDict),\(secondSelectedArray),\(thirdSelectedArray),\(searchArr.count)")
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropDownTableView.isHidden = true
        areaView.isHidden = true
        }
    @IBAction func areaSureBtnPressed(_ sender: Any) {
        areaView.isHidden = true
        getSearchItems()
        print("結果：\(firstDict),\(secondSelectedArray),\(thirdSelectedArray),\(searchArr.count)")
    }
    
    @IBAction func machineOrShopBtnPressed(_ sender: Any) {
        dropDownTableView.tag = 1
        self.view.endEditing(true)
        if firstBtn.titleLabel?.font == UIFont.systemFont(ofSize: 15){
        numOfTableView = ["不限","機台","店家"]
        dropDownTableView.reloadData()
        areaView.isHidden = true
        dropDownTableView.isHidden = false
            firstBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            secondBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            thirdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            fourthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        } else {
            dropDownTableView.isHidden = true
            firstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    @IBAction func areaBtnPressed(_ sender: Any) {
        self.view.endEditing(true)
        if secondBtn.titleLabel?.font == UIFont.systemFont(ofSize: 15){
        areaView.isHidden = false
        dropDownTableView.isHidden = true
            firstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            secondBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            thirdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            fourthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        } else {
            secondBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            areaView.isHidden = true
        }
        
        let jsonData = readLocalJSONFile(forName: "city_county_data")
        
        if countryArr .isEmpty {
            if let data = jsonData {
                if let sampleAreaObj = parse(jsonData: data) {
                    allAreaList = sampleAreaObj
                    for country in allAreaList{
                        countryArr.append(country.CityName ?? "")
                    }
                    print("num: \(countryArr)")
                    for country in allAreaList {
                        areaArr.append("不限")
                        for i in 0...(country.AreaList?.count)!-1 {
                            areaArr.append(country.AreaList?[i].AreaName ?? "error")
                        }
                        areaArray.append(areaArr)
                        areaArr.removeAll()
                    }
                    
                    areaTableView.reloadData()
                    countryTableView.reloadData()
                }
            }
        }
    }
    @IBAction func classBtnPressed(_ sender: Any) {
        dropDownTableView.tag = 3
        self.view.endEditing(true)
        if thirdBtn.titleLabel?.font == UIFont.systemFont(ofSize: 15){
        numOfTableView = ["不限","3C","雜貨","玩具","模型","娃娃","大貨","其他"]
        dropDownTableView.reloadData()
        areaView.isHidden = true
        dropDownTableView.isHidden = false
            firstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            secondBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            thirdBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            fourthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        } else {
            dropDownTableView.isHidden = true
            thirdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
    }
    @IBAction func distanceBtnPressed(_ sender: Any) {
        dropDownTableView.tag = 4
        self.view.endEditing(true)
        if fourthBtn.titleLabel?.font == UIFont.systemFont(ofSize: 15){
        numOfTableView = ["不限","100公尺 以內","500公尺 以內","1000公尺 以內","2000公尺 以內","3000公尺 以內"]
        dropDownTableView.reloadData()
        areaView.isHidden = true
        dropDownTableView.isHidden = false
            firstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            secondBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            thirdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            fourthBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        } else {
            dropDownTableView.isHidden = true
            fourthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        getSearchItems()
        self.view.endEditing(true)
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
