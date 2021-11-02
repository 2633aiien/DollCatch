//
//  PayTableViewCellView.swift
//  DollCatch
//
//  Created by allen on 2021/10/19.
//

import UIKit

class PayTableViewCellView: UIView {

    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    let w = UIScreen.main.bounds.width
    let h = 100
        private let titleLabel = UILabel()
    private let moneyLabel = UILabel()
    private let dateLabel = UILabel()
        
    func setUI(title: String, money: String, date: String) {
        
            titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        moneyLabel.text = "方案： 新台幣\(money)/月"
        moneyLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.text = "啟用時間：\(date)"
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        }
        
        func commonInit() {
            addSubview(titleLabel)
            addSubview(moneyLabel)
            addSubview(dateLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            moneyLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: w/2-40).isActive = true
            moneyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
            moneyLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10).isActive = true
            moneyLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 40).isActive = true
            moneyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            moneyLabel.widthAnchor.constraint(equalToConstant: w/2-40).isActive = true
            moneyLabel.heightAnchor.constraint(equalToConstant: CGFloat(h/2-30)).isActive = true
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            dateLabel.leadingAnchor.constraint(equalTo: moneyLabel.leadingAnchor, constant: 0).isActive = true
            dateLabel.trailingAnchor.constraint(equalTo: moneyLabel.trailingAnchor, constant: 0).isActive = true
            dateLabel.heightAnchor.constraint(equalTo: moneyLabel.heightAnchor, constant: 0).isActive = true
            
        }
}
