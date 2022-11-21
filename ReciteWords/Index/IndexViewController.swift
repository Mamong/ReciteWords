//
//  IndexViewController.swift
//  ReciteWords
//
//  Created by mac on 2021/9/20.
//

import UIKit

class IndexViewController: UITableViewController {
        
    var list = ["","词库","日程安排","计划设置","我的词库"]
    
    override func viewDidLoad() {
        
        //let color = UINavigationBar.appearance().barTintColor
        //print(color?.description)
    }
    
    
}

extension IndexViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cellId = "cell-\(row)"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = list[row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
