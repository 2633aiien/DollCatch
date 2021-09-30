//
//  SecondCustomTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/9/8.
//

import UIKit

class SecondCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shopNameImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var managerImageView: UIImageView!
    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var classfyImageView: UIImageView!
    @IBOutlet weak var classfyTextView: UITextView!
    @IBOutlet weak var machine_no: UIImageView!
    @IBOutlet weak var machine_noLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var ACLabel: UILabel!
    @IBOutlet weak var isACImage: UIImageView!
    @IBOutlet weak var FanLabel: UILabel!
    @IBOutlet weak var isFanImage: UIImageView!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var isWifiImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
