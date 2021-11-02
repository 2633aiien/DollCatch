//
//  DetailTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/18.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonInit()
    }
    private let containerView = UIStackView()
    private let cellView = TableViewCellView()
    private let detailView = TableViewCellDetailView()

    func setUI(title: String, date: String, dates: String) {
            cellView.setUI(title: title, date: date)
            detailView.setUI(dates: dates)
        }
        
        func commonInit() {
            selectionStyle = .none
            detailView.isHidden = true

            
            containerView.axis = .vertical
            contentView.addSubview(containerView)
            containerView.addArrangedSubview(cellView)
            containerView.addArrangedSubview(detailView)
            
            containerView.translatesAutoresizingMaskIntoConstraints = false
            cellView.translatesAutoresizingMaskIntoConstraints = false
            detailView.translatesAutoresizingMaskIntoConstraints = false
            
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        }
}

extension DetailTableViewCell {
    var isDetailViewHidden: Bool {
        return detailView.isHidden
    }

    func showDetailView() {
        detailView.isHidden = false
        cellView.arrowLabel.isHidden = true
    }

    func hideDetailView() {
        detailView.isHidden = true
        cellView.arrowLabel.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isDetailViewHidden, selected {
            showDetailView()
        } else {
            hideDetailView()
        }
    }
}
