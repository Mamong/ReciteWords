//
//  DictateViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/1/16.
//

import UIKit

class DictateViewController: UIViewController {
    
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
        let setting = SettingsViewController.init(rootFile: "dictate")
        let vc = UINavigationController.init(rootViewController: setting)
        vc.preferredContentSize = CGSize.init(width: 280, height: 320)
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.barButtonItem = sender
        vc.popoverPresentationController?.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func handleTapForgetBtn(sender:UIButton){
        if sender.isSelected {
            showNextWord(success: false)
        } else {
            showHint()
        }
    }
    
    @IBAction func handleTapKnownBtn(sender:UIButton){
        showNextWord(success: true)
    }
    
    @IBAction func handleTapView(gesture:UITapGestureRecognizer){
        //如果是无键盘模式
        let noInput = false
        if noInput {
            showHint()
        }
    }
    
    func showNextWord(success:Bool){
        guard currentIndex < list.count-1 else {
            return
        }
        
        //记录
        
        
        wordLabel.isHidden = true
        soundmarkBtn.isHidden = true
        inputField.text = ""
        forgetBtn.isSelected = false
        
        currentIndex += 1
        let nextWord = list[currentIndex]
        transLabel.text = ""
        wordLabel.text = ""
        soundmarkBtn.setTitle("", for: .normal)
        

    }
    
    func valuateResult(){
        let curWord = list[currentIndex]
        let curInput = inputField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        if curWord.word == curInput {
            //播放正确音效
            playSoundEffect()
            showNextWord(success: true)
        }else{
            //播放失败音效
            playSoundEffect()
            showHint()
        }
    }
    
    
    func showHint(){
        forgetBtn.isSelected = true
        wordLabel.isHidden = false
        soundmarkBtn.isHidden = false
        transLabel.isHidden = false
    }
    
    func playSoundEffect(){
        
    }
    
    func beginDictate(){
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func endDictate(){
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

extension DictateViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension DictateViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
