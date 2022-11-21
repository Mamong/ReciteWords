//
//  BaseCollectionViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/3/3.
//

import UIKit

class BaseCollectionViewController: BaseViewController {
    
    typealias ItemType = AnyClass
    var list: [AnyClass] = []

    var loadingType: LoadingType = .kInit
    var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        addRefreshAndLoadMore()
        //customPullToRefreshView()
        //customInfiniteScrollingView()
        //addBackToTopButton()
        //addNavigationBar()
    }

    func addCollectionView(){
        
    }
    
    func registerCells(){
        
    }


    func addRefreshAndLoadMore() {
        collectionView.refreshHeader = PXRefreshHeader.init(refreshingBlock: { [weak self] in
            self?.doRefresh()
        })
        collectionView.refreshFooter = PXRefreshFooter.init(refreshingBlock: { [weak self] in
            self?.doLoadMore()
        })
    }

    
}

extension BaseCollectionViewController:BaseScrollViewController{
    func reloadData(){
        collectionView.reloadData()
    }
    
    func startRefresh() {
        collectionView.refreshHeader?.beginRefreshing()
    }

    func finishRefresh() {
        collectionView.refreshHeader?.endRefreshing()
    }

    func finishLoadMore() {
        collectionView.refreshFooter?.endRefreshing()
    }
}
