//
//  ScheduleViewController.swift
//  ReciteWords
//
//  Created by mac on 2022/1/6.
//

import UIKit


class ScheduleViewController: UITableViewController{
    @IBOutlet var headerView:UIView!
    //var list:[[(group:Int,index:Int)]] = []
    var list:[[Int?]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSchedule()
    }
    
    func loadSchedule() {
        //1,2,3,5,8,16
        let intervals = [0,1,2,4,7,15]
        let gCount = 30
        list = ebbinghaus2(gCount: gCount, intervals: intervals, limit: 0)
        tableView.reloadData()
//        let layout = UICollectionViewFlowLayout.init()
//        layout.itemSize = CGSize(width: 50,height: 44)
//        layout.minimumInteritemSpacing = 1
//        layout.minimumLineSpacing = 1
//        collectionView.setCollectionViewLayout(layout, animated: false)
//        collectionView.reloadData()
    }
    
    func ebbinghaus2(gCount:Int,intervals:[Int],limit:Int = 0) -> [[Int?]]{
        let rows = gCount + intervals.last!
        var ebList:[[Int?]] = Array.init(repeating: [], count: rows)
        for row in 0..<rows {
            for interval in intervals {
                let index = row + 1 - interval
                if index >= 1 && index <= gCount{
                    ebList[row].append(index)
                }else{
                    ebList[row].append(nil)
                }
            }
        }
        return ebList
    }
    
    func ebbinghaus(gCount:Int,intervals:[Int],limit:Int = 0) -> [[(group:Int,index:Int)]]{

        let intvalCount = intervals.count
        var gIndex = 1
        var isFinished = false
        var ebList:[[(group:Int,index:Int)?]] = []
        repeat {
            var dayList:[(group:Int,index:Int)?] = []
            for intvalIndex in 0..<intvalCount {
                let interval = intervals[intvalIndex]
                let length = ebList.count
                if length < interval{
                    break
                }
                let firstList = ebList[length-interval]
                if firstList.count == 0{
                    continue
                }
                let last = firstList[0]
                if last == nil{
                    continue
                }
                let (g,index) = last!
                if index == 0{
                    dayList.append((g,intvalIndex+1))
                    if (g == gCount) && (1+intvalIndex == intvalCount){
                        isFinished = true
                    }
                }
            }
            
            //是否要学习新知识
            if gIndex <= gCount{
                if limit <= 0 || dayList.count <= limit{
                    dayList.insert((gIndex,0),at: 0)
                    //dayList.append((gIndex,1))
                    gIndex += 1
                }else{
                    dayList.insert(nil, at: 0)
                    //dayList.append(nil)
                }
            }else{
                dayList.insert(nil, at: 0)
            }
            
            ebList.append(dayList)
        }while(!isFinished)
        //美化打印
        var ebList2:[[(group:Int,index:Int)]] = []
        for day in ebList{
            var ls:[(group:Int,index:Int)] = []
            for group in day{
                if let g = group {
                    ls.append(g)
                    //ls.append("L\(g.group)*\(g.index)")
                }else{
                    //ls.append("-")
                }
            }
            ebList2.append(ls)
        }
        print(ebList2)
        return ebList2
    }
}

extension ScheduleViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let section = indexPath.section
        let row = indexPath.row
        let model = list[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ScheduleListCell
        cell.titleLabel.text = "\(row+1)D"
        cell.model = model
        cell.isSelected = row == 1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
    }
}

class ScheduleListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var listLabels: [UILabel]!
    
    var model:[Int?]!{
        //var model:[(group:Int,index:Int)]!{
        didSet{
            for label in listLabels {
                label.text = "-"
            }
            for (index,group) in model.enumerated() {
                if let group = group {
                    listLabels[index].text = "L\(group)"
                }
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let alpha = CGFloat(highlighted ? 0.8:1)
        let color = UIColor.init(red: 151/256.0, green: 255/256.0, blue: 236/256.0, alpha: alpha)
        for label in listLabels {
            label.backgroundColor = color
        }
        let color2 = UIColor.init(red: 81/256.0, green: 216/256.0, blue: 255/256.0, alpha: alpha)
        titleLabel.backgroundColor = color2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let alpha = CGFloat(selected ? 0.8:1)
        let color = UIColor.init(red: 151/256.0, green: 255/256.0, blue: 236/256.0, alpha: alpha)
        for label in listLabels {
            label.backgroundColor = color
        }
        let color2 = UIColor.init(red: 81/256.0, green: 216/256.0, blue: 255/256.0, alpha: alpha)
        titleLabel.backgroundColor = color2
    }
}

//extension ScheduleViewController{
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return list.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let day = list[section]
//        return day.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let section = indexPath.section
//        let item = indexPath.item
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ScheduleListCell
//        cell.titleLabel.text = list[section][item]
//        return cell
//    }
//
//
//}
//
//class ScheduleListCell: UICollectionViewCell {
//    @IBOutlet weak var titleLabel: UILabel!
//}
