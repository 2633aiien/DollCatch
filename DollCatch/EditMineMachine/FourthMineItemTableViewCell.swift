//
//  FourthTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/8.
//

import UIKit

class FourthMineItemTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var bigMachineTextField: UITextField!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var machineTextField: UITextField!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var managerTextField: UITextField!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var fifthImageView: UIImageView!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var lineTextField: UITextField!
    @IBOutlet weak var ACBtn: UIButton!
    @IBOutlet weak var ACLabel: UILabel!
    @IBOutlet weak var fanBtn: UIButton!
    @IBOutlet weak var fanLabel: UILabel!
    @IBOutlet weak var wifiBtn: UIButton!
    @IBOutlet weak var wifiLabel: UILabel!
    
    @IBOutlet weak var CCCBtn: UIButton!
    @IBOutlet weak var CCCLabel: UILabel!
    @IBOutlet weak var groceriesBtn: UIButton!
    @IBOutlet weak var groceriesLabel: UILabel!
    @IBOutlet weak var toyBtn: UIButton!
    @IBOutlet weak var toyLabel: UILabel!
    @IBOutlet weak var dollBtn: UIButton!
    @IBOutlet weak var dollLabel: UILabel!
    @IBOutlet weak var babyBtn: UIButton!
    @IBOutlet weak var babyLabel: UILabel!
    @IBOutlet weak var bigItemBtn: UIButton!
    @IBOutlet weak var bigItemLabel: UILabel!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var otherLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ACBtn.setTitle("", for: .normal)
        fanBtn.setTitle("", for: .normal)
        wifiBtn.setTitle("", for: .normal)
        bigMachineTextField.setBottomBorder()
        bigMachineTextField.font = UIFont.systemFont(ofSize: 17)
        machineTextField.setBottomBorder()
        machineTextField.font = UIFont.systemFont(ofSize: 17)
        managerTextField.setBottomBorder()
        managerTextField.font = UIFont.systemFont(ofSize: 17)
        phoneTextField.setBottomBorder()
        phoneTextField.font = UIFont.systemFont(ofSize: 17)
        lineTextField.setBottomBorder()
        lineTextField.font = UIFont.systemFont(ofSize: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func ACBtnPressed(_ sender: Any) {
        if ACBtn.tag == 1 {
            ACBtn.tag = 2
            ACBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            ACBtn.tag = 1
            ACBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    @IBAction func fanBtnPressed(_ sender: Any) {
        if fanBtn.tag == 1 {
            fanBtn.tag = 2
            fanBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            fanBtn.tag = 1
            fanBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    @IBAction func wifiBtnPressed(_ sender: Any) {
        if wifiBtn.tag == 1 {
            wifiBtn.tag = 2
            wifiBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            wifiBtn.tag = 1
            wifiBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    @IBAction func CCCBtnPressed(_ sender: Any) {
        if CCCBtn.tag == 1 {
            CCCBtn.tag = 2
            CCCBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            CCCBtn.tag = 1
            CCCBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    @IBAction func groceriesBtnPressed(_ sender: Any) {
        if groceriesBtn.tag == 1 {
            groceriesBtn.tag = 2
            groceriesBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            groceriesBtn.tag = 1
            groceriesBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    @IBAction func toyBtnPressed(_ sender: Any) {
        if toyBtn.tag == 1 {
            toyBtn.tag = 2
            toyBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            toyBtn.tag = 1
            toyBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    @IBAction func dollBtnPressed(_ sender: Any) {
        if dollBtn.tag == 1 {
            dollBtn.tag = 2
            dollBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            dollBtn.tag = 1
            dollBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    @IBAction func babyBtnPressed(_ sender: Any) {
        if babyBtn.tag == 1 {
            babyBtn.tag = 2
            babyBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            babyBtn.tag = 1
            babyBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    @IBAction func bigItemBtnPressed(_ sender: Any) {
        if bigItemBtn.tag == 1 {
            bigItemBtn.tag = 2
            bigItemBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            bigItemBtn.tag = 1
            bigItemBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    @IBAction func otherBtnPressed(_ sender: Any) {
        if otherBtn.tag == 1 {
            otherBtn.tag = 2
            otherBtn.setImage(UIImage(named: "画板 – 5"), for: .normal)
        } else {
            otherBtn.tag = 1
            otherBtn.setImage(UIImage(named: "画板 – 4-1"), for: .normal)
        }
    }
    

}
