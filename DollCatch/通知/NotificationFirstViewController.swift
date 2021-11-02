//
//  NotificationFirstViewController.swift
//  DollCatch
//
//  Created by allen on 2021/10/19.
//

import UIKit
import CoreData

class NotificationFirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var firstTableView: UITableView!
    var userData : [UserInformationClass] = []
    var notificationArr : [FollowShopMachine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        queryFromCoreData()
        firstTableView.delegate = self
        firstTableView.dataSource = self
        getNotification()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationTableViewCell
        cell.setUI(title: notificationArr[indexPath.row].title, describe: notificationArr[indexPath.row].description, address: "\(notificationArr[indexPath.row].address_city)\(notificationArr[indexPath.row].address_area)\(notificationArr[indexPath.row].address_name)", manager: notificationArr[indexPath.row].manager, date: notificationArr[indexPath.row].updateDate)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newF = notificationArr[indexPath.row]
        getNoti(id: newF.id)
        if let controller = storyboard?.instantiateViewController(withIdentifier: "machineIntro") as? MachineIntroViewController{
            controller.tempIsFollow = newF.isFollow
            controller.tempIsStore = newF.isStore
            controller.tempTitle = newF.title
            controller.tempId = newF.id
            controller.tempUserId = newF.userId
            controller.tempAddress_city = newF.address_city
            controller.tempAddress_area = newF.address_area
            controller.tempAddress_name = newF.address_name
            controller.tempDescription = newF.description
            controller.tempManager = newF.manager
            controller.tempLine = newF.line_id
            controller.tempPhone = newF.phone_no
            controller.tempBig_machine_no = newF.big_machine_no
            controller.tempMachine_no = newF.machine_no
            controller.tempAir_condition = newF.air_condition
            controller.tempFan = newF.fan
            controller.tempWifi = newF.wifi
            controller.tempStoreName = newF.store_name
            controller.tempLatitude = Double(newF.latitude) ?? 0
            controller.tempLongitude = Double(newF.longitude) ?? 0
            
            
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
    }
    }
    
    
    func getNotification() {
        let url = URL(string: "https://www.surveyx.tw/funchip/get_notify_store.php")!
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
                            let isStore : Bool = jsonDict["isStore"] as! Bool
                            let id : String = jsonDict["id"] as! String
                            let userId : String = jsonDict["userId"] as! String
                            let title : String = jsonDict["title"] as? String ?? "null"
                            let description : String = jsonDict["description"] as? String ?? "null"
                            let address_city : String = jsonDict["address_city"] as? String ?? "null"
                            let address_area : String = jsonDict["address_area"] as? String ?? "null"
                            let address_name : String = jsonDict["address_name"] as? String ?? "null"
                            let store_name : String = jsonDict["store_name"] as? String ?? "null"
                            let big_machine_no : String = jsonDict["big_machine_no"] as? String ?? "null"
                            let machine_no : String = jsonDict["machine_no"] as? String ?? "null"
                            let manager : String = jsonDict["manager"] as? String ?? "null"
                            let air_condition : Bool = jsonDict["air_condition"] as? Bool ?? false
                            let fan : Bool = jsonDict["fan"] as? Bool ?? false
                            let wifi : Bool = jsonDict["wifi"] as? Bool ?? false
                            let phone_no : String = jsonDict["phone_no"] as? String ?? "null"
                            let line_id : String = jsonDict["line_id"] as? String ?? "null"
                            let activity_id : Int = jsonDict["activity_id"] as? Int ?? 0
                            let remaining_push : String = jsonDict["remaining_push"] as? String ?? "null"
                            let announceDate : String = jsonDict["announceDate"] as? String ?? "null"
                            let clickTime : Int = jsonDict["clickTime"] as? Int ?? 0
                            let latitude : String = jsonDict["latitude"] as? String ?? "0"
                            let longitude : String = jsonDict["longitude"] as? String ?? "0"
                            let createDate : String = jsonDict["createDate"] as? String ?? "null"
                            let updateDate : String = jsonDict["updateDate"] as? String ?? "null"
                            
                            // Create new Machine and set its properties
                            let noti = FollowShopMachine(isFollow: true, isStore: isStore, id: id, userId: userId, title: title, description: description, address_city: address_city, address_area: address_area, address_name: address_name, store_name: store_name, big_machine_no: big_machine_no, machine_no: machine_no, manager: manager, air_condition: air_condition, fan: fan, wifi: wifi, phone_no: phone_no, line_id: line_id, activity_id: activity_id, remaining_push: remaining_push, announceDate: announceDate, clickTime: clickTime, latitude: latitude, longitude: longitude, createDate: createDate, updateDate: updateDate)
                            //Add it to the array
                            self.notificationArr.append(noti)
                        }
                        DispatchQueue.main.async {
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
    
    func getNoti(id: String) {
            let url = URL(string: "https://www.surveyx.tw/funchip/reset_notify_store.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let json: [String: Any] = [
                "userId": "\(userData[0].userId)",
                "id": id
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
            }
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
