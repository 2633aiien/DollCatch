//
//  ThirdTableViewCell.swift
//  DollCatch
//
//  Created by allen on 2021/10/8.
//

import UIKit

class ThirdMineItemTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == countryTableView {
            return countryArr.count
        } else {
            return areaArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == countryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.textLabel?.tintColor = .black
            if countryArr.isEmpty {
                cell.textLabel?.text = ""
            } else {
                cell.textLabel?.text = countryArr[indexPath.row]
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.textLabel?.tintColor = .black
            if areaArr.isEmpty {
                cell.textLabel?.text = ""
            }else {
                cell.textLabel?.text = areaArr[indexPath.row]
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapppppp")
        if tableView == countryTableView {
            countryTableView.isHidden = true
            countryBtn.setTitle("\(countryArr[indexPath.row])     ▾", for: .normal)
            countryName = countryArr[indexPath.row]
            areaArr = areaArray[indexPath.row]
            areaBtn.setTitle("\(areaArr[0])     ▾", for: .normal)
            areaTableView.reloadData()
        } else {
            areaTableView.isHidden = true
            areaBtn.setTitle("\(areaArr[indexPath.row])     ▾", for: .normal)
            areaName = areaArr[indexPath.row]
        }
    }
    
    
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var describeLabel: UILabel!
    @IBOutlet weak var describeTextField: UITextField!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var areaTableView: UITableView!
    
    var allAreaList: [AreaClass] = []
    var countryArr: [String] = []
    var areaArr: [String] = []
    var areaArray: [[String]] = []
    
    var countryName = "台北市"
    var areaName = "中正區"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addressTextField.setBottomBorder()
        addressTextField.font = UIFont.systemFont(ofSize: 17)
        describeTextField.setBottomBorder()
        describeTextField.font = UIFont.systemFont(ofSize: 17)
        countryTableView.delegate = self
        countryTableView.dataSource = self
        areaTableView.delegate = self
        areaTableView.dataSource = self
        
        let jsonData = readLocalJSONFile(forName: "city_county_data")
        
        if countryArr .isEmpty {
            if let data = jsonData {
                if let sampleAreaObj = parse(jsonData: data) {
                    allAreaList = sampleAreaObj
                    for country in allAreaList{
                        countryArr.append(country.CityName ?? "")
                    }
                    print("num: \(countryArr)")
                    for country in allAreaList {
                        for i in 0...(country.AreaList?.count)!-1 {
                            areaArr.append(country.AreaList?[i].AreaName ?? "error")
                        }
                        areaArray.append(areaArr)
                        areaArr.removeAll()
                    }
                    
                    areaTableView.reloadData()
                    countryTableView.reloadData()
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func contryBtnPressed(_ sender: Any) {
        countryTableView.isHidden = false
        areaTableView.isHidden = true
    }
    @IBAction func areaBtnPressed(_ sender: Any) {
        areaTableView.isHidden = false
        countryTableView.isHidden = true
    }
    
}
extension ThirdMineItemTableViewCell {
    func setTableViewDataSourceDelegate <D: UITableViewDataSource & UITableViewDelegate>
            (dataSourceDelegate: D, forRow row: Int) {

        
            self.countryTableView.delegate = dataSourceDelegate
            self.countryTableView.dataSource = dataSourceDelegate
            self.countryTableView.tag = 2
        
        self.areaTableView.delegate = dataSourceDelegate
        self.areaTableView.dataSource = dataSourceDelegate
        self.areaTableView.tag = 3
        }
     
 }

