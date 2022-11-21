//
//  MineViewController.swift
//  ReciteWords
//
//  Created by mac on 2021/9/20.
//

import UIKit


class MineViewController: UITableViewController {
    
//    var node: SettingModel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadSettings()
//    }
//
//    func loadSettings() {
//        let path = Bundle.main.path(forResource: "mine", ofType: "json")
//        guard path != nil else {
//            return
//        }
//
//        let url = URL.init(fileURLWithPath: path!)
//        let jsonData = try? Data.init(contentsOf: url)
//        guard jsonData != nil else {
//            return
//        }
//
//        let decoder = JSONDecoder()
//        do {
//            self.node = try decoder.decode(SettingModel.self, from: jsonData!)
//            self.title = self.node.title
//        } catch  {
//            print(error)
//        }
//        tableView.reloadData()
//    }
//
//    @objc func cellTapSegment(){
//
//    }
}

//extension MineViewController {
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return node.children.count
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return node.children[section].children.count
//    }
//    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return node.children[section].header
//    }
//    
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return node.children[section].footer
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let section = indexPath.section
//        let row = indexPath.row
//        let model = node.children[section].children[row]
//        
//        let cellId = "cell-id"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
//        cell.textLabel?.text = model.title
//        
//        
//        //1plain,2option,3segment,4switch，5stepper,6input
//        switch model.type {
//        case 1:
//            let item = model as! SettingPlain
//            cell.detailTextLabel?.text = item.detail
//            if item.showMore {
//                cell.accessoryType = .disclosureIndicator
//            }else{
//                cell.accessoryType = .none
//            }
//        case 2:
//            cell.accessoryType = .checkmark
//            cell.detailTextLabel?.text = nil
//        case 3:
//            let item = model as! SettingSegment
//            let seg = UISegmentedControl.init(items: item.options)
//            seg.selectedSegmentIndex = item.value
//            cell.accessoryView = seg
//            cell.detailTextLabel?.text = nil
//        case 4:
//            let item = model as! SettingSwitch
//            let sw = UISwitch.init()
//            sw.isOn = item.value
//            cell.accessoryView = sw
//            cell.detailTextLabel?.text = nil
//        default:
//            cell.detailTextLabel?.text = nil
//        }
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt")
//    }
//    
//}
