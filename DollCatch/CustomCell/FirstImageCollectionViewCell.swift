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
        self.layer.cornerRadius = 40
        self.backgroundColor = .white
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        myImageView = UIImageView(frame: CGRect(
                                    x: 5, y: 5,
                                    width: 250, height: 180))
        self.addSubview(myImageView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

