//
//  LPLabel.swift
//  ReciteWords
//
//  Created by marco on 2022/1/21.
//

import UIKit


class LPLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressed))
        addGestureRecognizer(longPressGesture)
    }
    
    @objc func longPressed(){
        becomeFirstResponder()
        let menuVC = UIMenuController.shared
        let menus = [
        UIMenuItem.init(title: "Translate", action: #selector(translate(_:)))]
        menuVC.menuItems = menus
        menuVC.setTargetRect(frame, in: superview ?? self)
        menuVC.setMenuVisible(true, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        }else if action == #selector(translate(_:)) {
            return true
        }
        return false
    }
    
    @objc override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    
    @objc func translate(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
}
