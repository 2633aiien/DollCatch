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
    
    
    var bool = true
    
    var newMachineModel = NewMachineModel()
    var newMachines = [newMachine]()
    var newShopModel = NewShopModel()
    var newShops = [newShop]()
    var userData : [UserInformationClass] = []
    
    var nameOfTableView = ""
    
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
            count = 10
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
            cell.myImageView.image =
                UIImage(systemName: "cart")
            cell.myTitleLabel.text = "阿翔的恐龍台~灰熊好夾"
            cell.myLocationLabel.text = "新北市板橋市"
            cell.myNameLabel.text = "小魚"
            cell.myTimeLabel.text = "08/01 18:49"
            
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
            
        } else if collectionView == self.newestCollectionView {
            var newM = newMachines[indexPath.row]

            if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as? MachineIntroViewController{
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
            if let controller = storyboard?.instantiateViewController(withIdentifier: "shopIntro") {
                //self.navigationController?.pushViewController(controller, animated: true)
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var hottestCollectionView: UICollectionView!
    
    @IBOutlet weak var newestCollectionView: UICollectionView!
    
    @IBOutlet weak var newestShopCollectionView: UICollectionView!
    
    var cellWidth = 270
    var cellHeight = 120
    
    var width = Int(UIScreen.main.bounds.width - 20)
    var height = Int(UIScreen.main.bounds.height - 10)
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "rootView")
        let menu = SideMenuNavigationController(rootViewController: viewController!)
        
        newMachineModel.getNewMachineItems()
        newMachineModel.delegate = self
        
        newShopModel.getNewShopItems()
        newShopModel.delegate = self
        
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
        
    
    
    
}

//page...
extension HomePageViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        pageControl.currentPage = Int(page)
    }
}

