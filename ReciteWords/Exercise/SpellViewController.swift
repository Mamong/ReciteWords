//
//  SpellViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/1/16.
//

import UIKit

class SpellViewController: UIViewController {
    
    @IBOutlet weak var wordLabel:UILabel!
    @IBOutlet weak var transLabel:UILabel!
    @IBOutlet weak var soundmarkBtn:UIButton!
    @IBOutlet weak var inputField:UITextField!
    @IBOutlet weak var forgetBtn:UIButton!
    @IBOutlet weak var knownBtn:UIButton!
    
    var list:[WordModel] = []
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleTapSettings(sender:UIBarButtonItem){
        let vc = SettingsViewController.init(rootFile: "dictate")
        vc.preferredContentSize = CGSize.init(width: 240, height: 200)
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.barButtonItem = sender
        vc.popoverPresentationController?.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleTapForgetBtn(sender:UIButton){
        let tag = sender.tag
        if tag == 0 {
            soundmarkBtn.isHidden = false
            //朗读单词
            sender.tag = 1
        }else if tag == 1 {
            sender.tag = 2
            //学习该单词
            //wordLabel.isHidden = false
            
            //如果开启自动切词
//            let t = DispatchTime.now() + 2000
//            let curIdx = currentIndex
//            DispatchQueue.main.asyncAfter(deadline: t) {[weak self] in
//                if curIdx == self?.currentIndex {
//                    self?.showNextWord()
//                }
//            }
        }
    }
    
    @IBAction func handleTapKnownBtn(sender:UIButton){
        //记录
        showNextWord()
    }
    
    func showNextWord(){
        guard currentIndex < list.count-1 else {
            return
        }
        wordLabel.isHidden = true
        soundmarkBtn.isHidden = true
        inputField.text = ""
        forgetBtn.tag = 0
        
        currentIndex += 1
        let nextWord = list[currentIndex]
        transLabel.text = ""
        wordLabel.text = ""
        soundmarkBtn.setTitle("", for: .normal)
    }
    
    func valuateResult(){
        let curWord = list[currentIndex]
        let curInput = inputField.text
        if curWord.word == curInput {
            //播放正确音效
            playSoundEffect()
            showNextWord()
        }else{
            //播放失败音效
            playSoundEffect()
            showNextWord()
        }
    }
    
    func playSoundEffect(){
        
    }
}

extension SpellViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SpellViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
