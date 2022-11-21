//
//  BaseTableViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/3/3.
//

import UIKit

class BaseTableViewController: BaseViewController {
    typealias ItemType = AnyClass
    var list: [AnyClass] = []
    
    var loadingType: LoadingType = .kInit
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        addRefreshAndLoadMore()
        //customPullToRefreshView()
        //customInfiniteScrollingView()
        //addBackToTopButton()
        //addNavigationBar()
    }

    func addTableView(){
        
    }
    
    func registerCells(){
        
    }

//    func showNoMoreDataNotice(){
//
//    }
//
//    func hideNoMoreDataNotice(){
//
//    }
    
    func addRefreshAndLoadMore() {
        tableView.refreshHeader = PXRefreshHeader.init(refreshingBlock: { [weak self] in
            self?.doRefresh()
        })
        tableView.refreshFooter = PXRefreshFooter.init(refreshingBlock: { [weak self] in
            self?.doLoadMore()
        })
    }

    
}

extension BaseTableViewController:BaseScrollViewController{
    func reloadData(){
        tableView.reloadData()
    }
    
    func startRefresh() {
        tableView.refreshHeader?.beginRefreshing()
    }

    func finishRefresh() {
        tableView.refreshHeader?.endRefreshing()
    }

    func finishLoadMore() {
        tableView.refreshFooter?.endRefreshing()
    }
}
