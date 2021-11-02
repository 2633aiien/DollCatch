//
//  SecondCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/7.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell {
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
    var myPushTimeLabel: UILabel = {
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
    var editBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    var pushBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let w = Double(UIScreen.main.bounds.size.width)-60
        let h: Double = 180
        // 建立一個 UIImageView
        myImageView = UIImageView(frame: CGRect(
                                    x: 10, y: 10,
                                    width: w/2-20, height: h-20))
        self.addSubview(myImageView)
        
        // 建立一個 UILabel
        myTitleLabel = UILabel(frame:CGRect(
                                x: w/2+10, y: 10, width: w/4, height: (h-20)/5))
        
        self.addSubview(myTitleLabel)
        
        myLocationLabel = UILabel(frame: CGRect(x: w/2+10, y: 10+(h-20)/5, width: w/4, height: (h-20)/5))
        myLocationLabel.textColor = .gray
        self.addSubview(myLocationLabel)
        myNameLabel = UILabel(frame: CGRect(x: w/2+10, y: 10+(h-20)/5*2, width: w/4, height: (h-20)/5))
        myNameLabel.textColor = .gray
        self.addSubview(myNameLabel)
        myTimeLabel = UILabel(frame: CGRect(x: w/2+10, y: 10+(h-20)/5*3, width: w/4, height: (h-20)/5))
        myTimeLabel.textColor = .gray
        self.addSubview(myTimeLabel)
        myPushTimeLabel = UILabel(frame: CGRect(x: w/2+10, y: 10+(h-20)/5*4, width: w/4, height: (h-20)/5))
        myPushTimeLabel.textColor = .gray
        myPushTimeLabel.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(myPushTimeLabel)
        editBtn = UIButton(frame: CGRect(x: w-60, y: 0, width: 30, height: h))
        editBtn.setTitle("編輯", for: .normal)
        editBtn.tintColor = .white
        editBtn.backgroundColor = .gray
        editBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        editBtn.titleLabel?.numberOfLines = 0
        editBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        self.addSubview(editBtn)
        pushBtn = UIButton(frame: CGRect(x: w-30, y: 0, width: 30, height: h))
        pushBtn.setTitle("推播", for: .normal)
        pushBtn.tintColor = .white
        pushBtn.backgroundColor = .orange
        pushBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        pushBtn.titleLabel?.numberOfLines = 0
        pushBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        pushBtn.clipsToBounds = true
        pushBtn.layer.cornerRadius = 10
        pushBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        self.addSubview(pushBtn)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
