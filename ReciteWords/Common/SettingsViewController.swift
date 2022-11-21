//
//  SettingsViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/1/17.
//

import UIKit

protocol SettingsViewControllerDelegate:UIViewController {
    
}

class SettingsViewController: UITableViewController {
        
    var node: [String:Any]!
    weak var delegate:SettingsViewControllerDelegate?
    
    init(node:[String:Any]) {
        super.init(nibName: nil, bundle: nil)
        self.node = node
        self.title = self.node["title"] as? String
    }
    
    init(rootFile:String) {
        super.init(nibName: nil, bundle: nil)
        self.node = loadSettings(rootFile: rootFile)
        self.title = self.node["title"] as? String
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell-1")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell-2")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell-3")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell-4")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell-5")

    }
    
    func loadSettings(rootFile:String) -> [String:Any]? {
        let path = Bundle.main.path(forResource: rootFile, ofType: "json")
        guard path != nil else {
            return nil
        }
        
        let url = URL.init(fileURLWithPath: path!)
        let jsonData = try? Data.init(contentsOf: url)
        guard jsonData != nil else {
            return nil
        }
        
        do {
            return try JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String : Any]
        } catch {
            print(error)
            return nil
        }
    }
}

extension SettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let sections = node["children"] as! [[String:Any]]
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = node["children"] as! [[String:Any]]
        let rows = sections[section]["children"] as! [[String:Any]]
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sections = node["children"] as! [[String:Any]]
        return sections[section]["header"] as? String
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sections = node["children"] as! [[String:Any]]
        return sections[section]["footer"] as? String
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let sections = node["children"] as! [[String:Any]]
        let rows = sections[section]["children"] as! [[String:Any]]
        let model = rows[row]
        let type = model["type"] as! Int

        let cellId = "cell-\(type)"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = model["title"] as? String
        
        //1plain,2option,3segment,4switch，5stepper,6input
        switch type {
        case 1:
            cell.detailTextLabel?.text = model["detail"] as? String
            if let _ = model["hasMore"] {
                cell.accessoryType = .disclosureIndicator
            }else{
                cell.accessoryType = .none
            }
        case 2:
            cell.accessoryType = .checkmark
        case 3:
            let options = model["options"] as! [[String:Any]]
            let values = options.map { op -> String in
                op["name"] as! String
            }
            let seg = UISegmentedControl.init(items: values)
            seg.selectedSegmentIndex = 0
            cell.accessoryView = seg
        case 4:
            let sw = UISwitch.init()
            sw.isOn = false
            cell.accessoryView = sw
        case 5:
            let sp = UIStepper.init()
            sp.minimumValue = model["minValue"] as! Double
            sp.maximumValue = model["maxValue"] as! Double
            sp.stepValue = model["stepValue"] as! Double
            cell.accessoryView = sp
        default:
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        let section = indexPath.section
        let row = indexPath.row
        
        let sections = node["children"] as! [[String:Any]]
        let rows = sections[section]["children"] as! [[String:Any]]
        let model = rows[row]
        //let type = model["type"] as! Int
        if model.keys.contains("child") {
            let child = model["child"] as! [String:Any]
            let setting = SettingsViewController.init(node: child)
            navigationController?.pushViewController(setting, animated: true)
        }else if model.keys.contains("link"){
            dismiss(animated: true, completion: nil)
            let segue = model["link"] as! String
            delegate?.performSegue(withIdentifier: segue, sender: nil)
        }
    }
}


//class SettingsViewController: UITableViewController {
//
//    var node: SettingModel!
//
//    init(node:SettingModel) {
//        super.init(nibName: nil, bundle: nil)
//        self.node = node
//        self.title = self.node.title
//    }
//
//    init(rootFile:String) {
//        super.init(nibName: nil, bundle: nil)
//        self.node = loadSettings(rootFile: rootFile)
//        self.title = self.node.title
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell-id")
//    }
//
//    func loadSettings(rootFile:String) -> SettingModel? {
//        let path = Bundle.main.path(forResource: rootFile, ofType: "json")
//        guard path != nil else {
//            return nil
//        }
//
//        let url = URL.init(fileURLWithPath: path!)
//        let jsonData = try? Data.init(contentsOf: url)
//        guard jsonData != nil else {
//            return nil
//        }
//
//        let decoder = JSONDecoder()
//        return try! decoder.decode(SettingModel.self, from: jsonData!)
//    }
//}
//
//extension SettingsViewController {
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
