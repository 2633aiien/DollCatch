//
//  ViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import SideMenu

class HomePageViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    let menu = SideMenuNavigationController(rootViewController: RootViewController())
    
   
    override func viewDidLoad() {
        super .viewDidLoad()
        
        
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        SideMenuManager.default.leftMenuNavigationController = menu

        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)

        // (Optional) Prevent status bar area from turning black when menu appears:
//        leftMenuNavigationController.statusBarEndAlpha = 0
    }
    
    @IBAction func hamburgerBtn(_ sender: Any) {
        menu.leftSide = true
        menu.settings.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        present(menu, animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
    }
    
}

//page...
extension HomePageViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let page = scrollView.contentOffset.x / scrollView.bounds.width
            pageControl.currentPage = Int(page)
    }
}

