//
//  PayRecordFirstViewController.swift
//  DollCatch
//
//  Created by allen on 2021/10/19.
//

import UIKit
import CoreData

class PayRecordFirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var firstTableView: UITableView!
    var userData : [UserInformationClass] = []
    var payArr : [PaymentHistory] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        queryFromCoreData()
        firstTableView.delegate = self
        firstTableView.dataSource = self
        getPayHistory()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PayTableViewCell
        cell.setUI(title: payArr[indexPath.row].title, money: payArr[indexPath.row].money, date: payArr[indexPath.row].date)
        return cell
    }
    
    
    func getPayHistory() {
        let url = URL(string: "https://www.surveyx.tw/funchip/pay_record_store.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = [
            "userId": "\(userData[0].userId)"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    do {
                        // Parse the data into a jsonObject
                    let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
                        for jsonResult in jsonArray {
                            // json result as a dictionary
                            let jsonDict = jsonResult as! [String:Any]
                            let title : String = jsonDict["title"] as? String ?? "null"
                            let money : String = jsonDict["money"] as? String ?? "null"
                            let createDate : String = jsonDict["createDate"] as? String ?? "null"
                            
                            // Create new Machine and set its properties
                            let pay = PaymentHistory(title: title, money: money, date: createDate)
                            
                            //Add it to the array
                            self.payArr.append(pay)
                        }
                        DispatchQueue.main.async {
                            print("count: \(self.payArr.count)")
                            self.firstTableView.reloadData()
                        }
                    }
                    catch {
                        print("There was an error")
                    }
                    
                } else {
                    print("error: \(error)")
                }
            }
            // start the task
            task.resume()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
