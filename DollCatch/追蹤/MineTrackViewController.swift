//
//  MineTrackViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import SideMenu
import CoreData

class MineTrackViewController: UIViewController {
    @IBOutlet var containerViews: [UIView]!
    
    let menu = SideMenuNavigationController(rootViewController: RootViewController())
    var userData : [UserInformationClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        queryFromCoreData()
        
        // sidebar
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        SideMenuManager.default.leftMenuNavigationController = menu
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if userData .isEmpty {
            let controller = storyboard?.instantiateViewController(withIdentifier: "login")
            let navigationController = UINavigationController(rootViewController: controller!)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    @IBAction func hamburgerBtn(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "rootView")
        let menu = SideMenuNavigationController(rootViewController: viewController!)
        menu.leftSide = true
        menu.settings.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
        containerViews.forEach {
               $0.isHidden = true
            }
            containerViews[sender.selectedSegmentIndex].isHidden = false
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


