//
//  ShopIntroViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit


class MachineIntroViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstCollectionView: UICollectionView!
    
    
    var tempTitle = "aa"
    var tempId = ""
    var tempUserId = ""
    var tempAddress = "aa"
    var tempDescription = ""
    var tempStoreName = ""
    var tempManager = ""
    var tempLine = ""
    var tempPhone = ""
    var tempClass = ""
    var tempActivity = ""
    var classArr = [Bool]()
    
    var imageArr : [UIImageView] = []
    var imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        getClassItems()
        getActivity()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let FirstLayout = UICollectionViewFlowLayout()
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        FirstLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        FirstLayout.minimumInteritemSpacing = 8
        FirstLayout.scrollDirection = .horizontal
        
        // 設置每個 cell 的尺寸
        FirstLayout.itemSize = CGSize(width: 250, height: 180)
        
        
        firstCollectionView.collectionViewLayout = FirstLayout
        
        firstCollectionView.register(
            FirstImageCollectionViewCell.self,
            forCellWithReuseIdentifier: "FirstImageCell")
        
        firstCollectionView.delegate = self
        firstCollectionView.dataSource = self
        firstCollectionView.alwaysBounceHorizontal = true
        
//        
//        
//        secondCollectionView.register(
//            SecondImageCollectionViewCell.self,
//            forCellWithReuseIdentifier: "SecondImageCell")
//        secondCollectionView.delegate = self
//        secondCollectionView.dataSource = self
//        secondCollectionView.alwaysBounceHorizontal = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.firstCollectionView {
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "FirstImageCell", for: indexPath)
                as! FirstImageCollectionViewCell
            downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(tempUserId)/machine_photo_\(tempId)_\(indexPath.row+6)")! , imageView: cell.myImageView)
            
            return cell
        } else {
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "SecondImageCell", for: indexPath)
                as! SecondImageCollectionViewCell
            downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(tempUserId)/machine_photo_\(tempId)_\(indexPath.row+1)")! , imageView: cell.myImageView)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "firstCustomCell") as! FirstCustomTableViewCell
            cell.setUI(title: tempTitle, address: tempAddress, description: tempDescription)
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "secondCustomCell") as! SecondCustomTableViewCell
            cell.shopNameLabel.text = "店家名稱：\(tempStoreName)"
            cell.managerLabel.text = "管理者：\(tempManager)"
            cell.lineLabel.text = "LINE：\(tempLine)"
            cell.phoneLabel.text = "電話：\(tempPhone)"
            
            cell.classfyTextView.text = "\(tempClass)"
            
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "thirdCustomCell") as! ThirdCustomTableViewCell
            cell.setUI(description: tempActivity)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "imageCustomCell") as! ImageTableViewCell
            return cell
        }
        
            }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.performBatchUpdates(nil)
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? FirstCustomTableViewCell {
            cell.hideDetailView()
        }
    }
    func downloadImage(from url: URL, imageView: UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                imageView.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getClassItems() {
        let url = URL(string: "https://www.surveyx.tw/funchip/get_machine_category.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "userId": "\(tempUserId)",
            "machineId": "\(tempId)"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                    
                    let ccc = responseJSON["ccc"]! as! Bool
                    let groceries = responseJSON["groceries"]! as! Bool
                    let toy = responseJSON["toy"]! as! Bool
                    let figure = responseJSON["figure"]! as! Bool
                    let doll = responseJSON["doll"]! as! Bool
                    let bulk_goods = responseJSON["bulk_goods"]! as! Bool
                    let other = responseJSON["other"]! as! Bool
                    
                if ccc == true {
                    self.tempClass.append("3c ")
                }
                
                if groceries == true {
                    self.tempClass.append("雜貨 ")
                }
                if toy == true {
                    self.tempClass.append("玩具 ")
                }
                if figure == true {
                    self.tempClass.append("公仔 ")
                }
                if doll == true {
                    self.tempClass.append("娃娃 ")
                }
                if bulk_goods == true {
                    self.tempClass.append("大貨 ")
                }
                if other == true {
                    self.tempClass.append("其他")
                }
                if self.tempClass.count > 9 {
                    self.tempClass.insert("\n", at: self.tempClass.index(self.tempClass.startIndex, offsetBy: 9))
                    if self.tempClass.count > 19 {
                        self.tempClass.insert("\n", at: self.tempClass.index(self.tempClass.startIndex, offsetBy: 19))
                    }
                }
                
                
                print("字數：\(self.tempClass.count)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func getActivity() {
        let url = URL(string: "https://www.surveyx.tw/funchip/get_activity.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "machineId":"\(tempId)"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                self.tempActivity = responseJSON["content"]! as! String
            }
        }
        task.resume()
    }
    
    
    
    @IBAction func backIba(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
