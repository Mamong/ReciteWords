//
//  UIScrollView+Geometry.swift
//  ReciteWords
//
//  Created by marco on 2022/2/26.
//

import UIKit
/*
 * UIView Geometry
 */
extension UIScrollView {
    
    var inset: UIEdgeInsets {
        get{
            if #available(iOS 11.0, *) {
                return adjustedContentInset
            }else{
                return contentInset
            }
        }
    }
    
    var insetL: CGFloat {
        get{
            return inset.left
        }
        set{
            var inset = contentInset
            inset.left = newValue
            if #available(iOS 11.0, *) {
                inset.left -= (adjustedContentInset.left - contentInset.left)
            }
            contentInset = inset
        }
    }
    
    var insetR: CGFloat {
        get{
            return inset.right
        }
        set{
            var inset = contentInset
            inset.right = newValue
            if #available(iOS 11.0, *) {
                inset.right -= (adjustedContentInset.right - contentInset.right)
            }
            contentInset = inset
        }
    }
    
    var insetT: CGFloat {
        get{
            return inset.top
        }
        set{
            var inset = contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top -= (adjustedContentInset.top - contentInset.top)
            }
            contentInset = inset
        }
    }
    
    var insetB: CGFloat {
        get{
            return inset.bottom
        }
        set{
            var inset = contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom -= (adjustedContentInset.bottom - contentInset.bottom)
            }
            contentInset = inset
        }
    }
    
    var offsetX: CGFloat {
        get{
            return contentOffset.x
        }
        set{
            var offset = contentOffset
            offset.x = newValue
            contentOffset = offset
        }
    }
    
    var offsetY: CGFloat {
        get{
            return contentOffset.y
        }
        set{
            var offset = contentOffset
            offset.y = newValue
            contentOffset = offset
        }
    }
    
    var contentW: CGFloat {
        get{
            return contentSize.width
        }
        set{
            var newSize = contentSize
            newSize.width = newValue
            contentSize = newSize
        }
    }
    
    var contentH: CGFloat {
        get{
            return contentSize.height
        }
        set{
            var newSize = contentSize
            newSize.height = newValue
            contentSize = newSize
        }
    }
}
