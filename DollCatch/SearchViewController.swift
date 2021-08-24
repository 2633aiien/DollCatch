//
//  SearchViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        cell.myImageView.image = UIImage(systemName: "cart")
        cell.myTitleLabel.text = "阿翔的恐龍台~灰熊好夾"
        cell.myLocationLabel.text = "新北市板橋市"
        cell.myNameLabel.text = "小魚"
        cell.myTimeLabel.text = "08/01 18:49"
        cell.shareBtn.setImage(UIImage(named: "12"), for: .normal)
        cell.heartBtn.setImage(UIImage(named: "28"), for: .normal)
        
        cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(14)
        cell.myNameLabel.font = cell.myNameLabel.font.withSize(14)
        cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(14)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let controller = storyboard?.instantiateViewController(withIdentifier: "shopIntro") {
            //self.navigationController?.pushViewController(controller, animated: true)
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    var width = Int(UIScreen.main.bounds.width)-60
    var height = 120
    
    var bottomLayer = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
