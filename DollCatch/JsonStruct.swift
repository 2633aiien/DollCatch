//
//  Location.swift
//  DollCatch
//
//  Created by allen on 2021/8/26.
//

import Foundation
import CoreData
import UIKit

struct newMachine {
    var isFollow = false
    var isStore = true
    var id = ""
    var userId = ""
    var title = ""
    var description = ""
    var address_machine = ""
    var store_name = ""
    var manager = ""
    var phone_no = ""
    var line_id = ""
    var activity_id = 0
    var remaining_push = 0
    var announceDate = ""
    var clickTime = 0
    var latitude = 0.1
    var longitude = 0.1
    var createDate = ""
    var updateDate = ""
}
struct newShop {
    var isFollow = false
    var isStore = false
    var id = ""
    var userId = ""
    var title = ""
    var description = ""
    var address_shop = ""
    var big_machine_no = ""
    var machine_no = ""
    var manager = ""
    var air_condition = true
    var fan = true
    var wifi = true
    var phone_no = ""
    var line_id = ""
    var activity_id = 0
    var remaining_push = 0
    var announceDate = ""
    var clickTime = 0
    var latitude = 0.1
    var longitude = 0.1
    var createDate = ""
    var updateDate = ""
}
struct FollowShopMachine {
    var isFollow = false
    var isStore = false
    var id = ""
    var userId = ""
    var title = ""
    var description = ""
    var address = ""
    var store_name = ""
    var big_machine_no = ""
    var machine_no = ""
    var manager = ""
    var air_condition = true
    var fan = true
    var wifi = true
    var phone_no = ""
    var line_id = ""
    var activity_id = 0
    var remaining_push = 0
    var announceDate = ""
    var clickTime = 0
    var latitude = "0.1"
    var longitude = "0.1"
    var createDate = ""
    var updateDate = ""
}

struct UserInformationStruct {
    var phone: String
    var result: Bool
    var userId: String
    var name: String
    var nickname: String
    var email: String
    var level: String
    var photo_position: Bool
}
struct AdStruct {
    var position: String
    var adUrl: String
}
class AreaClass: Decodable {
    public var CityName : String?
    public var CityEngName : String?
    public var AreaList : Array<AreaList>?
}
class AreaList: Decodable {
    public var ZipCode : String?
    public var AreaName : String?
    public var AreaEngName : String?
}

class UserInformationClass : NSManagedObject{
    @NSManaged var phone: String
    @NSManaged var result: Bool
    @NSManaged var userId: String
    @NSManaged var name: String
    @NSManaged var nickname: String
    @NSManaged var email: String
    @NSManaged var level: String
    @NSManaged var photo_position: Bool
}
