//
//  VocabularyWordsViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/2/25.
//

import UIKit
import SQLite

class VocabularyWordsViewController: UITableViewController{
    
    var vocabularyId:String! = ""
    var list:[WordModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords()
    }
    
    func loadWords() {
        let TABLE_TBL = "dict_tbl"
        let TABLE_TBL_KEY = Expression<String>("QUERY_KEY")
        let TABLE_TBL_FANYI = Expression<String>("FANYI")
        let TABLE_TBL_DICT = Expression<String>("DICT_JSON")
        
        let folder = PathConfig.pathForVocabularyDBFolder()
        let path = PathConfig.fullPath(for: "\(vocabularyId!).db", in: folder)
        
        let db = try! Connection(path)
        let words = Table(TABLE_TBL)
        
        for (num,item) in try! db.prepare(words.limit(50)).enumerated() {
            print("\(item[TABLE_TBL_KEY]):\(item[TABLE_TBL_FANYI]),\(item[TABLE_TBL_DICT])")
            let json = item[TABLE_TBL_DICT].data(using: .utf8)
            do {
                let dict = try JSONSerialization.jsonObject(with: json!, options: []) as! Dictionary<String, Any>
                let symbols = dict["symbols"] as! [Dictionary<String, Any>]
                let symbol = symbols[0]
                let parts = symbol["parts"] as! [Dictionary<String, Any>]
                var transArr:[String] = []
                for part in parts {
                    let means = part["means"] as! [String]
                    transArr.append("\(part["part"]!)\(means.joined(separator: "，"))")
                }
                list.append(WordModel(word: item[TABLE_TBL_KEY],en: "英[\(symbol["ph_en"]!)]",us: "美[\(symbol["ph_am"]!)]",trans: transArr.joined(separator: "；"),num: num+1))
            } catch {
                print("loadWords error")
            }
        }
        tableView.reloadData()
    }
}


extension VocabularyWordsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell-v", for: indexPath) as! VocabularyWordCell
        cell.model = list[row]
        //cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class VocabularyWordCell: UITableViewCell{
    @IBOutlet weak var wordLabel:UILabel!
    @IBOutlet weak var enBtn:UIButton!
    @IBOutlet weak var usBtn:UIButton!
    @IBOutlet weak var transLabel:UILabel!
    @IBOutlet weak var favBtn:UIButton!
    @IBOutlet weak var deleteBtn:UIButton!

    weak var delegate: WordListCellDelegate?

    
    var model:WordModel!{
        didSet{
            wordLabel.text = model.word
            enBtn.setTitle("\(model.en)", for: .normal)
            usBtn.setTitle("\(model.us)", for: .normal)
            transLabel.text = model.trans
        }
    }
    
    @objc func tapWordLabel(){
        delegate?.cellTapWord(word: model)
    }
    
    @objc func tapTransLabel(){
        delegate?.cellTapTrans(word: model)
    }
}
