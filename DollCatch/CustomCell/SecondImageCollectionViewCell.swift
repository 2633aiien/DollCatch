//
//  SecondImageCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/9/13.
//

import UIKit

class SecondImageCollectionViewCell: UICollectionViewCell {
    var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
       super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.backgroundColor = .white
       
        myImageView = UIImageView(frame: CGRect(
                                    x: 10, y: 0,
                                    width: 180, height: 160))
        self.addSubview(myImageView)
    }

    
}

