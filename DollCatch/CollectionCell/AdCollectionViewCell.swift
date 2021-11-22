//
//  AdCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/20.
//

import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
            super.init(frame: frame)

            // 取得螢幕寬度
        let w = UIScreen.main.bounds.width
        let h: Double = 230
            // 建立一個 UIImageView
            myImageView = UIImageView(frame: CGRect(
              x: 0, y: 0,
              width: w, height: h))
        myImageView.contentMode = .scaleAspectFit
            self.addSubview(myImageView)

        self.backgroundColor = .white
        
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
