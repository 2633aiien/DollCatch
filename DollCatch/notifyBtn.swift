//
//  notifyBtn.swift
//  DollCatch
//
//  Created by allen on 2021/10/25.
//

import UIKit

class ImageBarButton: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var numLabel = UILabel()
    var button = UIButton()
    var w = 30
    var h = 37

        override init(frame: CGRect) {
            super.init(frame: frame)
            
            numLabel = UILabel(frame: CGRect(x: w-13, y: 0, width: 13, height: 13))
            numLabel.backgroundColor = .red
            numLabel.textColor = .white
            numLabel.layer.cornerRadius = 13/2
            numLabel.clipsToBounds = true
            numLabel.contentMode = .scaleAspectFill
            self.addSubview(numLabel)

            button.backgroundColor = .clear
            button.tintColor = .black
            button.setImage(UIImage(named: "26-1"), for: .normal)
            button.setTitle("", for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: w, height: h)
            self.addSubview(button)
        }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        func load()-> UIBarButtonItem {
            return UIBarButtonItem(customView: self)
        }
}

