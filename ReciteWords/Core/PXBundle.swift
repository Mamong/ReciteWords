//
//  PXBundle.swift
//  ReciteWords
//
//  Created by marco on 2022/3/3.
//

import UIKit

class PXBundle{
    var bundleName:String{
        return "Core"
    }
    
    var useMainBundle = false
    
    var externalBundle:Bundle?
    var mainBundle:Bundle = Bundle.main
    var builtinBundle:Bundle?

    private var externalLangBundle:Bundle?
    private var mainLangBundle:Bundle?
    private var builtinLangBundle:Bundle?

    
    init() {
        builtinBundle = Bundle.init(for: type(of: self))
        if let path = mainBundle.path(forResource: bundleName, ofType: "bundle"){
            externalBundle = Bundle.init(path: path)
        }
    }
    
    var languageCode:String = "zh-Hans"{
        didSet{
            if let externalBundle = externalBundle, let path = externalBundle.path(forResource: languageCode, ofType: "lproj"){
                externalLangBundle = Bundle.init(path: path)
            }
            
            if useMainBundle, let path = mainBundle.path(forResource: languageCode, ofType: "lproj"){
                mainLangBundle = Bundle.init(path: path)
            }
            
            if let builtinBundle = builtinBundle, let path = builtinBundle.path(forResource: languageCode, ofType: "lproj"){
                builtinLangBundle = Bundle.init(path: path)
            }
        }
    }
    
    func image(named:String) ->UIImage? {
        var image:UIImage? = nil
        if let externalBundle = externalBundle  {
            image = UIImage.init(named: named, in: externalBundle, compatibleWith: nil)
        }
        
        if useMainBundle, image == nil {
            image = UIImage.init(named: named, in: mainBundle, compatibleWith: nil)
        }
        
        if image == nil, let builtinBundle = builtinBundle {
            image = UIImage.init(named: named, in: builtinBundle, compatibleWith: nil)
        }
        return image
    }
    
    func image(contentsOfFile name: String) ->UIImage? {
        return image(contentsOfFile: name, ext: "png")
    }
    
    func image(contentsOfFile name: String, ext:String) ->UIImage? {
        var image:UIImage?
        if let externalBundle = externalBundle, let path = externalBundle.path(forResource: name, ofType: ext)  {
            image = UIImage.init(contentsOfFile: path)
        }
        
        if useMainBundle, image == nil, let path = mainBundle.path(forResource: name, ofType: ext)  {
            image = UIImage.init(contentsOfFile: path)
        }
        
        if image == nil, let builtinBundle = builtinBundle, let path = builtinBundle.path(forResource: name, ofType: ext)  {
            image = UIImage.init(contentsOfFile: path)
        }
        return image
    }
    
    func localizedString(forKey key: String,
                   value: String?) ->String{
        var trans = ""
        if let externalLangBundle = externalLangBundle  {
            trans = externalLangBundle.localizedString(forKey: key, value: nil, table: nil)
        }
        
        if useMainBundle, trans == "", let mainLangBundle = mainLangBundle {
            trans = mainLangBundle.localizedString(forKey: key, value: nil, table: nil)
        }
        
        if trans == "", let builtinLangBundle = builtinLangBundle {
            trans = builtinLangBundle.localizedString(forKey: key, value: nil, table: nil)
        }
        return trans != "" ? trans : (value ?? "")
    }
    
    func localizedString(forKey key: String) ->String{
        return localizedString(forKey: key, value: nil)
    }
}
