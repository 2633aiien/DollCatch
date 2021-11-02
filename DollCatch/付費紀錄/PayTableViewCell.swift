//
//  PayTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/19.
//

import UIKit

class PayTableViewCell: UITableViewCell {

    private let cellView = PayTableViewCellView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonInit()
    }
    func setUI(title: String, money: String, date: String) {
        cellView.setUI(title: title, money: money, date: date)
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
