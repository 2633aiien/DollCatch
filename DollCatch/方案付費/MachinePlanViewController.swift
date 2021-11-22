//
//  MachinePlanViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import CoreData

class MachinePlanViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let w = Double(UIScreen.main.bounds.size.width)
    let h: Double = 200
    var machineOrShop = ""
    var projectArray = [Project]()
    var userData : [UserInformationClass] = []
    var tempId = -1

    @IBOutlet weak var myCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        queryFromCoreData()
        self.title = "\(machineOrShop)方案"
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        getProject()
        
        //CollectionViewLayout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 60, left: 20, bottom: 60, right: 20)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: w, height: h)
        
        myCollectionView.collectionViewLayout = layout
        
        myCollectionView.register(
            PlanCollectionViewCell.self,
            forCellWithReuseIdentifier: "PlanCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanCollectionViewCell", for: indexPath) as! PlanCollectionViewCell
        
        cell.myTitleLabel.text = machineOrShop
        cell.myNumberLabel.text = "\(projectArray[indexPath.row].editNo)則編輯頁面 + \(projectArray[indexPath.row].pushTime)個推播"
        cell.myPriceLabel.text = "NT$\(projectArray[indexPath.row].moneyPerMonth)/月  定期定額扣款"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var isStore = false
        if let controller = storyboard?.instantiateViewController(withIdentifier: "webView") as? WebViewController{
            if machineOrShop == "店家" {
                isStore = true
            }
            controller.isStore = isStore
            controller.userId = userData[0].userId
            controller.price = String(projectArray[indexPath.row].moneyPerMonth)
            controller.level = String(projectArray[indexPath.row].level)
            controller.pushTime = String(projectArray[indexPath.row].pushTime)
            controller.objectId = String(tempId)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false, completion: nil)
        }
        }
    func getProject() {
        var isStore = true
            let url = URL(string: "https://www.surveyx.tw/funchip/pay_project.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
        if machineOrShop == "機台" {
            isStore = false
        }
            let json: [String: Any] = [
                "isStore": "\(isStore)"
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    // succceeded
                    
                    // Call the parse json function on the data
                    self.parseProjectJson(data: data!)
                    
                } else {
                    //Error occurred
                }
            }
        task.resume()
}
    func parseProjectJson(data: Data) {
        
        // Parse the data into struct
        do {
            // Parse the data into a jsonObject
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            for jsonResult in jsonArray {
                // json result as a dictionary
                let jsonDict = jsonResult as! [String:Any]
                let level = jsonDict["level"]! as! String
                let editNo = jsonDict["editNo"]! as! String
                let pushTime = jsonDict["pushTime"]! as! String
                let moneyPerMonth = jsonDict["moneyPerMonth"]! as! String
                
                // Create new Machine and set its properties
                let project = Project(level: level, editNo: editNo, pushTime: pushTime, moneyPerMonth: moneyPerMonth)
                //Add it to the array
                projectArray.append(project)
            }
            DispatchQueue.main.async {
                print("num: \(self.projectArray.count)")
                self.myCollectionView.reloadData()
            }
        }
        catch {
            print("There was an error")
        }
    }
            
func queryFromCoreData() {
    let moc = CoreDataHelper.shared.managedObjectContext()
    
    let fetchRequest = NSFetchRequest<UserInformationClass>(entityName: "UserInformationClass")
    
    moc.performAndWait {
        do{
            self.userData = try moc.fetch(fetchRequest)//查詢，回傳為[Note]
        }catch{
            print("error \(error)")
            self.userData = []//如果有錯，回傳空陣列
        }
    }
}
   
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
