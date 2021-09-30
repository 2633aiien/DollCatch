//
//  ThirdCustomTableViewCellView.swift
//  DollCatch
//
//  Created by allen on 2021/9/9.
//

import UIKit

class ThirdCustomTableViewCellView: UIView {

    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let titleLabel = UILabel()
    var arrowLabel = UILabel()
    
        
        func setUI() {
            titleLabel.text = "活動資訊"
            titleLabel.font = titleLabel.font.withSize(15)
            
            arrowLabel.text = "▾"
            arrowLabel.textAlignment = .center
            arrowLabel.font = arrowLabel.font.withSize(20)
            
        }
        
        func commonInit() {
            addSubview(titleLabel)
            addSubview(arrowLabel)
           
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            arrowLabel.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: arrowLabel.topAnchor, constant: -5).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
            
            arrowLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            arrowLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            arrowLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
            
            
            
}
}
final class ThirdCustomTableDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let descriptionTextView = UITextView()
    private let arrowLabel = UILabel()

    func setUI(description: String) {
        descriptionTextView.textAlignment = .left
//        descriptionTextView.font = descriptionTextView.font?.withSize(20)
        descriptionTextView.text = description
        
        arrowLabel.text = "▴"
        arrowLabel.textAlignment = .center
        arrowLabel.font = arrowLabel.font.withSize(20)
    }
    
    func commonInit() {
        addSubview(descriptionTextView)
        addSubview(arrowLabel)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isSelectable = false
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: arrowLabel.topAnchor, constant: -10).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        
        arrowLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        arrowLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
    }
}
