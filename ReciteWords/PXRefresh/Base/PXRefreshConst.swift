//
//  PXRefreshConst.swift
//  ReciteWords
//
//  Created by marco on 2022/3/1.
//

import UIKit

let PXRefreshLabelLeftInset:CGFloat = 25.0
let PXRefreshHeaderHeight:CGFloat = 54.0
let PXRefreshFooterHeight:CGFloat = 44.0
let PXRefreshTrailWidth:CGFloat = 60.0
let PXRefreshFastAnimationDuration:CGFloat = 0.25
let PXRefreshSlowAnimationDuration:CGFloat = 0.4


let PXRefreshKeyPathContentOffset = "contentOffset"
let PXRefreshKeyPathContentInset = "contentInset"
let PXRefreshKeyPathContentSize = "contentSize"
let PXRefreshKeyPathPanState = "state"

let PXRefreshHeaderLastUpdatedTimeKey = "PXRefreshHeaderLastUpdatedTimeKey"

let PXRefreshHeaderIdleText = "PXRefreshHeaderIdleText"
let PXRefreshHeaderPullingText = "PXRefreshHeaderPullingText"
let PXRefreshHeaderRefreshingText = "PXRefreshHeaderRefreshingText"

let PXRefreshTrailerIdleText = "PXRefreshTrailerIdleText"
let PXRefreshTrailerPullingText = "PXRefreshTrailerPullingText"

let PXRefreshAutoFooterIdleText = "PXRefreshAutoFooterIdleText"
let PXRefreshAutoFooterRefreshingText = "PXRefreshAutoFooterRefreshingText"
let PXRefreshAutoFooterNoMoreDataText = "PXRefreshAutoFooterNoMoreDataText"

let PXRefreshBackFooterIdleText = "PXRefreshBackFooterIdleText"
let PXRefreshBackFooterPullingText = "PXRefreshBackFooterPullingText"
let PXRefreshBackFooterRefreshingText = "PXRefreshBackFooterRefreshingText"
let PXRefreshBackFooterNoMoreDataText = "PXRefreshBackFooterNoMoreDataText"

let PXRefreshHeaderLastTimeText = "PXRefreshHeaderLastTimeText"
let PXRefreshHeaderDateTodayText = "PXRefreshHeaderDateTodayText"
let PXRefreshHeaderNoneLastDateText = "PXRefreshHeaderNoneLastDateText"

let PXRefreshDidChangeLanguageNotification = "PXRefreshDidChangeLanguageNotification"


// RGB颜色
func PXRefreshColor(_ r:Int, _ g:Int, _ b:Int) -> UIColor {
    return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}

// 文字颜色
let PXRefreshLabelTextColor = PXRefreshColor(90, 90, 90)

// 字体大小
let PXRefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)
