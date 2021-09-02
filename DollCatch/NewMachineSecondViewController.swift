//
//  NewMachineSecondViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/30.
//

import UIKit

class NewMachineSecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var width = Int(UIScreen.main.bounds.width)-40
    var height = 120
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewShopCollectionViewCell", for: indexPath) as! NewCollectionViewCell
        cell.myImageView.image = UIImage(systemName: "cart")
        cell.myTitleLabel.text = "machine"
        cell.myLocationLabel.text = "新北市板橋市"
        cell.myNameLabel.text = "小魚"
        cell.myTimeLabel.text = "08/01 18:49"
        cell.shareBtn.setImage(UIImage(named: "12"), for: .normal)
        
        cell.shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        
        cell.heartBtn.setImage(UIImage(named: "28"), for: .normal)
        
        cell.myLocationLabel.font = cell.myLocationLabel.font.withSize(14)
        cell.myNameLabel.font = cell.myNameLabel.font.withSize(14)
        cell.myTimeLabel.font = cell.myTimeLabel.font.withSize(14)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") {
            //self.navigationController?.pushViewController(controller, animated: true)
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        
        myCollectionView.collectionViewLayout = layout
        
        myCollectionView.register(
            NewCollectionViewCell.self,
            forCellWithReuseIdentifier: "NewShopCollectionViewCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
    
    @objc func share() {
        let activityVC = UIActivityViewController(activityItems: ["Let me recommend you this application https://www.surveyx.tw/"], applicationActivities: nil)
            // 顯示出我們的 activityVC。
            self.present(activityVC, animated: true, completion: nil)
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
