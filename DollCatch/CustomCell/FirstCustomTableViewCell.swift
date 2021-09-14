//
//  FirstCustomTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/9/8.
//

import UIKit

class FirstCustomTableViewCell: UITableViewCell {
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var pinImageView: UIImageView!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var mapButton: UIButton!
//    @IBOutlet weak var descriptionTextField: UITextField!
//    @IBOutlet weak var arrowLabel: UILabel!
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//            super.init(style: style, reuseIdentifier: reuseIdentifier)
//            commonInit()
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
    override func awakeFromNib() {
       super.awakeFromNib()
       //custom logic goes here
        commonInit()
    }
        
        private let containerView = UIStackView()
        private let cellView = FirstCustomTableCellView()
        private let detailView = FirstCustomTableDetailView()
        
        func setUI(title: String, address: String, description: String) {
            cellView.setUI(title: title, address: address)
            detailView.setUI(description: description)
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

    extension FirstCustomTableViewCell {
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
