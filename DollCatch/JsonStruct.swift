//
//  Location.swift
//  DollCatch
//
//  Created by allen on 2021/8/26.
//

import Foundation

struct MachineInformation {
    var id = ""
    var userId = ""
    var title = ""
    var description_machine = ""
    var address_machine = ""
    var store_name = ""
    var manager = ""
    var photo_no = ""
    var line_id = ""
}

struct GetMyMachine {
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
    var activity_id = ""
    var remaining_push = ""
    var announceDate = ""
    var clickTime = ""
    var latitude = ""
    var longitude = ""
    var createDate = ""
    var updateDate = ""
}
struct newMachine {
    var isStore = true
    var id = ""
    var userId = ""
    var title = ""
    var description = ""
    var address_machine = ""
    var machine_name = ""
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
    var isStore = false
    var id = ""
    var userId = ""
    var title = ""
    var description = ""
    var address_shop = ""
    var big_machine_no = 0
    var machine_no = 0
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