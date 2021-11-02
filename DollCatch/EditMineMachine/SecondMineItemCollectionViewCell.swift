//
//  SecondCollectionViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/8.
//

import UIKit

class SecondMineItemCollectionViewCell: UICollectionViewCell {
    var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    var myImageBtn: UIButton = {
       let button = UIButton()
        return button
    }()
    var myNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    var myNameTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    var myDescribeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    var myDescribeTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let w = Double(UIScreen.main.bounds.size.width)
        let h: Double = 150
        // 建立一個 UIImageView
        myImageView = UIImageView(frame: CGRect(
                                    x: 0, y: 0,
                                    width: w/2, height: h))
        self.addSubview(myImageView)
        
        myImageBtn = UIButton(frame: CGRect(x: 0, y: 0, width: w/2, height: h))
        myImageBtn.setTitle("", for: .normal)
        myImageBtn.backgroundColor = .clear
        self.addSubview(myImageBtn)
        
        // 建立一個 UILabel
        myNameLabel = UILabel(frame:CGRect(
                                x: w/2+10, y: 0, width: w/4-10, height: h/4))
        myNameLabel.text = "機台名稱："
        self.addSubview(myNameLabel)
        
        myNameTextField = UITextField(frame: CGRect(x: w*3/4, y: 0, width: w/4, height: h/4))
        myNameTextField.setBottomBorder()
        myNameTextField.font = UIFont.systemFont(ofSize: 17)
        myNameTextField.textColor = .black
        self.addSubview(myNameTextField)
        
        myDescribeLabel = UILabel(frame: CGRect(x: w/2+10, y: h/4, width: w/2-10, height: h/4))
        myDescribeLabel.textColor = .black
        myDescribeLabel.text = "機台描述："
        self.addSubview(myDescribeLabel)
        myDescribeTextField = UITextField(frame: CGRect(x: w/2+10, y: h/2, width: w/2-10, height: h/2-20))
        myDescribeTextField.setBottomBorder()
        myDescribeTextField.font = UIFont.systemFont(ofSize: 17)
        myDescribeTextField.textColor = .black
        self.addSubview(myDescribeTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}
