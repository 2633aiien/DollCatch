//
//  FirstCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/7.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewCell {
    var myLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let w = Double(UIScreen.main.bounds.size.width)-60
        let h: Double = 180
        // 建立一個 UIImageView
        myImageView = UIImageView(frame: CGRect(
                                    x: 10, y: 10,
                                    width: w/2, height: w/2-20))
        myImageView.image = UIImage(named: "画板 – 4-1")
        self.addSubview(myImageView)
        myLabel = UILabel(frame: CGRect(x: w/2+50, y: 10, width: w/2-20, height: w/2-20))
        myLabel.textColor = .gray
        myLabel.text = "+新增"
        myLabel.font = UIFont.boldSystemFont(ofSize: 35)
        self.addSubview(myLabel)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
