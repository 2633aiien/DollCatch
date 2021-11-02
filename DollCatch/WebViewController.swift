//
//  NewShopViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import WebKit
import JavaScriptCore

class WebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    func PaymentFinished(_ amount: Substring, _ status: Substring, _ isStore: Substring, _ objectId: Substring) {
        if status == "true" {
            if objectId == "" {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "editMineShop") as? EditMineShopViewController {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false, completion: nil)
            }
            } else {
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "beginTabbar") as? UITabBarController {
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false, completion: nil)
                }
            }
        } else {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "choosePlan") as? ChoosePlanViewController {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false, completion: nil)
            }
        }
    }
    
    
    @IBOutlet weak var myWebView: WKWebView!
    var isStore = true
    var userId = ""
    var price = ""
    var level = ""
    var pushTime = ""
    var objectId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Enable JavaScript
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        myWebView.configuration.defaultWebpagePreferences = preferences
    
        //設定 Interface 名稱
//        let configuration = WKWebViewConfiguration()
        myWebView.configuration.userContentController = WKUserContentController()
        myWebView.configuration.userContentController.add(self, name: "payWebInterface")
        myWebView.navigationDelegate = self

        
        print("price, level: \(price),\(level),\(pushTime)")
        var request = URLRequest(url: URL(string: "https://www.surveyx.tw/funchip/pay/funClipPay.php")!)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "isStore=\(isStore)&userId=\(userId)&price=\(price)&level=\(level)&pushTime=\(pushTime)&objectId=\(objectId)"
        request.httpBody = postString.data(using: .utf8)
        myWebView.load(request) //if your `webView` is `UIWebView`
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let messageString = "\(message.body)"
        var result = messageString.split(separator: ",")
        if result.count != 4 {
            result.append("null")
        }
        let amount = result[0]
        let status = result[1]
        let isStore = result[2]
        let objectId = result[3]
        PaymentFinished(amount, status, isStore, objectId)
        
        }
    
//    func post() {
//        let url = URL(string: "https://www.surveyx.tw/funchip/pay/funClipPay.php")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        var json: [String: Any] = [:]
//
//        json = [
//                "isStore": "\(isStore)",
//                "userId": "\(userId)",
//                "price": "\(price)",
//                "level": "\(level)",
//                "pushTime": "\(pushTime)"
//            ]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//        }
//        task.resume()
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
