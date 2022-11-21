//
//  PXRefreshView.swift
//  ReciteWords
//
//  Created by marco on 2022/2/27.
//

import UIKit

enum PXRefreshState {
    case idle
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}

fileprivate struct KVO {
        
    static var context = "PullToRefreshKVOContext"
    
    enum ScrollViewPath {
        static let contentOffset = #keyPath(UIScrollView.contentOffset)
        static let contentInset = #keyPath(UIScrollView.contentInset)
        static let contentSize = #keyPath(UIScrollView.contentSize)
        static let panState = #keyPath(UIPanGestureRecognizer.state)
    }
}

class PXRefreshView: UIView{
    
    //MARK:刷新动画时间控制
    /** 快速动画时间(一般用在刷新开始的回弹动画), 默认 0.25 */
    var fastAnimationDuration:TimeInterval = 0.25
    /** 慢速动画时间(一般用在刷新结束后的回弹动画), 默认 0.4*/
    var slowAnimationDuration:TimeInterval = 0.4

    /** 开始刷新后的回调(进入刷新状态后的回调) */
    //var beginRefreshingCompletionBlock:(()->())?
    
    /** 正在刷新的回调 */
    var refreshingBlock:(()->())?
    
    /** 结束刷新动画开始前的回调 */
    //var endRefreshingAnimationBeginBlock:(()->())?
    
    /** 结束刷新的回调 */
    var endRefreshingBlock:(()->())?

    
    var state:PXRefreshState = .idle {
        didSet{
            DispatchQueue.main.async {
                self.setNeedsLayout()
            }
        }
    }
    
    private(set) weak var scrollView:UIScrollView?
    private(set) var scrollViewOriginalInset:UIEdgeInsets!
    private var isObserving = false
    private var pan:UIPanGestureRecognizer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    func prepare()
    {
        // 基本属性
        autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        backgroundColor = UIColor.clear
    }

    override func layoutSubviews()
    {
        placeSubviews()
        super.layoutSubviews()
    }

    func placeSubviews(){}
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let newView = newSuperview {
            guard newView.isKind(of: UIScrollView.self) else {
                return
            }
            showRefresh = true
        }else{
            showRefresh = false
        }
    }
    
    var showRefresh:Bool = true{
        didSet{
            if showRefresh == oldValue {
                return
            }
            guard let scrollView = scrollView else { return }

            if showRefresh {
                scrollView.alwaysBounceVertical = true
                
                width = scrollView.width
                left = scrollView.insetL
                
                self.scrollView = scrollView
                scrollViewOriginalInset = scrollView.contentInset

                addObservers()
            }else{
                scrollView.contentInset = scrollViewOriginalInset
                removeObservers()
            }
            isHidden = !showRefresh
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if state == .willRefresh {
            // 预防view还没显示出来就调用了beginRefreshing
            state = .refreshing
        }
    }
    
    //MARK: - KVO监听
    func addObservers()
    {
        guard let scrollView = scrollView, !isObserving else {
            return
        }
        
        scrollView.addObserver(self, forKeyPath: KVO.ScrollViewPath.contentOffset, options: .initial, context: &KVO.context)
        scrollView.addObserver(self, forKeyPath: KVO.ScrollViewPath.contentSize, options: .initial, context: &KVO.context)
        scrollView.addObserver(self, forKeyPath: KVO.ScrollViewPath.contentInset, options: .new, context: &KVO.context)
        
        isObserving = true
        pan = scrollView.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: KVO.ScrollViewPath.panState, options: .initial, context: &KVO.context)
        //[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(i18nDidChange) name:MJRefreshDidChangeLanguageNotification object:MJRefreshConfig.defaultConfig];
    }

    func removeObservers()
    {
        guard let scrollView = scrollView, isObserving else {
            return
        }
        
        scrollView.removeObserver(self, forKeyPath: KVO.ScrollViewPath.contentOffset, context: &KVO.context)
        scrollView.removeObserver(self, forKeyPath: KVO.ScrollViewPath.contentSize, context: &KVO.context)
        scrollView.removeObserver(self, forKeyPath: KVO.ScrollViewPath.contentInset, context: &KVO.context)
        
        isObserving = false
        pan?.removeObserver(self, forKeyPath:KVO.ScrollViewPath.panState, context: &KVO.context)
        pan = nil
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == &KVO.context else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        guard isUserInteractionEnabled else {
            return
        }
        
        if (keyPath == KVO.ScrollViewPath.contentSize) {
            scrollViewContentSizeDidChange(change: change!)
        }
        
        guard !isHidden else {
            return
        }
        
        if (keyPath == KVO.ScrollViewPath.contentOffset) {
            scrollViewContentOffsetDidChange(change: change!)
        } else if (keyPath == KVO.ScrollViewPath.contentInset) {
            scrollViewOriginalInset = scrollView!.contentInset
        } else if (keyPath == KVO.ScrollViewPath.panState) {
            scrollViewPanStateDidChange(change: change!)
        }
    }
    
    /** 当scrollView的contentOffset发生改变的时候调用 */
    func scrollViewContentOffsetDidChange(change:[NSKeyValueChangeKey : Any]){}
    
    /** 当scrollView的contentSize发生改变的时候调用 */
    func scrollViewContentSizeDidChange(change:[NSKeyValueChangeKey : Any]){}

    /** 当scrollView的拖拽状态发生改变的时候调用 */
    func scrollViewPanStateDidChange(change:[NSKeyValueChangeKey : Any]){}
    
    //MARK:进入刷新状态
    func beginRefreshing()
    {
        UIView.animate(withDuration: fastAnimationDuration) {
            self.alpha = 1.0
        }
        pullingPercent = 1.0;
        // 只要正在刷新，就完全显示
        if window != nil {
            state = .refreshing
        } else {
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if (state != .refreshing) {
                state = .willRefresh
                // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                setNeedsDisplay()
            }
        }
    }

    func beginRefreshingWithCompletionBlock(completionBlock:@escaping()->())
    {
        refreshingBlock = completionBlock
        beginRefreshing()
    }

    //MARK:结束刷新状态
    func endRefreshing()
    {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }

    func endRefreshingWithCompletionBlock(completionBlock:@escaping()->())
    {
        endRefreshingBlock = completionBlock
        endRefreshing()
    }

    //MARK:是否正在刷新
    var isRefreshing:Bool{
        return [.refreshing,.willRefresh].contains(state)
    }
    
    //MARK:自动切换透明度
    var isAutomaticallyChangeAlpha = false{
        didSet{
            guard !isRefreshing else{
                return
            }
            if isAutomaticallyChangeAlpha {
                alpha = pullingPercent
            }else{
                alpha = 1.0
            }
        }
    }

    //MARK:根据拖拽进度设置透明度
    var pullingPercent:CGFloat = 0.0{
        didSet{
            guard !isRefreshing else{
                return
            }
            if isAutomaticallyChangeAlpha {
                alpha = pullingPercent
            }
        }
    }

    /** 触发回调（交给子类去调用） */
    func executeRefreshingCallback(){
        if let refreshingBlock = refreshingBlock {
            refreshingBlock()
        }
    }
    
    /** 关闭全部默认动画效果, 可以简单粗暴地解决 CollectionView 的回弹动画 bug */
    func setAnimationDisabled(){
        fastAnimationDuration = 0
        slowAnimationDuration = 0
    }
}

extension UILabel{
    class func pxLabel() -> UILabel{
        let label = UILabel.init()
        label.font = PXRefreshLabelFont
        label.textColor = PXRefreshLabelTextColor
        //label.autoresizingMask = UIViewAutoresizingFlexibleWidth
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }
}
