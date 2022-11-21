//
//  WordListViewController.swift
//  ReciteWords
//
//  Created by mac on 2022/1/6.
//

import UIKit
import SQLite


class WordListViewController: UIViewController {
    @IBOutlet weak var modeBtn:UIButton!
    @IBOutlet var listBtns: [UIButton]!

    @IBOutlet weak var tableView:UITableView!
    //var list = [WordModel(word: "inhale",en: "[ɪnˈheɪl]",us: "[ɪnˈheɪl]",trans: "v.吸入; 吸气;",num: 1),WordModel(word: "exhale",en: "[eksˈheɪl]",us: "[eksˈheɪl]",trans: "v.呼出，吐出(肺中的空气、烟等); 呼气;",num: 2)]
    var list:[WordModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords()
    }
    
    /*
    {"err_sim_words":{"err_words":"","sim_words":""},
     "is_CRI":1,
     "word_means":["车站","所，局","身份","电视台","配置，安置","驻扎"],
     "exchange":{"word_done":["stationed"],"word_est":"","word_pl":["stations"],"word_third":["stations"],"word_er":"","word_ing":["stationing"],"word_past":["stationed"]},
     "word_name":"station",
     "items":[""],
     "symbols":[{"ph_other":"","parts":[{"means":["车站","所，局","身份","电视台"],"part":"n."},{"means":["配置，安置","驻扎"],"part":"vt."}],"ph_am_mp3":"/1/0/e8/ed/e8ed3f2846110837f3adb8015ccad5ec.mp3","ph_am":"ˈsteʃən","ph_tts_mp3":"/e/8/e/e8ed3f2846110837f3adb8015ccad5ec.mp3","ph_en":"ˈsteɪʃn","ph_en_mp3":"/oxford/0/c5/4b/c54be968e023c52fdd3b6f2ffe1e049b.mp3"}],
     "tags":{"core":["高考","考研"],
     "other":["TEM4"]},
     "dict_from":"金山词霸"}
    */
    func loadWords() {
        let TABLE_TBL = "dict_tbl"
        let TABLE_TBL_KEY = Expression<String>("QUERY_KEY")
        let TABLE_TBL_FANYI = Expression<String>("FANYI")
        let TABLE_TBL_DICT = Expression<String>("DICT_JSON")
        
        let folder = PathConfig.pathForVocabularyDBFolder()
        let path = PathConfig.fullPath(for: "10001.db", in: folder)
        
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
                    transArr.append("\(part["part"]!)\(means.joined(separator: ";"))")
                }
                list.append(WordModel(word: item[TABLE_TBL_KEY],en: "英[\(symbol["ph_en"]!)]",us: "美[\(symbol["ph_am"]!)]",trans: transArr.joined(separator: "；"),num: num+1))
            } catch {
                print("loadWords error")
            }
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDictionary" {
            let dest = segue.destination as! UINavigationController
            dest.view.backgroundColor = UIColor.white

            let dictVC = dest.topViewController as! DictionaryViewController
            dictVC.word = (sender as! WordModel).word
        }
    }
    
    @IBAction func unwindToWordList(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func handleTapSettings(sender:UIBarButtonItem){
        let setting = SettingsViewController.init(rootFile: "learn")
        let vc = UINavigationController.init(rootViewController: setting)
        vc.preferredContentSize = CGSize.init(width: 280, height: 360)
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.barButtonItem = sender
        vc.popoverPresentationController?.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleTapMode(sender:UIButton){
        let vc = SettingsViewController.init(rootFile: "learn-mode")
        vc.preferredContentSize = CGSize.init(width: 160, height: 132)
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.permittedArrowDirections = .down
        vc.popoverPresentationController?.sourceView = sender
        vc.popoverPresentationController?.delegate = self
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension WordListViewController: SettingsViewControllerDelegate{
    
}

extension WordListViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension WordListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell-v", for: indexPath) as! WordListCell
        cell.model = list[row]
        cell.delegate = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
}

extension WordListViewController:WordListCellDelegate {
    func cellTapTrans(word: WordModel) {
        performSegue(withIdentifier: "ShowDictionary", sender: word)
    }
    
    func cellTapWord(word: WordModel) {
        //let referVC = UIReferenceLibraryViewController.init(term: word.word)
        //present(referVC, animated: true, completion: nil)
        performSegue(withIdentifier: "ShowDictate", sender: word)
    }
}

protocol WordListCellDelegate: NSObject {
    func cellTapWord(word:WordModel)
    func cellTapTrans(word:WordModel)
}

class WordListCell: UITableViewCell{
    @IBOutlet weak var numLabel:UILabel!
    @IBOutlet weak var wordLabel:UILabel!
    @IBOutlet weak var enBtn:UIButton!
    @IBOutlet weak var usBtn:UIButton!
    @IBOutlet weak var transLabel:UILabel!
    weak var delegate: WordListCellDelegate?
    
    var tapGestureWord:UITapGestureRecognizer!
    var tapGestureTrans:UITapGestureRecognizer!

    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestureWord = UITapGestureRecognizer.init(target: self, action: #selector(tapWordLabel))
        wordLabel.addGestureRecognizer(tapGestureWord)
        
        tapGestureTrans = UITapGestureRecognizer.init(target: self, action: #selector(tapTransLabel))
        transLabel.addGestureRecognizer(tapGestureTrans)
    }
    
    var model:WordModel!{
        didSet{
            numLabel.text = "\(model.num)"
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
