//
//  MineCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/8/25.
//

import UIKit

class MineCollectionViewCell: UICollectionViewCell {
    
    var myTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    override init(frame: CGRect) {
            super.init(frame: frame)

            // 取得螢幕寬度
        let w: Double = 130
        let h: Double = 100
            // 建立一個 UIImageView
            myImageView = UIImageView(frame: CGRect(
              x: 40, y: 5,
              width: 90, height: 80))
            self.addSubview(myImageView)

            // 建立一個 UILabel
            myTitleLabel = UILabel(frame:CGRect(
              x: 50, y: h-10, width: 90, height: 15))
            
            self.addSubview(myTitleLabel)
        
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
}
