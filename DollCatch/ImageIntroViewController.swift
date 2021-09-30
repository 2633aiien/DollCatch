//
//  ImageIntroViewController.swift
//  DollCatch
//
//  Created by allen on 2021/9/23.
//

import UIKit

class ImageIntroViewController: UIViewController {
    @IBOutlet weak var myimageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var describeTextView: UITextView!
    var index = 0
    var tempIsStore = true
    var tempId = ""
    var tempUserId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getActivity()

        downloadImage(from: URL(string: "https://www.surveyx.tw/funchip/images/userId_\(tempUserId)/machine_photo_\(tempId)_\(index+1)")! , imageView: myimageView)
        
    }
    
    func getActivity() {
        let url = URL(string: "https://www.surveyx.tw/funchip/get_activity.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var json: [String: Any] = [:]
        if tempIsStore == true {
            json = [
                "storeId":"\(tempId)"
            ]
        } else {
        json = [
            "machineId":"\(tempId)"
        ]
    }
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                DispatchQueue.main.async {
                    self.nameTextView.text = responseJSON["photo_name\(self.index+1)"]! as? String ?? ""
                    self.describeTextView.text = responseJSON["photo_describe\(self.index+1)"] as? String ?? ""
                }
                
            }
        }
        task.resume()
    }
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                if UIImage(data: data) != nil {
                imageView.image = UIImage(data: data)
                } else {
                    imageView.image = UIImage(named: "withoutImage")
                }
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @IBAction func backBtn(_ sender: Any) {
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
