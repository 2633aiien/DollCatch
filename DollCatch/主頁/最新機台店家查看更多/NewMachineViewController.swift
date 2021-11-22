//
//  NewMachineViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import MapKit

class NewMachineViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet var containers: [UIView]!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    var isShop : Bool!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var mapBtn: UIBarButtonItem!
    @IBOutlet weak var myMapView: MKMapView!
    var myLocationManager :CLLocationManager!
    var my_latitude : Double! = 0
    var my_longitude : Double! = 0
    
    var moreMInt = 0
    var moreSInt = 0
    var newShops = [newShop]()
    var newMachines = [newMachine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let yourBackImage = UIImage(named: "back tabbar")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = .black
        if isShop == true {
        self.segmentControl.selectedSegmentIndex = 0
            firstView.isHidden = true
            secondView.isHidden = false
        } else {
            self.segmentControl.selectedSegmentIndex = 1
            firstView.isHidden = false
            secondView.isHidden = true
        }
        myLocationManager = CLLocationManager()
        
        myLocationManager.delegate = self
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        myLocationManager.distanceFilter =
        kCLLocationAccuracyNearestTenMeters
        
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy =
        kCLLocationAccuracyBest
        
        // myMapView
        // 設置委任對象
        myMapView.delegate = self
        
        // 地圖樣式
        myMapView.mapType = .standard
        
        // 顯示自身定位位置
        myMapView.showsUserLocation = true
        
        // 允許縮放地圖
        myMapView.isZoomEnabled = true
        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan =
        MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        myMapView.userTrackingMode = .follow
        myMapView.register(MyAnnotationView.self, forAnnotationViewWithReuseIdentifier: "id")
        
        getMoreStore()
        getMoreMachine()
    }
        @IBAction func mapBtnPressed(_ sender: Any) {
        if mapBtn.tag == 1 {
            mapBtn.tag = 2
            mapBtn.image = UIImage(named: "listTabber")
        myMapView.isHidden = false
        } else {
            mapBtn.tag = 1
            mapBtn.image = UIImage(named: "18")
            myMapView.isHidden = true
        }
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
    
    @IBAction func shopMachine(_ sender: UISegmentedControl) {
        containers.forEach {
               $0.isHidden = true
            }
        containers[sender.selectedSegmentIndex].isHidden = false
        if mapBtn.tag == 2 {
            locateUser()
        self.addAnnotation()
        }
    }
    
    
    func getMoreStore() {
        let url = URL(string: "https://www.surveyx.tw/funchip/new_store.php")!
        // json data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "more_store_no": "\(moreSInt)",
        ]
//        moreSInt += 1
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
                addAnnotation()
            }
        }
        catch {
            print("There was an error")
        }
    }
    
    func getMoreMachine() {
        // web service Url
        let url = URL(string: "https://www.surveyx.tw/funchip/new_machine.php")!
        // json data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "more_machine_no": "\(moreMInt)",
        ]
//        moreMInt += 1
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    // succceeded
                    
                    // Call the parse json function on the data
                    self.parseMoreMachineJson(data: data!)
                    
                } else {
                    print("error: \(error)")
                }
            }
            // start the task
            task.resume()
    }
    
    func parseMoreMachineJson(data: Data) {
        
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
                let store_name : String = jsonDict["store_name"] as? String ?? "null"
                let manager : String = jsonDict["manager"] as? String ?? "null"
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
                
                // Create new Machine and set its properties
                let machine = newMachine(isStore: isStore, id: id, userId: userId, title: title, description: description, address_city: address_city, address_area: address_area, address_name: address_name, store_name: store_name, manager: manager, phone_no: phone_no, line_id: line_id, activity_id: activity_id, remaining_push: remaining_push, announceDate: announceDate, clickTime: clickTime, latitude: latitude, longitude: longitude, createDate: createDate, updateDate: updateDate)
                //Add it to the array
                newMachines.append(machine)
                addAnnotation()
            }
        }
        catch {
            print("There was an error")
        }
    }
    func addAnnotation() {
        DispatchQueue.main.async {
            self.myMapView.removeAnnotations(self.myMapView.annotations)
        
        if self.segmentControl.selectedSegmentIndex == 1 {
            for i in 0...self.newMachines.count-1 {
                var objectAnnotation = MKPointAnnotation()
                objectAnnotation.coordinate = CLLocation(
                    latitude: Double(self.newMachines[i].latitude) ?? 0,
                    longitude: Double(self.newMachines[i].longitude) ?? 0).coordinate
                objectAnnotation.title = self.newMachines[i].title
                
                //            objectAnnotation.subtitle =
                //              "艋舺公園位於龍山寺旁邊，原名為「萬華十二號公園」。"
                self.myMapView.addAnnotation(objectAnnotation)
            }
        } else if self.segmentControl.selectedSegmentIndex == 0 {
            for i in 0...self.newShops.count-1 {
                var objectAnnotation = MKPointAnnotation()
                objectAnnotation.coordinate = CLLocation(
                    latitude: Double(self.newShops[i].latitude) ?? 0,
                    longitude: Double(self.newShops[i].longitude) ?? 0).coordinate
                objectAnnotation.title = self.newShops[i].title
                //            objectAnnotation.subtitle =
                //              "艋舺公園位於龍山寺旁邊，原名為「萬華十二號公園」。"
                self.myMapView.addAnnotation(objectAnnotation)
            }
        }
        }
    }
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        //1
        let locale = Locale(identifier: "zh_TW")
        let loc: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        if #available(iOS 11.0, *) {
            CLGeocoder().reverseGeocodeLocation(loc, preferredLocale: locale) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else {
                    UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                    completion(nil, error)
                    return
                }
                completion(placemark, nil)
            }
        }
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
