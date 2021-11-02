//
//  FifthTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/8.
//

import UIKit

class FifthMineItemTableViewCell: UITableViewCell {
    @IBOutlet weak var activityTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityTextField.setBottomBorder()
        activityTextField.font = UIFont.systemFont(ofSize: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
