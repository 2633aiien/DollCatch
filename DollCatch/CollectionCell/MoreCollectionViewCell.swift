//
//  MoreCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/9/17.
//

import UIKit

class MoreCollectionViewCell: UICollectionViewCell {
    var moreBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 取得螢幕寬度
        let w = Double(UIScreen.main.bounds.size.width)

        // 建立一個 UIImageView
        
        moreBtn = UIButton(frame: CGRect(x: (w-40)/2-60, y: 20, width: 120, height: 40))
        moreBtn.setTitle("查看更多", for: .normal)
        moreBtn.setTitleColor(.black, for: .normal)
        moreBtn.backgroundColor = .white
        moreBtn.layer.cornerRadius = 20
        moreBtn.layer.borderWidth = 3
        moreBtn.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.addSubview(moreBtn)
        
        
        self.backgroundColor = .systemGray6
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
