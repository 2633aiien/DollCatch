//
//  FirstCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/8.
//

import UIKit

class FirstMineItemCollectionViewCell: UICollectionViewCell {
    var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    var selectImageButton: UIButton = {
        let button = UIButton()
        return button
    }()
    var deleteImageButton: UIButton = {
        let button = UIButton()
        return button
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        let w: Double = 250
        let h: Double = 150
        // 建立一個 UIImageView
        myImageView = UIImageView(frame: CGRect(
                                    x: 0, y: 0,
                                    width: w, height: h))
        self.addSubview(myImageView)
        selectImageButton = UIButton(frame: CGRect(x: w-45, y: 0, width: 20, height: 20))
        selectImageButton.cornerRadius = 10
        selectImageButton.tintColor = .black
        selectImageButton.setImage(UIImage(systemName: "photo.circle.fill"), for: .normal)
        self.addSubview(selectImageButton)
        deleteImageButton = UIButton(frame: CGRect(x: w-20, y: 0, width: 20, height: 20))
        deleteImageButton.cornerRadius = 10
        deleteImageButton.tintColor = .black
        deleteImageButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        self.addSubview(deleteImageButton)
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}
