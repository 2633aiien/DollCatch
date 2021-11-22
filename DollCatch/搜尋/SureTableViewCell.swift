//
//  SureTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/9/22.
//

import UIKit

class SureTableViewCell: UITableViewCell {
    
    var sureBtn: UIButton = {
        let button = UIButton()
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        let w = Double(UIScreen.main.bounds.size.width)

        // 建立一個 UIImageView
        
        sureBtn = UIButton(frame: CGRect(x: w/2-40, y: 0, width: 80, height: 40))
        sureBtn.setTitle("確定", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.backgroundColor = .orange
        sureBtn.layer.cornerRadius = 15
        
        self.contentView.addSubview(sureBtn)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
