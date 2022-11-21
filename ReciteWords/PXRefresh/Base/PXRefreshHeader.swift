//
//  PXRefreshHeader.swift
//  ReciteWords
//
//  Created by marco on 2022/3/1.
//

import UIKit

let PXRefreshHeaderRefreshing2IdleBoundsKey = "PXRefreshHeaderRefreshing2IdleBoundsKey"
let PXRefreshHeaderRefreshingBoundsKey = "PXRefreshHeaderRefreshingBoundsKey"
let PXRefreshHeaderRefreshing2IdleOpacity = "PXRefreshHeaderRefreshing2IdleOpacity"

class PXRefreshHeader:PXRefreshView {
    
    /** 忽略多少scrollView的contentInset的top */
    var ignoredScrollViewContentInsetTop:CGFloat = 0{
        didSet{
            top = -height - ignoredScrollViewContentInsetTop
        }
    }
    
    /** 上一次下拉刷新成功的时间 */
    var lastUpdatedTime:NSDate?{
        return UserDefaults.standard.object(forKey: PXRefreshHeaderLastUpdatedTimeKey) as? NSDate
    }
    
    /** 默认是关闭状态, 如果遇到 CollectionView 的动画异常问题可以尝试打开 */
    var isCollectionViewAnimationBug = false
    
    private var insetTDelta:CGFloat = 0
    
    convenience init(refreshingBlock block:@escaping ()->()) {
        self.init()
        refreshingBlock = block
    }
    
    //MARK:覆盖父类的方法
    override func prepare()
    {
        super.prepare()
        // 设置高度
        height = PXRefreshHeaderHeight
    }

    override func placeSubviews()
    {
        super.placeSubviews()
        
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
        top = -height - ignoredScrollViewContentInsetTop
    }

    func resetInset() {
        if #available(iOS 11.0, *) {
        } else {
            // 如果 iOS 10 及以下系统在刷新时, push 新的 VC, 等待刷新完成后回来, 会导致顶部 Insets.top 异常, 不能 resetInset, 检查一下这种特殊情况
            guard window != nil else { return }
        }
        
