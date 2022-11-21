//
//  File.swift
//  ReciteWords
//
//  Created by mac on 2021/10/15.
//

import Foundation

enum AppDirectory {
    case home
    case document
    case cache
    case library
    case tmp
    
    func path() -> String {
        switch self {
        case .home:
            return NSHomeDirectory()
        case .document:
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String
        case .cache:
            return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as String
        case .library:
            return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last! as String
        case .tmp:
            return NSTemporaryDirectory()
        }
    }
}


class PathUtil {
    
    /// Home目录
    static let homePath = NSHomeDirectory()

    /// 文档目录 NSHomeDirectory() + "/Documents"
    /// FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.absoluteURL
    static let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String
    
    /// 缓存目录 NSHomeDirectory() + "/Library/Caches"
    static let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as String

    /// 库目录 NSHomeDirectory() + "/Library"
    static let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last! as String

    /// 临时目录 NSHomeDirectory() + "/tmp"
    static let tempPath = NSTemporaryDirectory()
}


