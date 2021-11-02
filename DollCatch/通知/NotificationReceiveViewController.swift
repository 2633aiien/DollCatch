//
//  NotificationReceiveViewController.swift
//  DollCatch
//
//  Created by allen on 2021/10/19.
//

import UIKit
import CoreData

class NotificationReceiveViewController: UIViewController {
    @IBOutlet var containerViews: [UIView]!
    var userData : [UserInformationClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        queryFromCoreData()
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
    @IBAction func changeView(_ sender: UISegmentedControl) {
        containerViews.forEach {
               $0.isHidden = true
            }
        containerViews[sender.selectedSegmentIndex].isHidden = false
    }
    @IBAction func backBtnPressed(_ sender: Any) {
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
