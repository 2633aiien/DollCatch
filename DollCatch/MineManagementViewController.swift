//
//  ManagementViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/16.
//

import UIKit
import SideMenu

class mineCell {
    var image : UIImage!
    var name : String!
}

class MineManagementViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var mineCollectionView: UICollectionView!
    @IBOutlet weak var backgroundView: UIView!
    var mineCellArr : [mineCell] = []
    let menu = SideMenuNavigationController(rootViewController: RootViewController())
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineCollectionViewCell", for: indexPath) as! MineCollectionViewCell
        
        cell.myImageView.image = mineCellArr[indexPath.row].image
        cell.myTitleLabel.text = mineCellArr[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var id = ""
        switch indexPath.row {
        
        case 0:
            id = "mineShopMachine"
        case 1:
            id = "mineShopMachine"
        case 2:
            id = "notifiHistory"
        case 3:
            id = "unfinish"
            print("我要投廣告尚未開放")
        case 4:
            id = "payRecord"
        case 5:
            id = "unfinish"
            print("聯絡客服尚未開放")
        default:
            break
        }

        if let controller = storyboard?.instantiateViewController(withIdentifier: id) {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        iconBtn.layer.cornerRadius = 0.5 * iconBtn.bounds.size.width
//        iconBtn.clipsToBounds = true
//        backgroundView.roundCorners(corners: [.topLeft, .topRight], radius: 50)
        backgroundView.layer.cornerRadius = 50
        

        // sidebar
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        SideMenuManager.default.leftMenuNavigationController = menu
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (w-45-16)/2, height: 120)
        
        mineCollectionView.collectionViewLayout = layout
        
        mineCollectionView.register(
            MineCollectionViewCell.self,
            forCellWithReuseIdentifier: "MineCollectionViewCell")
        mineCollectionView.delegate = self
        mineCollectionView.dataSource = self
        
        var mine1 = mineCell()
        self.mineCellArr.append(mine1)
        mine1.image = UIImage(named: "13")
        mine1.name = "我的店家"
        var mine2 = mineCell()
        self.mineCellArr.append(mine2)
        mine2.image = UIImage(named: "joystick-1")
        mine2.name = "我的機台"
        var mine3 = mineCell()
        self.mineCellArr.append(mine3)
        mine3.image = UIImage(named: "23")
        mine3.name = "推播歷史"
        var mine4 = mineCell()
        self.mineCellArr.append(mine4)
        mine4.image = UIImage(named: "21")
        mine4.name = "我要投廣告"
        var mine5 = mineCell()
        self.mineCellArr.append(mine5)
        mine5.image = UIImage(named: "22")
        mine5.name = "付費紀錄"
        var mine6 = mineCell()
        self.mineCellArr.append(mine6)
        mine6.image = UIImage(named: "14")
        mine6.name = "聯絡客服"
        
        
    }
    @IBAction func hamburgerBtn(_ sender: Any) {
        menu.leftSide = true
        menu.settings.presentationStyle = .menuSlideIn
        menu.menuWidth = 330
        present(menu, animated: true, completion: nil)
    }
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()

            // Call the roundCorners() func right there.
//            backgroundView.roundCorners(corners: [.topLeft, .topRight], radius: 50)

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
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
