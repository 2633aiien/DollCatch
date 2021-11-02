//
//  NotiHistorySecondViewController.swift
//  DollCatch
//
//  Created by allen on 2021/10/18.
//

import UIKit
import CoreData

class NotiHistorySecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var secondTableView: UITableView!
    var userData : [UserInformationClass] = []
    var notiArr : [NotifyHistory] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        queryFromCoreData()
        secondTableView.delegate = self
        secondTableView.dataSource = self
        getNotifyHistory()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DetailTableViewCell
        let firstLine = notiArr[indexPath.row].history.firstIndex(of: "\n")
        let lastWord = notiArr[indexPath.row].history.lastIndex(of: "\n")
        let firstLineDate = notiArr[indexPath.row].history[...firstLine!]
        let secondLineDate = notiArr[indexPath.row].history[firstLine!...lastWord!]
        cell.setUI(title: notiArr[indexPath.row].title, date: String(firstLineDate), dates: String(secondLineDate))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.secondTableView.performBatchUpdates(nil)
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.secondTableView.cellForRow(at: indexPath) as? DetailTableViewCell {
            cell.hideDetailView()
        }
    }
    
    func getNotifyHistory() {
        let url = URL(string: "https://www.surveyx.tw/funchip/push_history_machine.php")!
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
                            let history : String = jsonDict["history"] as? String ?? "null"
                            
                            // Create new Machine and set its properties
                            let noti = NotifyHistory(title: title, history: history)
                            
                            //Add it to the array
                            self.notiArr.append(noti)
                        }
                        DispatchQueue.main.async {
                            self.secondTableView.reloadData()
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
