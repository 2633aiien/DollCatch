//
//  FirstImageCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/9/13.
//

import UIKit

class FirstImageCollectionViewCell: UICollectionViewCell {
    var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.backgroundColor = .white
        
        myImageView = UIImageView(frame: CGRect(
                                    x: 0, y: 0,
                                    width: 250, height: 180))
        self.addSubview(myImageView)
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}

