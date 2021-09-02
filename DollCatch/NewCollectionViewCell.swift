//
//  NewCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/8/30.
//

import UIKit

class NewCollectionViewCell: UICollectionViewCell {
    var myTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    var myLocationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    var myNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    var myTimeLabel: UILabel = {
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
    var shareBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    var heartBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 取得螢幕寬度
        let w = Double(UIScreen.main.bounds.size.width)-60
        let h: Double = 120
        // 建立一個 UIImageView
        myImageView = UIImageView(frame: CGRect(
                                    x: 0+20, y: 0,
                                    width: w/3, height: h))
        self.addSubview(myImageView)
        
        // 建立一個 UILabel
        myTitleLabel = UILabel(frame:CGRect(
                                x: w/2, y: 10, width: w/3+10, height: (h-20)/4))
        
        self.addSubview(myTitleLabel)
        
        myLocationLabel = UILabel(frame: CGRect(x: w/2, y: 10+(h-20)/4, width: w/3+10, height: (h-10)/4))
        myLocationLabel.textColor = .gray
        self.addSubview(myLocationLabel)
        myNameLabel = UILabel(frame: CGRect(x: w/2, y: 10+(h-20)/4*2, width: w/3+10, height: (h-10)/4))
        myNameLabel.textColor = .gray
        self.addSubview(myNameLabel)
        myTimeLabel = UILabel(frame: CGRect(x: w/2, y: 10+(h-20)/4*3, width: w/3+10, height: (h-10)/4))
        myTimeLabel.textColor = .gray
        self.addSubview(myTimeLabel)
        shareBtn = UIButton(frame: CGRect(x: w-40, y: 20, width: 40, height: 40))
        shareBtn.tintColor = .black
        self.addSubview(shareBtn)
        heartBtn = UIButton(frame: CGRect(x: w-40, y: h/2+15, width: 40, height: 30))
        heartBtn.tintColor = .black
        self.addSubview(heartBtn)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
