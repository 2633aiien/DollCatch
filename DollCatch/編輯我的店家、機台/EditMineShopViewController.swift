//
//  ShopPlanViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import CoreData
import MapKit
import CropViewController

class EditMineShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    
    var objectId = ""
    var isStore = true
    var information = FollowShopMachine()
    var tempImage = UIImage(named: "image")
    var userdata : [UserInformationClass] = []
    var index = -1
    
    var cell0: FirstMineItemTableViewCell!
    var cell1: SecondMineItemTableViewCell!
    var cell2: ThirdMineItemTableViewCell!
    var cell3: FourthMineItemTableViewCell!
    var cell4: FifthMineItemTableViewCell!
    var cell5: SixthMineItemTableViewCell!
    
    var latitude = 0.0
    var longitude = 0.0
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        queryFromCoreData()
        if isStore == true {
            self.title = "店家介紹"
        } else {
            self.title = "機台介紹"
        }
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            tapGesture.cancelsTouchesInView = false
        myTableView.addGestureRecognizer(tapGesture)
        
        saveBtn.setBackgroundImage(UIImage(named: "画板 – 8"), for: .normal, barMetrics: .default)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        if collectionView.tag == 2 {
            let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "SecondMineItemCollectionViewCell", for: indexPath)
            as! SecondMineItemCollectionViewCell
            if isStore == true {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(userdata[0].userId)/store_photo_\(information.id)_\(indexPath.row+1)")! , imageView: cell.myImageView)
            } else {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(userdata[0].userId)/machine_photo_\(information.id)_\(indexPath.row+1)")! , imageView: cell.myImageView)
            }
            getItemName(nameField: cell.myNameTextField, describeField: cell.myDescribeTextField, index: indexPath.row)
            cell.myImageBtn.addTarget(self, action: #selector(selectImage(_:)), for: .touchUpInside)
            cell.myImageBtn.tag = indexPath.row + 1
            
            return cell
        } else {
            let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "FirstMineItemCollectionViewCell", for: indexPath) as! FirstMineItemCollectionViewCell
            if isStore == true {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(userdata[0].userId)/store_photo_\(information.id)_\(indexPath.row+6)")! , imageView: cell.myImageView)
            } else {
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(userdata[0].userId)/machine_photo_\(information.id)_\(indexPath.row+6)")! , imageView: cell.myImageView)
            }
            cell.selectImageButton.addTarget(self, action: #selector(selectImage(_:)), for: .touchUpInside)
            cell.selectImageButton.tag = indexPath.row + 6
            cell.deleteImageButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
            cell.deleteImageButton.tag = indexPath.row + 6
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let bigCollectionViewCell = cell as? SixthMineItemTableViewCell {
        bigCollectionViewCell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        } else if let cell = cell as? FirstMineItemTableViewCell {
            cell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
    case 0 :
            cell0 = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath) as? FirstMineItemTableViewCell
            if isStore == true {
                cell0.homePageLabel.text = "店家首頁"
                cell0.objectIdLabel.text = "編號：s0000\(information.id)"
            } else {
                cell0.homePageLabel.text = "機台首頁"
                cell0.objectIdLabel.text = "編號：m0000\(information.id)"
            }
            
            return cell0
    case 1 :
            cell1 = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath) as? SecondMineItemTableViewCell
            if isStore == true {
                cell1.titleLabel.text = "店家標題"
            } else {
                cell1.titleLabel.text = "機台標題"
            }
            cell1.titleTextField.text = information.title
            return cell1
    case 2 :
            cell2 = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath) as? ThirdMineItemTableViewCell
            if isStore == true {
                cell2.describeLabel.text = "店家描述"
            } else {
                cell2.describeLabel.text = "機台描述"
            }
            
            let countryStr = information.address_city
            let areaStr = information.address_area
            let nameStr = information.address_name
            
            cell2.countryBtn.setTitle(String("\(countryStr)     ▾"), for: .normal)
            cell2.areaBtn.setTitle(String("\(areaStr)     ▾"), for: .normal)

            cell2.addressTextField.text = nameStr
            cell2.describeTextField.text = information.description
            return cell2
    case 3 :
            cell3 = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath) as? FourthMineItemTableViewCell
            if isStore == true {
                cell3.titleLabel.text = "店內資訊"
                cell3.firstImageView.image = UIImage(named: "joystick-1")
                cell3.bigMachineTextField.text = information.big_machine_no
                cell3.secondImageView.image = UIImage(named: "5555555558-1")
                cell3.machineTextField.text = information.machine_no
                cell3.thirdImageView.image = UIImage(named: "user-2")
                cell3.managerTextField.text = information.manager
                cell3.fourthImageView.image = UIImage(named: "phone-1")
                cell3.phoneTextField.text = information.phone_no
                cell3.fifthImageView.image = UIImage(named: "line-3")
                cell3.lineTextField.text = information.line_id
                if information.air_condition == true {
                    cell3.ACBtn.tag = 2
                    cell3.ACBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
                if information.fan == true {
                    cell3.fanBtn.tag = 2
                    cell3.fanBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
                if information.wifi == true {
                    cell3.wifiBtn.tag = 2
                    cell3.wifiBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
            } else {
                cell3.titleLabel.text = "機台資訊"
                cell3.firstImageView.image = UIImage(named: "55656565")
                cell3.firstLabel.text = "店家名稱："
                
                cell3.secondImageView.image = UIImage(named: "user-2")
                cell3.secondLabel.text = "管理者："
                
                cell3.thirdImageView.image = UIImage(named: "phone-1")
                cell3.thirdLabel.text = "電話："
                
                cell3.fourthImageView.image = UIImage(named: "line-3")
                cell3.fourthLabel.text = "LINE："
                
                cell3.fifthImageView.image = UIImage(named: "hoggo")
                cell3.fifthLabel.text = "類別："
                
                cell3.lineTextField.isHidden = true
                cell3.ACBtn.isHidden = true
                cell3.ACLabel.isHidden = true
                cell3.fanBtn.isHidden = true
                cell3.fanLabel.isHidden = true
                cell3.wifiBtn.isHidden = true
                cell3.wifiLabel.isHidden = true
                cell3.CCCBtn.isHidden = false
                cell3.CCCLabel.isHidden = false
                
                cell3.groceriesBtn.isHidden = false
                cell3.groceriesLabel.isHidden = false
                
                cell3.toyBtn.isHidden = false
                cell3.toyLabel.isHidden = false
                
                cell3.dollBtn.isHidden = false
                cell3.dollLabel.isHidden = false
                
                cell3.babyBtn.isHidden = false
                cell3.babyLabel.isHidden = false
                
                cell3.bigItemBtn.isHidden = false
                cell3.bigItemLabel.isHidden = false
                
                cell3.otherBtn.isHidden = false
                cell3.otherLabel.isHidden = false
                getClassItems(btn1: cell3.CCCBtn, btn2: cell3.groceriesBtn, btn3: cell3.toyBtn, btn4: cell3.dollBtn, btn5: cell3.babyBtn, btn6: cell3.bigItemBtn, btn7: cell3.otherBtn)
            }
            return cell3
    case 4 :
            cell4 = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath) as? FifthMineItemTableViewCell
            getActivity(textField: cell4.activityTextField)
            
            return cell4
    case 5 :
            cell5 = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath) as? SixthMineItemTableViewCell
            if isStore == true {
                cell5.titleLabel.text = "店內機台"
            } else {
                cell5.titleLabel.text = "商品介紹"
            }
            
            return cell5
    default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath)
            return cell
            break
        }
    }
    @objc func hideKeyboard() {
        myTableView.endEditing(true)
    }
    func queryFromCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<UserInformationClass>(entityName: "UserInformationClass")
        
        moc.performAndWait {
            do{
                self.userdata = try moc.fetch(fetchRequest)//查詢，回傳為[Note]
            }catch{
                print("error \(error)")
                self.userdata = []//如果有錯，回傳空陣列
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        presentCropViewController(image: image)
        
        

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
    func postPhotoImage(image: UIImage) {
        do {
                var url = URL(string: "https://www.surveyx.tw/funchip/upload_image_machine.php")
            if isStore == true {
                url = URL(string: "https://www.surveyx.tw/funchip/upload_image_store.php")
            }
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
                
                let boundary = generateBoundaryString()

              //define the multipart request type

                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            if (image == nil)
                {
                    return
                }
//            var image_data = tempImage!.pngData()
            let image_data = image.jpegData(compressionQuality: 0.5)
                
                if(image_data == nil)
                {
                    return
                }
                

                var body = Data()
                
                let fname = "test.png"
                let mimetype = "image/png"
                
            //define the data post parameter

            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("hi\r\n".data(using: String.Encoding.utf8)!)

                
                
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"uploaded_file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(image_data!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                
                
                body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            // try
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"userId\"; filename=\"\(userdata[0].userId)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"objectId\"; filename=\"\(information.id)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"position\"; filename=\"\(index)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            //
            
            
            request.httpBody = body
            
                let session = URLSession.shared

                
            let task = session.dataTask(with: request) {
                    (
                        data, response, error) in
                    
                guard let _:Data = data, let _:URLResponse = response, error == nil else {
                        print("error")
                        return
                    }
                    
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(dataString)
                let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.main.async {
                    print("resultttt: \(responseJSON["result"] ?? true), reason: \(responseJSON["reason"] ?? "")")
                    if responseJSON["result"]! as! Bool == true {
                        if self.index > 5 {
                    self.cell0.firstCollectionView.reloadData()
                        } else {
                    self.cell5.secondCollectionView.reloadData()
                        }
                    }
                }
                }
                
                }
                
                task.resume()
                
            }
            
            
            func generateBoundaryString() -> String
            {
                return "Boundary-\(NSUUID().uuidString)"
            }
    }
    
    func getItemName(nameField: UITextField, describeField: UITextField, index: Int) {
        let url = URL(string: "https://www.surveyx.tw/funchip/get_activity.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        if isStore == true {
            json = [
                "storeId":"\(objectId)"
            ]
        } else {
        json = [
            "machineId":"\(objectId)"
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
                
                DispatchQueue.main.async {
                    nameField.text = responseJSON["photo_name\(index+1)"] as? String ?? ""
                    describeField.text = responseJSON["photo_describe\(index+1)"] as? String ?? ""
                }
                
            }
        }
        task.resume()
    }
    func save() {
        
        if cell1.titleTextField.text == "" {
            let controller = UIAlertController(title: "標題不可為空白", message: "請填入標題", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell2.addressTextField.text == "" {
            let controller = UIAlertController(title: "地址不可為空白", message: "請填入地址", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell2.describeTextField.text == "" {
            let controller = UIAlertController(title: "描述不可為空白", message: "請填入描述", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.bigMachineTextField.text == "" {
            let controller = UIAlertController(title: "巨無霸機臺數不可為空白", message: "請填入巨無霸機臺數", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.machineTextField.text == "" {
            let controller = UIAlertController(title: "機臺數不可為空白", message: "請填入機臺數", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.managerTextField.text == "" {
            let controller = UIAlertController(title: "管理者不可為空白", message: "請填入管理者", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.phoneTextField.text == "" {
            let controller = UIAlertController(title: "手機號碼不可為空白", message: "請填入手機號碼", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.lineTextField.text == "" {
            let controller = UIAlertController(title: "LINE id不可為空白", message: "請填入LINE id", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString("\(cell2.countryName)\(cell2.areaName)\(cell2.addressTextField.text!)", completionHandler: {(placemarks:[CLPlacemark]!,error:Error!) in
                if error != nil{
                    print(error!)
                    return
                }
                if placemarks != nil && placemarks.count > 0{
                    let placemark = placemarks[0] as CLPlacemark
                    self.latitude = placemark.location?.coordinate.latitude ?? 0.0
                    self.longitude = placemark.location?.coordinate.longitude ?? 0.0
                }
            })
            var url = URL(string: "https://www.surveyx.tw/funchip/update_introduction_machine.php")!
            if isStore == true {
                url = URL(string: "https://www.surveyx.tw/funchip/update_introduction_store.php")!
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            var json: [String: Any] = [:]
            if isStore == true {
                    var ACBool = true
                    var fanBool = true
                    var wifiBool = true
                    if cell3.ACBtn.tag == 1 {
                        ACBool = false
                    } else {
                        ACBool = true
                    }
                    if cell3.fanBtn.tag == 1 {
                        fanBool = false
                    } else {
                        fanBool = true
                    }
                    if cell3.wifiBtn.tag == 1 {
                        wifiBool = false
                    } else {
                        wifiBool = true
                    }
                        json = [
                    "objectName":"\(cell1.titleTextField.text!)",
                    "objectDescribe":"\(cell2.describeTextField.text!)",
                    "address_city":"\(cell2.countryName)",
                    "address_area":"\(cell2.areaName)",
                    "address_name":"\(cell2.addressTextField.text!)",
                    "bigMachine":"\(cell3.bigMachineTextField.text!)",
                    "machine":"\(cell3.machineTextField.text!)",
                    "manager":"\(cell3.managerTextField.text!)",
                    "air_condition":"\(ACBool)",
                    "fan":"\(fanBool)",
                    "wifi":"\(wifiBool)",
                    "phoneNo":"\(cell3.phoneTextField.text!)",
                    "lineId":"\(cell3.lineTextField.text!)",
                    "latitude":"\(latitude)",
                    "longitude":"\(longitude)",
                    "storeId":"\(information.id)",
                    "activity":"\(cell4.activityTextField.text!)"
                ]
            } else {
                var cccBool = true
                var groceriesBool = true
                var toyBool = true
                var dollBool = true
                var babyBool = true
                var bigItemBool = true
                var otherBool = true
                if cell3.CCCBtn.tag == 1 {
                    cccBool = false
                }
                if cell3.groceriesBtn.tag == 1 {
                    groceriesBool = false
                }
                if cell3.toyBtn.tag == 1 {
                    toyBool = false
                }
                if cell3.dollBtn.tag == 1 {
                    dollBool = false
                }
                if cell3.babyBtn.tag == 1 {
                    babyBool = false
                }
                if cell3.bigItemBtn.tag == 1 {
                    bigItemBool = false
                }
                if cell3.otherBtn.tag == 1 {
                    otherBool = false
                }
            json = [
                "objectName":"\(cell1.titleTextField.text!)",
                "objectDescribe":"\(cell2.describeTextField.text!)",
                "address":"\(cell2.addressTextField.text!)",
                "storeName":"\(cell3.bigMachineTextField.text!)",
                "manager":"\(cell3.machineTextField.text!)",
                "phoneNo":"\(cell3.managerTextField.text!)",
                "lineId":"\(cell3.phoneTextField.text!)",
                "latitude":"\(latitude)",
                "longitude":"\(longitude)",
                "machineId":"\(information.id)",
                "activity":"\(cell4.activityTextField.text!)",
                "ccc":"\(cccBool)",
                "groceries":"\(groceriesBool)",
                "toy":"\(toyBool)",
                "figure":"\(dollBool)",
                "doll":"\(babyBool)",
                "bulk_goods":"\(bigItemBool)",
                "other":"\(otherBool)"
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
                    
                    DispatchQueue.main.async {
//                        nameField.text = responseJSON["photo_name\(index+1)"] as? String ?? ""
//                        describeField.text = responseJSON["photo_describe\(index+1)"] as? String ?? ""
                        if responseJSON["result"] as! Bool == true {
                            let controller = UIAlertController(title: "儲存成功", message: "", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        } else if responseJSON["result"] as! Bool == false {
                            let controller = UIAlertController(title: "儲存失敗", message: "請稍後再試", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
            task.resume()
        }
         
    }
    
    func getClassItems(btn1: UIButton, btn2: UIButton, btn3: UIButton, btn4: UIButton, btn5: UIButton, btn6: UIButton, btn7: UIButton) {
        let url = URL(string: "https://www.surveyx.tw/funchip/get_machine_category.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "userId": "\(userdata[0].userId)",
            "machineId": "\(information.id)"
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
                    btn1.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
                if groceries == true {
                    btn2.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
                if toy == true {
                    btn3.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
                if figure == true {
                    btn4.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
                if doll == true {
                    btn5.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
                if bulk_goods == true {
                    btn6.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
                if other == true {
                    btn7.setImage(UIImage(named: "画板 – 5"), for: .normal)
                }
                
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
        task.resume()
    }
    func getActivity(textField: UITextField) {
        let url = URL(string: "https://www.surveyx.tw/funchip/get_activity.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        if isStore == true {
            json = [
                "storeId":"\(information.id)"
            ]
        } else {
            json = [
                "machineId":"\(information.id)"
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
                
                DispatchQueue.main.async {
                    textField.text = responseJSON["content"]! as? String ?? ""
                }
                
            }
        }
        task.resume()
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        save()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        if cell1.titleTextField.text == "" {
            let controller = UIAlertController(title: "標題不可為空白", message: "請填入標題", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell2.addressTextField.text == "" {
            let controller = UIAlertController(title: "地址不可為空白", message: "請填入地址", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell2.describeTextField.text == "" {
            let controller = UIAlertController(title: "描述不可為空白", message: "請填入描述", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.bigMachineTextField.text == "" {
            let controller = UIAlertController(title: "巨無霸機臺數不可為空白", message: "請填入巨無霸機臺數", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.machineTextField.text == "" {
            let controller = UIAlertController(title: "機臺數不可為空白", message: "請填入機臺數", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.managerTextField.text == "" {
            let controller = UIAlertController(title: "管理者不可為空白", message: "請填入管理者", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.phoneTextField.text == "" {
            let controller = UIAlertController(title: "手機號碼不可為空白", message: "請填入手機號碼", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if cell3.lineTextField.text == "" {
            let controller = UIAlertController(title: "LINE id不可為空白", message: "請填入LINE id", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "beginTabbar") as? UITabBarController {
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: false, completion: nil)
            }
        }
    }
    func presentCropViewController(image: UIImage) {
      
      let cropViewController = CropViewController(image: image)
      cropViewController.delegate = self
      present(cropViewController, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            // 'image' is the newly cropped version of the original image
        cropViewController.dismiss(animated: true, completion: nil)
        postPhotoImage(image: image)
        }
    @objc func selectImage(_ sender : UIButton) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        index = sender.tag
        
        let imageAlertController = UIAlertController(title: "選擇相片", message: "", preferredStyle: .actionSheet)
        let imageFromLibAction = UIAlertAction(title: "從相簿選取", style: .default) { (Void) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imageController.sourceType = .photoLibrary
                self.present(imageController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "照相", style: .default) { (Void) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imageController.sourceType = .camera
                self.present(imageController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            imageController.dismiss(animated: true, completion: nil)
        }
        imageAlertController.addAction(imageFromCameraAction)
        imageAlertController.addAction(imageFromLibAction)
        imageAlertController.addAction(cancelAction)
        
        present(imageAlertController, animated: true, completion: nil)
    }

    
    @objc func deleteImage(_ sender : UIButton) {
        index = sender.tag + 6
        let url = URL(string: "https://www.surveyx.tw/funchip/delete_photo.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
            json = [
                "userId": "\(userdata[0].userId)",
                "isStore": "\(isStore)",
                "id": "\(information.id)",
                "position": "\(index)"
            ]
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
