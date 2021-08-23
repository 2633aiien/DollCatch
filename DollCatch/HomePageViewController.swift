//
//  ViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import SideMenu

class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var nameOfTableView = ""
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
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
            cell.myImageView.image =
                UIImage(systemName: "cart")
            cell.myTitleLabel.text = "阿翔的恐龍台~灰熊好夾"
            cell.myLocationLabel.text = "新北市土城"
            cell.myNameLabel.text = "小魚"
            cell.myTimeLabel.text = "08/01 18:49"
            
            cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(12)
            cell.myNameLabel.font = cell.myNameLabel.font.withSize(12)
            cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(12)
            cell.myTimeLabel.textAlignment = .right
            myCell = cell
        }
        else if collectionView == self.newestShopCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewShopCell", for: indexPath) as! MySecondCollectionViewCell
            
            cell.myImageView.image =
                UIImage(systemName: "cart")
            cell.myTitleLabel.text = "阿翔的恐龍台~灰熊好夾"
            cell.myLocationLabel.text = "新北市三峽"
            cell.myNameLabel.text = "小魚"
            cell.myTimeLabel.text = "08/01 18:49"
            cell.myTitleLabel.numberOfLines = 1
            cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(14)
            cell.myNameLabel.font = cell.myNameLabel.font.withSize(14)
            cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(14)
            myCell = cell
            
        }
        return myCell
        
    }
    
    @IBOutlet weak var hottestCollectionView: UICollectionView!
    
    @IBOutlet weak var newestCollectionView: UICollectionView!
    
    @IBOutlet weak var newestShopCollectionView: UICollectionView!
    
    var cellWidth = 270
    var cellHeight = 120
    
    var width = Int(UIScreen.main.bounds.width - 20)
    var height = Int(UIScreen.main.bounds.height - 10)
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    let menu = SideMenuNavigationController(rootViewController: RootViewController())
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
//        let vc = storyboard!.instantiateViewController(withIdentifier: "begin") as! HomePageViewController
//        let navigationController = UINavigationController(rootViewController: vc)
//        self.present(navigationController, animated: true, completion: nil)
        
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
    
    @IBAction func hamburgerBtn(_ sender: Any) {
        menu.leftSide = true
        menu.settings.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        present(menu, animated: true, completion: nil)
        //        dismiss(animated: true, completion: nil)
    }
    
}

//page...
extension HomePageViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        pageControl.currentPage = Int(page)
    }
}

