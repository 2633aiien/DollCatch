//
//  FirstTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/8.
//

import UIKit

class FirstMineItemTableViewCell: UITableViewCell {
    @IBOutlet weak var homePageLabel: UILabel!
    @IBOutlet weak var objectIdLabel: UILabel!
    @IBOutlet weak var firstCollectionView: UICollectionView!
    
    var width = 250
    var height = 150
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        
        firstCollectionView.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FirstMineItemTableViewCell {
    func setTableViewDataSourceDelegate <D: UICollectionViewDataSource & UICollectionViewDelegate>
            (dataSourceDelegate: D, forRow row: Int) {

        
            self.firstCollectionView.delegate = dataSourceDelegate
            self.firstCollectionView.dataSource = dataSourceDelegate
            self.firstCollectionView.tag = 1
        }
     
 }
