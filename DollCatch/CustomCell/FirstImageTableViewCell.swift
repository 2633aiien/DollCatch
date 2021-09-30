//
//  FirstImageTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/9/14.
//

import UIKit

class FirstImageTableViewCell: UITableViewCell {
    @IBOutlet weak var firstCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let FirstLayout = UICollectionViewFlowLayout()
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        FirstLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        FirstLayout.minimumLineSpacing = 50
        FirstLayout.minimumInteritemSpacing = 8
        FirstLayout.scrollDirection = .horizontal
        
        // 設置每個 cell 的尺寸
        FirstLayout.itemSize = CGSize(width: 250, height: 180)
        firstCollectionView.collectionViewLayout = FirstLayout
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FirstImageTableViewCell {
    func setCollectionViewDataSourceDelegate
    <D: UICollectionViewDelegate & UICollectionViewDataSource>
    (_ dataSourceDelegate: D, forRow row: Int) {
        firstCollectionView.delegate = dataSourceDelegate
        firstCollectionView.dataSource = dataSourceDelegate
        
        firstCollectionView.reloadData()
    }
}

