//
//  VideoViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/25.
//

import UIKit
import WebKit
import SideMenu

class VideoViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    let menu = SideMenuNavigationController(rootViewController: RootViewController())
    let urlString = "https://www.surveyx.tw/funchip/my_video.php"
    
    

    @IBOutlet weak var myWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // sidebar
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        SideMenuManager.default.leftMenuNavigationController = menu
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        myWebView.uiDelegate = self
        myWebView.navigationDelegate = self
        let url = URL(string:urlString)
        let urlRequest = URLRequest(url: url!)
        myWebView.load(urlRequest)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func hamburgerBtn(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "rootView")
        let menu = SideMenuNavigationController(rootViewController: viewController!)
        menu.leftSide = true
        menu.settings.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        present(menu, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if !navigationAction.targetFrame!.isMainFrame {
            webView.load(navigationAction.request)
        }
        return nil
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
