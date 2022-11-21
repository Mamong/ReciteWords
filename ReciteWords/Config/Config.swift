//
//  Config.swift
//  ReciteWords
//
//  Created by mac on 2021/10/28.
//

import Foundation


class PathConfig {
    
    static func pathForVocabularyDBFolder() -> String {
        return PathUtil.documentPath.appending("/vocabulary")
    }
    
    static func fullPath(for file:String, in folder:String) -> String {
        return folder.appending("/\(file)")
    }
}
