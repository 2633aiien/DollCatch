//
//  ManagementViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import SideMenu
import CoreData

class mineCell {
    var image : UIImage!
    var name : String!
}

class MineManagementViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var mineCollectionView: UICollectionView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var photoBackView: UIView!
    @IBOutlet weak var adCollectionView: UICollectionView!
    var adArr : [AdStruct] = []
    var imageIndex = 0
    var timer = Timer()
    
    var mineCellArr : [mineCell] = []
    let menu = SideMenuNavigationController(rootViewController: RootViewController())
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    var userData : [UserInformationClass] = []
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == adCollectionView {
            if userData .isEmpty {
                return 1
            } else {
            return adArr.count
            }
        } else {
        return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adCollectionView {
            if userData .isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AdCollectionViewCell
                cell.myImageView.contentMode = .scaleToFill
                downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/pay_ad/ad_00")!, imageView: cell.myImageView)
                return cell
            } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AdCollectionViewCell
                cell.myImageView.contentMode = .scaleToFill
            downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/pay_ad/ad_0\(adArr[indexPath.row].position)")!, imageView: cell.myImageView)
            return cell
            }
        } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineCollectionViewCell", for: indexPath) as! MineCollectionViewCell
        
        cell.myImageView.image = mineCellArr[indexPath.row].image
        cell.myTitleLabel.text = mineCellArr[indexPath.row].name
        
        return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var id = ""
        if collectionView == adCollectionView {
            let urlString = adArr[indexPath.row].adUrl
            let url = URL(string: urlString)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
        switch indexPath.row {
        
        case 0:
            id = "mineShopMachine"
        case 1:
            id = "mineShopMachine"
        case 2:
            id = "notifiHistory"
        case 3:
            id = "unfinish"
            print("我要投廣告尚未開放")
        case 4:
            id = "payRecord"
        case 5:
            id = "unfinish"
            print("聯絡客服尚未開放")
        default:
            break
        }
        
        
        if indexPath.row == 0 {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "mineShopMachine") as? MineShopMachineViewController {
                controller.isStore = true
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
            }
        }else if indexPath.row == 1 {
                if let controller = storyboard?.instantiateViewController(withIdentifier: "mineShopMachine") as? MineShopMachineViewController {
                controller.isStore = false
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
                }
        } else if indexPath.row == 3{
            let urlString = "http://www.surveyx.tw/funchip/contact_us.html"
            let url = URL(string: urlString)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else if indexPath.row == 5{
            let urlString = "http://www.surveyx.tw/funchip/contact_us.html"
            let url = URL(string: urlString)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else if let controller = storyboard?.instantiateViewController(withIdentifier: id) {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
        }
    }
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        iconBtn.layer.cornerRadius = 0.5 * iconBtn.bounds.size.width
//        iconBtn.clipsToBounds = true
//        backgroundView.roundCorners(corners: [.topLeft, .topRight], radius: 50)
        backgroundView.layer.cornerRadius = 50
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        

        // sidebar
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        SideMenuManager.default.leftMenuNavigationController = menu
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (w-45-16)/2, height: 120)
        
        mineCollectionView.collectionViewLayout = layout
        
        let layoutAd = UICollectionViewFlowLayout()
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layoutAd.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layoutAd.minimumInteritemSpacing = 0
        layoutAd.scrollDirection = .horizontal
        layoutAd.itemSize = CGSize(width: w, height: 230)
        
        adCollectionView.collectionViewLayout = layoutAd
        
        adCollectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        adCollectionView.delegate = self
        adCollectionView.dataSource = self
        
        mineCollectionView.register(
            MineCollectionViewCell.self,
            forCellWithReuseIdentifier: "MineCollectionViewCell")
        mineCollectionView.delegate = self
        mineCollectionView.dataSource = self
        
        var mine1 = mineCell()
        self.mineCellArr.append(mine1)
        mine1.image = UIImage(named: "13")
        mine1.name = "我的店家"
        var mine2 = mineCell()
        self.mineCellArr.append(mine2)
        mine2.image = UIImage(named: "joystick-1")
        mine2.name = "我的機台"
        var mine3 = mineCell()
        self.mineCellArr.append(mine3)
        mine3.image = UIImage(named: "23")
        mine3.name = "推播歷史"
        var mine4 = mineCell()
        self.mineCellArr.append(mine4)
        mine4.image = UIImage(named: "21")
        mine4.name = "我要投廣告"
        var mine5 = mineCell()
        self.mineCellArr.append(mine5)
        mine5.image = UIImage(named: "22")
        mine5.name = "付費紀錄"
        var mine6 = mineCell()
        self.mineCellArr.append(mine6)
        mine6.image = UIImage(named: "14")
        mine6.name = "聯絡客服"
        photoBtn.layer.cornerRadius = 75/2
        photoBackView.layer.cornerRadius = 75/2
        photoImageView.layer.cornerRadius = 75/2
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        queryFromCoreData()
        if userData .isEmpty {
            photoImageView.image = UIImage(named: "image")
            loginBtn.setTitle("登入", for: .normal)
            loginBtn.tintColor = .black
            loginBtn.isEnabled = true
            photoBtn.isEnabled = false
        } else {
            
            downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(userData[0].userId)/person_photo")!, imageView: photoImageView)
            photoImageView.contentMode = .scaleAspectFill
            loginBtn.setTitle("\(userData[0].nickname)", for: .normal)
            loginBtn.tintColor = .black
            loginBtn.isEnabled = false
            photoBtn.isEnabled = true
        }
        if !userData .isEmpty {
            adArr.removeAll()
        getAd()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
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
    @IBAction func loginBtnPressed(_ sender: Any) {
        if userData.isEmpty {
            let controller = storyboard?.instantiateViewController(withIdentifier: "login")
            let navigationController = UINavigationController(rootViewController: controller!)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false, completion: nil)
        }
    }
    @IBAction func addBtnPressed(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "choosePlan") {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    @IBAction func hamburgerBtn(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "rootView")
        let menu = SideMenuNavigationController(rootViewController: viewController!)
        menu.leftSide = true
        menu.settings.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        present(menu, animated: true, completion: nil)
    }
    @IBAction func photoBtnPressed(_ sender: Any) {
        if !userData.isEmpty {
            let controller = storyboard?.instantiateViewController(withIdentifier: "personalInformation")
            let navigationController = UINavigationController(rootViewController: controller!)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false, completion: nil)
        }
    }
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()

            // Call the roundCorners() func right there.
//            backgroundView.roundCorners(corners: [.topLeft, .topRight], radius: 50)

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
    func getAd() {
        let serviceUrl = "https://www.surveyx.tw/funchip/get_pay_ad.php"
        // json data
        let url = URL(string: serviceUrl)!
        
        var request = URLRequest(url: url)
        let json: [String: Any] = [
            "userId": "\((userData.first?.userId)!)",
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
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
                adArr.append(ad)
            }
            DispatchQueue.main.async {
                print("urlArrayy: \(self.adArr)")
                self.adCollectionView.reloadData()
                if self.adArr.count > 1 {
                self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
                }
            }
        }
        catch {
            print("There was an error")
        }
    }
    
    @objc func autoScroll() {
        var indexPath: IndexPath
        imageIndex += 1
        if imageIndex < adArr.count {
            indexPath = IndexPath(item: imageIndex, section: 0)
            adCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            imageIndex = -1
            indexPath = IndexPath(item: imageIndex, section: 0)
            adCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            autoScroll()
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
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
