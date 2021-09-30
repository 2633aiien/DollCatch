//
//  LocalJson.swift
//  DollCatch
//
//  Created by allen on 2021/9/22.
//

import Foundation

func readLocalJSONFile(forName name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        }
    } catch {
        print("error: \(error)")
    }
    return nil
}


/// Parse the jsonData using the JSONDecoder with help of sampleRecord model
/// - Parameter jsonData: jsonData object
func parse(jsonData: Data) -> [AreaClass]? {
    do {
        let decodedData = try JSONDecoder().decode([AreaClass].self, from: jsonData)
        return decodedData
    } catch {
        print("error: \(error)")
    }
    return []
}
