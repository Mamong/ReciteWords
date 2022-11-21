//
//  DictConfigViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/1/14.
//

import UIKit

class DictConfigViewController: UITableViewController {
    var dicts:[String:Any] = ["online":[],"offline":[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let editBtn = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
//        navigationItem.rightBarButtonItem = editBtn
        editButtonTapped()
        loadDictionaries()
    }
    
    func loadDictionaries() {
        let path = Bundle.main.path(forResource: "dictionaries", ofType: "json")
        guard path != nil else {
            return
        }
        
        let url = URL.init(fileURLWithPath: path!)
        let jsonData = try? Data.init(contentsOf: url)
        guard jsonData != nil else {
            return
        }
        
        //let decoder = JSONDecoder()
        //list = try! decoder.decode([SettingItem].self, from: jsonData!)
        do{
            dicts = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String : Any]
        }catch{
            
        }
        tableView.reloadData()
    }
    
    @objc func editButtonTapped(){
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing {
            let doneBtn = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(editButtonTapped))
            navigationItem.rightBarButtonItem = doneBtn
        }else{
            let editBtn = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
            navigationItem.rightBarButtonItem = editBtn
            //保存
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var key = "online"
        if section == 1 {
            return 1
        }else if section == 2{
            key = "offline"
        }
        return (dicts[key] as! [[String:String]]).count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var key = "启用的字典"
        if section == 1 {
            key = ""
        }else if section == 2{
            key = "禁用的字典"
        }
        return key
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell-dict", for: indexPath)
        if section == 1 {
            cell.textLabel?.text = "添加字典"
        }else{
            var key = "online"
            if section == 2 {
                key = "offline"
            }
            let list = dicts[key] as! [[String:String]]
            cell.textLabel?.text = list[row]["name"]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        let section = indexPath.section
//        if section == 1 {
//            return false
//        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let section = indexPath.section
        //let row = indexPath.row
        if section == 0 {
            return "Disable"
        }
        return "Delete"
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let section = indexPath.section
        //let row = indexPath.row
        if section == 1 {
            return .insert
        }
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        if section == 1 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let section = proposedDestinationIndexPath.section
        if section == 1 {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
}
