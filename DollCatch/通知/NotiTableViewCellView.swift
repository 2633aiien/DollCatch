//
//  NotiTableViewCellView.swift
//  DollCatch
//
//  Created by allen on 2021/10/19.
//

import UIKit

class NotiTableViewCellView: UIView {

    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    let w = UIScreen.main.bounds.width
    let h = 120
        private let titleLabel = UILabel()
    private let describeLabel = UILabel()
    private let addressLabel = UILabel()
    private let managerLabel = UILabel()
    private let dateLabel = UILabel()
    var arrowImageView = UIImageView()
        
    func setUI(title: String, describe: String, address: String, manager: String, date: String) {
        
            titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        describeLabel.text = "內容：\n\(describe)"
        describeLabel.font = UIFont.systemFont(ofSize: 15)
        describeLabel.numberOfLines = 2
        addressLabel.text = address
        managerLabel.text = manager
        dateLabel.text = date
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        arrowImageView.image = UIImage(systemName: "chevron.right")!
        arrowImageView.tintColor = .black
        }
        
        func commonInit() {
            addSubview(titleLabel)
            addSubview(describeLabel)
            addSubview(addressLabel)
            addSubview(managerLabel)
            addSubview(dateLabel)
            addSubview(arrowImageView)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            describeLabel.translatesAutoresizingMaskIntoConstraints = false
            addressLabel.translatesAutoresizingMaskIntoConstraints = false
            managerLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            arrowImageView.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: describeLabel.bottomAnchor, constant: -30).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: w/2-30).isActive = true
//            titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            describeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            describeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 20).isActive = true
            describeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -20).isActive = true
            describeLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, constant: 0).isActive = true
//            describeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            addressLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
            addressLabel.bottomAnchor.constraint(equalTo: managerLabel.topAnchor, constant: -10).isActive = true
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20).isActive = true
            addressLabel.widthAnchor.constraint(equalToConstant: w/2-30).isActive = true
            addressLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            managerLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10).isActive = true
            managerLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor, constant: 0).isActive = true
            managerLabel.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: 0).isActive = true
            managerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            
            dateLabel.leadingAnchor.constraint(equalTo: managerLabel.leadingAnchor, constant: 0).isActive = true
            dateLabel.trailingAnchor.constraint(equalTo: managerLabel.trailingAnchor, constant: 0).isActive = true
            dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            arrowImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
            arrowImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
            arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            arrowImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            arrowImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }

}
