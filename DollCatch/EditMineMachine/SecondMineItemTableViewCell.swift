//
//  SecondTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/8.
//

import UIKit

class SecondMineItemTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.font = UIFont.systemFont(ofSize: 17)
        titleTextField.setBottomBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
