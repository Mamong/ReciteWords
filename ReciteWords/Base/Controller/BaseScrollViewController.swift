//
//  BaseScrollViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/3/3.
//

import Foundation

enum LoadingType {
    case kInit
    case kRefresh
    case kLoadMore
}

protocol BaseScrollViewController:NSObject {
    associatedtype ItemType
    var loadingType:LoadingType { get set }
    var list:[ItemType] { get set }

    func startRefresh()

    func finishRefresh()

    func finishLoadMore()
    
    func reloadData()

    func loadData()
}

extension BaseScrollViewController{
    func doRefresh()
    {
        loadingType = .kRefresh
        loadData()
    }

    func doLoadMore()
    {
        loadingType = .kLoadMore
        loadData()
    }
    
    func initData() {
        loadingType = .kInit
        list = []
        loadData()
    }

    func loadData() {
        
    }
    
    func endRefresh() {
        if loadingType == .kRefresh {
            finishRefresh()
        }else if loadingType == .kLoadMore {
            finishLoadMore()
        }
    }
}
