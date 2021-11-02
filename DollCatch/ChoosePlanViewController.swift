//
//  ChoosePlanViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import CoreData

class ChoosePlanViewController: UIViewController {
    @IBOutlet weak var machineBtn: UIButton!
    @IBOutlet weak var shopBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    
    var userData : [UserInformationClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        queryFromCoreData()
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
    @IBAction func machineBtnPressed(_ sender: Any) {
        if machineBtn.tag == 1 {
            machineBtn.tag = 2
            machineBtn.backgroundColor = .orange
            machineBtn.borderColor = .white
            
            shopBtn.tag = 1
            shopBtn.backgroundColor = .white
            shopBtn.borderColor = .orange
        } else {
            machineBtn.tag = 1
            machineBtn.backgroundColor = .white
            machineBtn.borderColor = .orange
        }
    }
    @IBAction func shopBtnPressed(_ sender: Any) {
        if shopBtn.tag == 1 {
            shopBtn.tag = 2
            shopBtn.backgroundColor = .orange
            shopBtn.borderColor = .white
            
            machineBtn.tag = 1
            machineBtn.backgroundColor = .white
            machineBtn.borderColor = .orange
            
        } else {
            shopBtn.tag = 1
            shopBtn.backgroundColor = .white
            shopBtn.borderColor = .orange
        }
    }
    @IBAction func checkBtnPressed(_ sender: Any) {
        if checkBtn.tag == 1{
            checkBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            checkBtn.tag = 2
        } else {
            checkBtn.setImage(UIImage(systemName: "square"), for: .normal)
            checkBtn.tag = 1
        }
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "beginTabbar") as? UITabBarController {
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
    @IBAction func termBtnPressed(_ sender: Any) {
        let urlString = "http://www.surveyx.tw/funchip/agreement.html"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
        if checkBtn.tag == 1 {
            let controller = UIAlertController(title: "必須勾選付費條款", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else if machineBtn.tag == 1 && shopBtn.tag == 1 {
            let controller = UIAlertController(title: "必須選擇一個付費方案", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "planViewController") as? MachinePlanViewController {
                if machineBtn.tag == 1 {
                    controller.machineOrShop = "店家"
                } else {
                    controller.machineOrShop = "機台"
                }
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false, completion: nil)
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
