//
//  NotificationTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/19.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    private let cellView = NotiTableViewCellView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonInit()
    }
    
    func setUI(title: String, describe: String, address: String, manager: String, date: String) {
        cellView.setUI(title: title, describe: describe, address: address, manager: manager, date: date)
    }
    func commonInit() {
        contentView.addSubview(cellView)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        cellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
