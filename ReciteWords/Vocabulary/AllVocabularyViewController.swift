//
//  AllVocabularyViewController.swift
//  ReciteWords
//
//  Created by mac on 2022/1/5.
//

import UIKit
import SQLite

class AllVocabularyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "vocabularyId"
    var list: [BookModel] = []
    var mappingKeys: [MappingKeyModel] = []
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }()
    var downloadTask:URLSessionDownloadTask?
    
    override func viewDidLoad() {
        loadVocabularyList()
        //let color = UINavigationBar.appearance().barTintColor
        //print(color?.description)
    }
    
    func loadVocabularyList() {
        let path = Bundle.main.path(forResource: "appconfig", ofType: "json")
        guard path != nil else {
            return
        }
        
        let url = URL.init(fileURLWithPath: path!)
        //let jsonString = try? String.init(contentsOf: url)
        let jsonData = try? Data.init(contentsOf: url)
        //let jsonData = jsonString?.data(using: .utf8)
        guard jsonData != nil else {
            return
        }
        
        let obj = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
        let data = obj["data"] as! [String:Any]
        let books = data["books"] as! [[String:Any]]
        var string = ""
        for book in books {
            let data1 = try! JSONSerialization.data(withJSONObject: book, options: .fragmentsAllowed)
            guard let str = String.init(data: data1, encoding: .utf8) else { return }
            string += str + "\n"
        }
        let folder = PathConfig.pathForVocabularyDBFolder()
        let path2 = PathConfig.fullPath(for: "books.json", in: folder)
        try? string.write(toFile: path2, atomically: true, encoding: .utf8)
        
        
        let decoder = JSONDecoder()
        let res = try! decoder.decode(VocabularyResModel.self, from: jsonData!)
        list = res.data.books
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! VocabularyWordsViewController
        let word = sender as! BookModel
        vc.vocabularyId = "\(word.id)"
        vc.title = word.name
    }
}

extension AllVocabularyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! VocabularyCell
        cell.model = list[row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


protocol VocabularyCellDelegate: AnyObject {
    func cell(_ cell :VocabularyCell, didTap view: UIView)
}



extension AllVocabularyViewController: VocabularyCellDelegate {
    
    
    func cell(_ cell: VocabularyCell, didTap view: UIView) {
        let TABLE_TBL = "dict_tbl"
        let TABLE_TBL_KEY = Expression<String>("QUERY_KEY")
        let TABLE_TBL_DICT = Expression<String>("DICT_JSON")

        var model = cell.model!
        if view == cell.viewBtn {
            performSegue(withIdentifier: "ShowVocabulary", sender: model)
            return
        }
        if let url = URL.init(string: model.url) {
            cell.downloadBtn.isEnabled = false
            downloadTask = session.downloadTask(with: url) { (location, res, err) in
                cell.downloadBtn.isHidden = err == nil
                if err == nil, let loc = location{

                    model.status = 1
                    
                    let folder = PathConfig.pathForVocabularyDBFolder()
                    let path = PathConfig.fullPath(for: "\(model.id).db", in: folder)
                    
                    self.saveVocabularyDB(at: loc.path, to: path)
                    
                   
                    let db = try! Connection(path)
                    let words = Table(TABLE_TBL)
                    var str = ""
                    var list = ""
                    for item in try! db.prepare(words.order(TABLE_TBL_KEY)) {
                        let json = item[TABLE_TBL_DICT].data(using: .utf8)
                        let dict = try! JSONSerialization.jsonObject(with: json!, options: []) as! Dictionary<String, Any>
                        let word_name = dict["word_name"] as! String
                        
                        str = str + word_name + "\n"
                        list = list + item[TABLE_TBL_DICT] + "\n"
                    }
                    let path1 = PathConfig.fullPath(for: "\(model.id).txt", in: folder)
                    let path2 = PathConfig.fullPath(for: "\(model.id).json", in: folder)
                    print("download vocabulary \(model.id) success,save txt:\(path1)")
                    try? str.write(toFile: path1, atomically: true, encoding: .utf8)
                    try? list.write(toFile: path2, atomically: true, encoding: .utf8)
                }
            }
            downloadTask?.resume()
        }
    }
    
    func saveVocabularyDB(at atPath: String, to toPath: String){
        let folder = URL(string: toPath)?.deletingLastPathComponent().absoluteString
        if let folder = folder, !FileManager.default.fileExists(atPath: folder) {
            do {
                try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print(error)
            }
        }
        if FileManager.default.fileExists(atPath: toPath) {
            try? FileManager.default.removeItem(atPath: toPath)
        }
        try? FileManager.default.moveItem(atPath: atPath, toPath: toPath)
    }
}



class VocabularyCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var viewBtn: UIButton!

    
    weak var delegate: VocabularyCellDelegate?
    
    var model: BookModel?
    {
        didSet{
            if let model = model {
                titleLabel.text = "\(model.name)(\(model.wordCount))"
                downloadBtn.isHidden = model.status != -1
            }
        }
    }
    
    @IBAction func tapDownloadButton(_ sender: UIView) {
        delegate?.cell(self, didTap: sender)
    }
    
    @IBAction func tapViewButton(_ sender: UIView) {
        delegate?.cell(self, didTap: sender)
    }
}

