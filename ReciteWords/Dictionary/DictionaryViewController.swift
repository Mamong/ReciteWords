//
//  DictionaryViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/1/14.
//

import UIKit

class DictionaryViewController: PagerViewController {
    var word: String!
    var dictionaries:[[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDictionaries()
        
        var vcs:[UIViewController] = []
        var titles:[String] = []
        for dict in dictionaries {
            if let title = dict["name"],
               var urlString = dict["url"] {
                if let sIndex = urlString.firstIndex(of: "@"){
                    let eIndex = urlString.index(sIndex, offsetBy: 1)
                    let range = sIndex..<eIndex
                    urlString.replaceSubrange(range, with: word)
                    if let url = URL.init(string: urlString){
                        let vc = WebViewController.init(url: url)
                        vcs.append(vc)
                        titles.append(title)
                    }
                }else if urlString == "reference" {
                    let refer = UIReferenceLibraryViewController.init(term: word)
                    //let navigationBar = refer.view.findViews(subclassOf: UINavigationBar.self).first
                    //navigationBar!.items?.first?.rightBarButtonItem = nil

                    print("\(refer.children)")
                    vcs.append(refer)
                    titles.append(title)
                }
            }
        }
        setViewControllers(vcs, titles: titles)
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

        do{
            let dicts = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String : Any]
            dictionaries = dicts["online"] as! [[String:String]]
        }catch{
            print("error loadDictionaries")
        }
    }
}

extension UIView {
    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }

    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }
}
