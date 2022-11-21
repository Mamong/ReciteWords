//
//  PXRefreshFooter.swift
//  ReciteWords
//
//  Created by marco on 2022/3/1.
//

import UIKit

class PXRefreshFooter:PXRefreshView {
    
    /** 创建footer */
    convenience init(refreshingBlock block:@escaping ()->()) {
        self.init()
        refreshingBlock = block
    }
    
    /** 忽略多少scrollView的contentInset的bottom */
    var ignoredScrollViewContentInsetBottom:CGFloat = 0
    
    //MARK:覆盖父类的方法
    override func prepare()
    {
        super.prepare()
        // 设置高度
        height = PXRefreshFooterHeight
    }

    /** 提示没有更多的数据 */
    func endRefreshingWithNoMoreData(){
        DispatchQueue.main.async {
            self.state = .noMoreData
        }
    }

    /** 重置没有更多的数据（消除没有更多数据的状态） */
    func resetNoMoreData()
    {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
}
