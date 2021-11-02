//
//  TableViewCellView.swift
//  DollCatch
//
//  Created by allen on 2021/10/18.
//

import UIKit

class TableViewCellView: UIView {

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
    private let historyLabel = UILabel()
    private let dateLabel = UILabel()
    var arrowLabel = UILabel()
        
    func setUI(title: String, date: String) {
        
            titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        historyLabel.text = "推播紀錄："
        historyLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.text = date
        dateLabel.font = UIFont.systemFont(ofSize: 15)
            arrowLabel.text = "▾"
            arrowLabel.textAlignment = .center
            arrowLabel.font = arrowLabel.font.withSize(20)
        }
        
        func commonInit() {
            addSubview(titleLabel)
            addSubview(historyLabel)
            addSubview(dateLabel)
            addSubview(arrowLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            historyLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            arrowLabel.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
            titleLabel.widthAnchor.constraint(equalTo: historyLabel.widthAnchor, constant: 0).isActive = true
            historyLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 0).isActive = true
            historyLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0).isActive = true
            historyLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20).isActive = true
            historyLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -20).isActive = true
            historyLabel.widthAnchor.constraint(equalTo: dateLabel.widthAnchor, constant: 0).isActive = true
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            dateLabel.bottomAnchor.constraint(equalTo: arrowLabel.topAnchor, constant: -20).isActive = true
            dateLabel.leadingAnchor.constraint(equalTo: arrowLabel.leadingAnchor, constant: 0).isActive = true
            dateLabel.trailingAnchor.constraint(equalTo: arrowLabel.trailingAnchor, constant: 0).isActive = true
            dateLabel.heightAnchor.constraint(equalToConstant: CGFloat(h/2-20)).isActive = true
            arrowLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            arrowLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
            arrowLabel.heightAnchor.constraint(equalToConstant: CGFloat(h/2-20)).isActive = true
            arrowLabel.widthAnchor.constraint(equalToConstant: w/3-20).isActive = true
        }
    
}

final class TableViewCellDetailView: UIView {
    let w = UIScreen.main.bounds.width
    let h = 100
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let datesTextView = UITextView()
    private let arrowLabel = UILabel()

    func setUI(dates: String) {
        datesTextView.isEditable = false
        datesTextView.isSelectable = false
        datesTextView.font = UIFont.systemFont(ofSize: 15)
        datesTextView.text = dates
        adjustUITextViewHeight(arg: datesTextView)
        datesTextView.textAlignment = .left
        
        arrowLabel.text = "▴"
        arrowLabel.textAlignment = .center
        arrowLabel.font = arrowLabel.font.withSize(20)
    }
    
    func commonInit() {
        addSubview(datesTextView)
        addSubview(arrowLabel)
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        datesTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: -20).isActive = true
        datesTextView.bottomAnchor.constraint(equalTo: arrowLabel.topAnchor, constant: -10).isActive = true
        datesTextView.leadingAnchor.constraint(equalTo: arrowLabel.leadingAnchor, constant: -10).isActive = true
        datesTextView.trailingAnchor.constraint(equalTo: arrowLabel.trailingAnchor, constant: 10).isActive = true
        
//        datesTextView.heightAnchor.constraint(equalToConstant: CGFloat(h)).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        arrowLabel.heightAnchor.constraint(equalToConstant: CGFloat(h/2-20)).isActive = true
        arrowLabel.widthAnchor.constraint(equalToConstant: w/3-20).isActive = true
    }
}

func adjustUITextViewHeight(arg : UITextView)
{
    arg.translatesAutoresizingMaskIntoConstraints = false
    arg.sizeToFit()
    arg.isScrollEnabled = false
}
