//
//  PXRefreshTrailer.swift
//  ReciteWords
//
//  Created by marco on 2022/3/1.
//

import UIKit

class PXRefreshTrailer:PXRefreshView {
    
    /** 忽略多少scrollView的contentInset的right */
    var ignoredScrollViewContentInsetRight:CGFloat = 0
    
    private var lastRefreshCount = 0
    private var lastRightDelta:CGFloat = 0
    
    /** 创建footer */
    convenience init(refreshingBlock block:@escaping ()->()) {
        self.init()
        refreshingBlock = block
    }
    
    //MARK:覆盖父类的方法
    override func placeSubviews()
    {
        super.placeSubviews()
        
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
        guard let scrollView = scrollView else { return }
        height = scrollView.height
        width = PXRefreshTrailWidth
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let scrollView = scrollView else { return }
        if newSuperview != nil {
            // 设置支持水平弹簧效果
            scrollView.alwaysBounceHorizontal = true
            scrollView.alwaysBounceVertical = false
        }
    }

    override func scrollViewContentOffsetDidChange(change:[NSKeyValueChangeKey : Any]) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        // 如果正在刷新，直接返回
        if state == .refreshing { return }
        
        guard let scrollView = scrollView else { return }
        //scrollViewOriginalInset = scrollView.inset;
        
        // 当前的contentOffset
        let currentOffsetX = scrollView.offsetX
        // 尾部控件刚好出现的offsetX
        let happenOffsetX = self.happenOffsetX()
        // 如果是向右滚动到看不见右边控件，直接返回
        if currentOffsetX <= happenOffsetX { return }
        
        let pullingPercent = (currentOffsetX - happenOffsetX) / width
        
        // 如果已全部加载，仅设置pullingPercent，然后返回
        if state == .noMoreData {
            self.pullingPercent = pullingPercent
            return
        }
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            // 普通 和 即将刷新 的临界点
            let normal2pullingOffsetX = happenOffsetX + width
            
            if state == .idle && currentOffsetX > normal2pullingOffsetX {
                self.state = .pulling
            } else if state == .pulling && currentOffsetX <= normal2pullingOffsetX {
                // 转为普通状态
                state = .idle
            }
        } else if state == .pulling {// 即将刷新 && 手松开
            // 开始刷新
            beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }

    override var state:PXRefreshState{
        didSet{
            guard state != oldValue else { return }
            super.state = state
            
            guard let scrollView = scrollView else { return }
            if state == .noMoreData || state == .idle {
                // 刷新完毕
                if .refreshing == oldValue {
                    UIView.animate(withDuration: slowAnimationDuration) {
//                        if self.endRefreshingAnimationBeginAction {
//                            self.endRefreshingAnimationBeginAction()
//                        }
                        self.scrollView?.insetR -= self.lastRightDelta
                        // 自动调整透明度
                        if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
                    } completion: { finished in
                        self.pullingPercent = 0.0;
                        if let endRefreshingBlock = self.endRefreshingBlock {
                            endRefreshingBlock()
                        }
                    }
                }
                
//                let deltaW = widthForContentBreakView()
//                // 刚刷新完毕
//                if .refreshing == oldValue && deltaW > 0 && scrollView.totalDataCount != lastRefreshCount {
//                    scrollView.offsetX = scrollView.offsetX
//                }
            } else if state == .refreshing {
                // 记录刷新前的数量
                lastRefreshCount = scrollView.totalDataCount
                
                UIView.animate(withDuration: fastAnimationDuration) {
                    var right = self.width + self.scrollViewOriginalInset.right
                    let deltaW = self.widthForContentBreakView()
                    if deltaW < 0 { // 如果内容宽度小于view的宽度
                        right -= deltaW
                    }
                    self.lastRightDelta = right - scrollView.insetR
                    scrollView.insetR = right
                    
                    // 设置滚动位置
                    var offset = scrollView.contentOffset
                    offset.x = self.happenOffsetX() + self.width;
                    scrollView.setContentOffset(offset, animated: false)
                } completion: { finished in
                    self.executeRefreshingCallback()
                }
            }
        }
    }


    override func scrollViewContentSizeDidChange(change:[NSKeyValueChangeKey : Any]) {
        super.scrollViewContentSizeDidChange(change:change)
        
        guard let scrollView = scrollView else { return }
        // 内容的宽度
        let contentWidth = scrollView.contentW + ignoredScrollViewContentInsetRight
        // 表格的宽度
        let scrollWidth = scrollView.width - scrollViewOriginalInset.left - scrollViewOriginalInset.right + ignoredScrollViewContentInsetRight
        // 设置位置和尺寸
        left = max(contentWidth, scrollWidth)
    }
    
    //MARK:刚好看到上拉刷新控件时的contentOffset.x
    func happenOffsetX() -> CGFloat {
        let deltaW = widthForContentBreakView()
        if deltaW > 0 {
            return deltaW - scrollViewOriginalInset.left
        } else {
            return -scrollViewOriginalInset.left
        }
    }

    //MARK:获得scrollView的内容 超出 view 的宽度
    func widthForContentBreakView() -> CGFloat {
        guard let scrollView = scrollView else { return 0.0}

        let w = scrollView.width - scrollViewOriginalInset.right - scrollViewOriginalInset.left
        return scrollView.contentW - w
    }
}
