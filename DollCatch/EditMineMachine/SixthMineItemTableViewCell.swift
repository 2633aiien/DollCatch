//
//  SixthTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/8.
//

import UIKit

class SixthMineItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    
    var width = Int(UIScreen.main.bounds.width)
    var height = 150
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        
        secondCollectionView.collectionViewLayout = layout
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension SixthMineItemTableViewCell {
    func setTableViewDataSourceDelegate <D: UICollectionViewDataSource & UICollectionViewDelegate>
            (dataSourceDelegate: D, forRow row: Int) {

            self.secondCollectionView.delegate = dataSourceDelegate
            self.secondCollectionView.dataSource = dataSourceDelegate
            self.secondCollectionView.tag = 2
        }
     
 }
