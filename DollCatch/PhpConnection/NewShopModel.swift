//
//  NewShopModel.swift
//  DollCatch
//
//  Created by allen on 2021/9/1.
//

import UIKit

protocol NewShopModelDelegate {
    func itemsDownloaded(shops:[newShop])
}

class NewShopModel: NSObject {
    
    var delegate: NewShopModelDelegate?

    func getNewShopItems() {
        // web service Url
        let serviceUrl = "https://www.surveyx.tw/funchip/new_store.php"
        // json data
        let url = URL(string: serviceUrl)
        
        if let url = url {
            // create a Url session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    // succceeded
                    
                    // Call the parse json function on the data
                    self.parseNewShopJson(data: data!)
                    
                } else {
                    //Error occurred
                }
            }
            // start the task
            task.resume()
        }
    }
    func parseNewShopJson(data: Data) {
        
        var shopArray = [newShop]()
        
        // Parse the data into struct
        do {
            // Parse the data into a jsonObject
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            for jsonResult in jsonArray {
                // json result as a dictionary
                let jsonDict = jsonResult as! [String:Any]
                let isStore : Bool = jsonDict["isStore"] as! Bool
                let id : String = jsonDict["id"] as! String
                let userId : String = jsonDict["userId"] as! String
                let title : String = jsonDict["title"] as? String ?? "null"
                let description : String = jsonDict["description"] as? String ?? "null"
                let address_shop : String = jsonDict["address_store"] as? String ?? "null"
                let big_machine_no : Int = jsonDict["big_machine_no"] as? Int ?? 0
                let machine_no : Int = jsonDict["machine_no"] as? Int ?? 0
                let manager : String = jsonDict["manager"] as? String ?? "null"
                let air_condition : Bool = jsonDict["air_condition"] as? Bool ?? false
                let fan : Bool = jsonDict["fan"] as? Bool ?? false
                let wifi : Bool = jsonDict["wifi"] as? Bool ?? false
                let phone_no : String = jsonDict["photo_no"] as? String ?? "null"
                let line_id : String = jsonDict["line_id"] as? String ?? "null"
                let activity_id : Int = jsonDict["activity_id"] as? Int ?? 0
                let remaining_push : Int = jsonDict["remaining_push"] as? Int ?? 0
                let announceDate : String = jsonDict["announceDate"] as? String ?? "null"
                let clickTime : Int = jsonDict["clickTime"] as? Int ?? 0
                let latitude : Double = jsonDict["latitude"] as? Double ?? 0
                let longitude : Double = jsonDict["longitude"] as? Double ?? 0
                let createDate : String = jsonDict["createDate"] as! String
                let updateDate : String = jsonDict["updateDate"] as! String
                
                // Create new Machine and set its properties
                let shop = newShop(isStore: isStore, id: id, userId: userId, title: title, description: description, address_shop: address_shop, big_machine_no: big_machine_no, machine_no: machine_no, manager: manager, air_condition: air_condition, fan: fan, wifi: wifi, phone_no: phone_no, line_id: line_id,activity_id: activity_id, remaining_push: remaining_push, announceDate: announceDate, clickTime: clickTime, latitude: latitude, longitude: longitude, createDate: createDate, updateDate: updateDate)
                //Add it to the array
                shopArray.append(shop)
            }
            // Pass the array back to delegate
            delegate?.itemsDownloaded(shops: shopArray)
        }
        catch {
            print("There was an error")
        }
    }
}
