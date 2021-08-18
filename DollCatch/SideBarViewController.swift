//
//  SideBarViewController.swift
//  DollCatch
//
//  Created by allen on 2021/8/17.
//

import UIKit

class SideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableview = UITableView()
            var names =  ["公告","Q&A","隱私權協議","聯絡我們"]
            
            let width = UIScreen.main.bounds.size.width
            let height = UIScreen.main.bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 170/255, blue: 0/255, alpha: 1.0)
        
        tableview = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.backgroundColor = .clear
        tableview.separatorStyle = .none
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        tableview.indicatorStyle = .white
        tableview.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableview)

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
              if cell == nil {
                  cell = UITableViewCell(style: .default,
                                         reuseIdentifier: "cell")
              }
        cell?.textLabel?.text = "\(names[indexPath.row])"
        cell?.textLabel?.textColor = .black
        cell?.backgroundColor = .clear

              return cell!
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
