//
//  PlanCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/6.
//

import UIKit

class PlanCollectionViewCell: UICollectionViewCell {
    
    var myTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    var myNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    var myPriceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 取得螢幕寬度
        let w = Double(UIScreen.main.bounds.size.width)
        let h: Double = 200
        
        // 建立一個 UILabel
        myTitleLabel = UILabel(frame:CGRect(
                                x: 0, y: 10, width: w, height: (h-20)/3))
        myTitleLabel.textColor = .black
        myTitleLabel.textAlignment = .center
        myTitleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.addSubview(myTitleLabel)
        
        myNumberLabel = UILabel(frame: CGRect(x: 0, y: 10+(h-20)/3, width: w, height: (h-20)/3))
        myNumberLabel.textColor = .black
        myNumberLabel.textAlignment = .center
        myNumberLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.addSubview(myNumberLabel)
        myPriceLabel = UILabel(frame: CGRect(x: 0, y: 10+(h-20)/3*2, width: w, height: (h-20)/3))
        myPriceLabel.textColor = .white
        myPriceLabel.textAlignment = .center
        myPriceLabel.font = UIFont.systemFont(ofSize: 23)
        myPriceLabel.backgroundColor = .orange
        self.addSubview(myPriceLabel)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
