//
//  FirstCustomTableCellView.swift
//  DollCatch
//
//  Created by allen on 2021/9/8.
//

import UIKit

class FirstCustomTableCellView: UIView {

    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let titleLabel = UILabel()
    private let pinImageView = UIImageView()
    private let addressLabel = UILabel()
    private let mapButton = UIButton()
    var arrowLabel = UILabel()
        
    func setUI(title: String, address: String) {
            titleLabel.text = title
            titleLabel.font = titleLabel.font.withSize(15)
            pinImageView.image = UIImage(named: "画板 – 4")
            addressLabel.text = address
            addressLabel.font = addressLabel.font.withSize(15)
            mapButton.setImage(UIImage(named: "18"), for: .normal)
            arrowLabel.text = "▾"
            arrowLabel.textAlignment = .center
            arrowLabel.font = arrowLabel.font.withSize(20)
        }
        
        func commonInit() {
            addSubview(titleLabel)
            addSubview(pinImageView)
            addSubview(addressLabel)
            addSubview(mapButton)
            addSubview(arrowLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            pinImageView.translatesAutoresizingMaskIntoConstraints = false
            addressLabel.translatesAutoresizingMaskIntoConstraints = false
            mapButton.translatesAutoresizingMaskIntoConstraints = false
            arrowLabel.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: pinImageView.topAnchor, constant: -25).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
            pinImageView.bottomAnchor.constraint(equalTo: arrowLabel.topAnchor, constant: -5).isActive = true
            pinImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
            pinImageView.trailingAnchor.constraint(equalTo: addressLabel.leadingAnchor, constant: -10).isActive = true
            pinImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            pinImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
            addressLabel.bottomAnchor.constraint(equalTo: arrowLabel.topAnchor, constant: -5).isActive = true
            addressLabel.trailingAnchor.constraint(equalTo: mapButton.leadingAnchor, constant: 10).isActive = true
            mapButton.bottomAnchor.constraint(equalTo: arrowLabel.topAnchor, constant: -5).isActive = true
            mapButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
            mapButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
            mapButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            mapButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            arrowLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            arrowLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            arrowLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
            
            
            
        }
    }

    final class FirstCustomTableDetailView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let descriptionTextView = UITextField()
        private let arrowLabel = UILabel()

        func setUI(description: String) {
            descriptionTextView.textAlignment = .center
            descriptionTextView.isEnabled = false
            descriptionTextView.isSelected = false
            descriptionTextView.text = description
            
            arrowLabel.text = "▴"
            arrowLabel.textAlignment = .center
            arrowLabel.font = arrowLabel.font.withSize(20)
        }
        
        func commonInit() {
            addSubview(descriptionTextView)
            addSubview(arrowLabel)
            descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
            arrowLabel.translatesAutoresizingMaskIntoConstraints = false
            descriptionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            descriptionTextView.bottomAnchor.constraint(equalTo: arrowLabel.topAnchor, constant: -10).isActive = true
            descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
            arrowLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            arrowLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            arrowLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        }
    }
