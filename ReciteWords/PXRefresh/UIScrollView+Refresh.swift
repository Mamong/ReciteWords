//
//  UIScrollView+Refresh.swift
//  ReciteWords
//
//  Created by marco on 2022/2/26.
//

import UIKit

extension UIScrollView {
    
    struct AssociatedObject {
        static var headerKey:UInt8 = 0
        static var footerKey:UInt8 = 1
        static var trailerKey:UInt8 = 2
    }

    var refreshHeader:PXRefreshHeader?{
        get{
            return objc_getAssociatedObject(self, &AssociatedObject.headerKey) as? PXRefreshHeader
        }
        
        set{
            if newValue != refreshHeader {
                refreshHeader?.removeFromSuperview()
                if let newValue = newValue {
                    insertSubview(newValue, at: 0)
                }
                objc_setAssociatedObject(self, &AssociatedObject.headerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    var refreshFooter:PXRefreshFooter?{
        get{
            return objc_getAssociatedObject(self, &AssociatedObject.footerKey) as? PXRefreshFooter
        }
        
        set{
            if newValue != refreshFooter {
                refreshFooter?.removeFromSuperview()
                if let newValue = newValue {
                    insertSubview(newValue, at: 0)
                }
                objc_setAssociatedObject(self, &AssociatedObject.footerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    var refreshTrailer:PXRefreshTrailer?{
        get{
            return objc_getAssociatedObject(self, &AssociatedObject.trailerKey) as? PXRefreshTrailer
        }
        
        set{
            if newValue != refreshTrailer {
                refreshTrailer?.removeFromSuperview()
                if let newValue = newValue {
                    insertSubview(newValue, at: 0)
                }
                objc_setAssociatedObject(self, &AssociatedObject.trailerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    var showsPullToRefresh:Bool{
        get{
            return refreshHeader?.showRefresh ?? false
        }
        
        set{
            refreshHeader?.showRefresh = newValue
        }
    }
    
    var showsInfiniteScrolling:Bool{
        get{
            return refreshFooter?.showRefresh ?? false
        }
        
        set{
            refreshFooter?.showRefresh = newValue
        }
    }
    
    //MARK: - other
    var totalDataCount:Int
    {
        var totalCount = 0
        if isKind(of: UITableView.self) {
            let tableView = self as! UITableView

            for section in 0..<tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: section)
            }
        } else if isKind(of: UICollectionView.self) {
            let collectionView = self as! UICollectionView

            for section in 0..<collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
}
