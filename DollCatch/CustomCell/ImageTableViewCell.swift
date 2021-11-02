//
//  ImageTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/9/13.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let secondLayout = UICollectionViewFlowLayout()
        
                // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
                secondLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        secondLayout.minimumLineSpacing = 50
                secondLayout.minimumInteritemSpacing = 10
                secondLayout.scrollDirection = .horizontal
        
                // 設置每個 cell 的尺寸
                secondLayout.itemSize = CGSize(width: 200, height: 140)
                secondCollectionView.collectionViewLayout = secondLayout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//extension ImageTableViewCell {
//    func setCollectionViewDataSourceDelegate
//    <D: UICollectionViewDelegate & UICollectionViewDataSource>
//    (_ dataSourceDelegate: D, forRow row: Int) {
//        secondCollectionView.delegate = dataSourceDelegate
//        secondCollectionView.dataSource = dataSourceDelegate
//        
//        secondCollectionView.reloadData()
//    }
//}