        // sectionheader停留解决
        guard let scrollView = scrollView else { return }
        var insetT = -scrollView.offsetY > scrollViewOriginalInset.top ? -scrollView.offsetY : scrollViewOriginalInset.top
        insetT = insetT > height + scrollViewOriginalInset.top ? height + scrollViewOriginalInset.top : insetT
        insetTDelta = scrollViewOriginalInset.top - insetT
        // 避免 CollectionView 在使用根据 Autolayout 和 内容自动伸缩 Cell, 刷新时导致的 Layout 异常渲染问题
        if scrollView.insetT != insetT {
            scrollView.insetT = insetT
        }
    }

    override func scrollViewContentOffsetDidChange(change:[NSKeyValueChangeKey : Any])
    {
        super.scrollViewContentOffsetDidChange(change: change)
        
        // 在刷新的refreshing状态
        if state == .refreshing {
            resetInset()
            return
        }
        
        guard let scrollView = scrollView else { return }
        // 跳转到下一个控制器时，contentInset可能会变
        //scrollViewOriginalInset = scrollView?.inset
        
        // 当前的contentOffset
        let offsetY = scrollView.offsetY
        // 头部控件刚好出现的offsetY
        let happenOffsetY = -scrollViewOriginalInset.top
        
        // 如果是向上滚动到看不见头部控件，直接返回
        // >= -> >
        if offsetY > happenOffsetY { return }
        
        // 普通 和 即将刷新 的临界点
        let normal2pullingOffsetY = happenOffsetY - height
        let pullingPercent = (happenOffsetY - offsetY) / height
        
        if scrollView.isDragging { // 如果正在拖拽
            self.pullingPercent = pullingPercent
            if state == .idle && offsetY < normal2pullingOffsetY {
                // 转为即将刷新状态
                state = .pulling
            } else if state == .pulling && offsetY >= normal2pullingOffsetY {
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
            if state == .idle && oldValue == .refreshing {
                headerEndingAction()
            } else if (state == .refreshing) {
                headerRefreshingAction()
            }
        }
    }
    
    func headerEndingAction() {
        // 保存刷新时间
        UserDefaults.standard.setValue(Date.init(), forKey: PXRefreshHeaderLastUpdatedTimeKey)
        UserDefaults.standard.synchronize()
        
        guard let scrollView = scrollView else { return }
        // 默认使用 UIViewAnimation 动画
        if !isCollectionViewAnimationBug {
            // 恢复inset和offset
            UIView.animate(withDuration: slowAnimationDuration) {
                scrollView.insetT += self.insetTDelta
//                if endRefreshingAnimationBeginAction {
//                    endRefreshingAnimationBeginAction()
//                }
            } completion: { finished in
                self.pullingPercent = 0.0
                if let endRefreshingBlock = self.endRefreshingBlock  {
                    endRefreshingBlock()
                }
            }
            return;
        }
        
        /**
         这个解决方法的思路出自 https://github.com/CoderMJLee/MJRefresh/pull/844
         修改了用+ [UIView animateWithDuration: animations:]实现的修改contentInset的动画
         fix issue#225 https://github.com/CoderMJLee/MJRefresh/issues/225
         另一种解法 pull#737 https://github.com/CoderMJLee/MJRefresh/pull/737
         
         同时, 处理了 Refreshing 中的动画替换.
        */
        
        // 由于修改 Inset 会导致 self.pullingPercent 联动设置 self.alpha, 故提前获取 alpha 值, 后续用于还原 alpha 动画
        let viewAlpha = alpha
        
        scrollView.insetT += insetTDelta
        // 禁用交互, 如果不禁用可能会引起渲染问题.
        scrollView.isUserInteractionEnabled = false

        //CAAnimation keyPath 不支持 contentInset 用Bounds的动画代替
        let boundsAnimation = CABasicAnimation.init(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue.init(cgRect: scrollView.bounds.offsetBy(dx: 0, dy: insetTDelta))
        boundsAnimation.duration = slowAnimationDuration
        //在delegate里移除
        boundsAnimation.isRemovedOnCompletion = false
        boundsAnimation.fillMode = CAMediaTimingFillMode.both
        boundsAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        boundsAnimation.delegate = self
        boundsAnimation.setValue(PXRefreshHeaderRefreshing2IdleBoundsKey, forKey: "identity")

        scrollView.layer.add(boundsAnimation, forKey: PXRefreshHeaderRefreshing2IdleBoundsKey)
        
//        if endRefreshingAnimationBeginAction {
//            endRefreshingAnimationBeginAction()
//        }
        
        // 自动调整透明度的动画
        if isAutomaticallyChangeAlpha {
            let opacityAnimation = CABasicAnimation.init(keyPath: "opacity")
            opacityAnimation.fromValue = viewAlpha
            opacityAnimation.toValue = 0.0
            opacityAnimation.duration = slowAnimationDuration
            opacityAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            layer.add(opacityAnimation, forKey:PXRefreshHeaderRefreshing2IdleOpacity)

            // 由于修改了 inset 导致, pullingPercent 被设置值, alpha 已经被提前修改为 0 了. 所以这里不用置 0, 但为了代码的严谨性, 不依赖其他的特殊实现方式, 这里还是置 0.
            alpha = 0;
        }
    }

    func headerRefreshingAction() {
        // 默认使用 UIViewAnimation 动画
        guard let scrollView = scrollView else { return }

        if !isCollectionViewAnimationBug {
            UIView.animate(withDuration: fastAnimationDuration) {
                if scrollView.panGestureRecognizer.state != .cancelled {
                    let top = self.scrollViewOriginalInset.top + self.height
                    // 增加滚动区域top
                    scrollView.insetT = top
                    // 设置滚动位置
                    var offset = scrollView.contentOffset
                    offset.y = -top;
                    scrollView.setContentOffset(offset, animated: false)
                }
            } completion: { finished in
                self.executeRefreshingCallback()
            }
            return;
        }
        
        if scrollView.panGestureRecognizer.state != .cancelled {
            let top = scrollViewOriginalInset.top + height
            // 禁用交互, 如果不禁用可能会引起渲染问题.
            scrollView.isUserInteractionEnabled = false

            // CAAnimation keyPath不支持 contentOffset 用Bounds的动画代替
            let boundsAnimation = CABasicAnimation.init(keyPath: "bounds")
            var bounds = scrollView.bounds
            bounds.origin.y = -top;
            boundsAnimation.fromValue = NSValue.init(cgRect: scrollView.bounds)
            boundsAnimation.toValue = NSValue.init(cgRect: bounds)
            boundsAnimation.duration = fastAnimationDuration
            //在delegate里移除
            boundsAnimation.isRemovedOnCompletion = false
            boundsAnimation.fillMode = CAMediaTimingFillMode.both;
            boundsAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            boundsAnimation.delegate = self
            boundsAnimation.setValue(PXRefreshHeaderRefreshingBoundsKey, forKey: "identity")
            scrollView.layer.add(boundsAnimation, forKey:PXRefreshHeaderRefreshingBoundsKey)
        } else {
            executeRefreshingCallback()
        }
    }
}

extension PXRefreshHeader:CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let scrollView = scrollView else { return }

        let identity = anim.value(forKey: "identity") as! String
        if identity == PXRefreshHeaderRefreshing2IdleBoundsKey {
            pullingPercent = 0.0;
            scrollView.isUserInteractionEnabled = true
            if let endRefreshingBlock = endRefreshingBlock {
                endRefreshingBlock()
            }
        } else if identity == PXRefreshHeaderRefreshingBoundsKey {
            // 避免出现 end 先于 Refreshing 状态
            if state != .idle {
                let top = scrollViewOriginalInset.top + height
                scrollView.insetT = top
                // 设置最终滚动位置
                var offset = scrollView.contentOffset
                offset.y = -top
                scrollView.setContentOffset(offset, animated: false)
             }
            scrollView.isUserInteractionEnabled = true
            executeRefreshingCallback()
        }
        
        if (scrollView.layer.animation(forKey: PXRefreshHeaderRefreshing2IdleBoundsKey) != nil) {
            scrollView.layer.removeAnimation(forKey: PXRefreshHeaderRefreshing2IdleBoundsKey)
        }
        
        if (scrollView.layer.animation(forKey: PXRefreshHeaderRefreshingBoundsKey) != nil) {
            scrollView.layer.removeAnimation(forKey: PXRefreshHeaderRefreshingBoundsKey)
        }
    }
}
