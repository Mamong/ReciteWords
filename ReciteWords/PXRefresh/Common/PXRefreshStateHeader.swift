//
//  MJRefreshStateHeader.swift
//  ReciteWords
//
//  Created by marco on 2022/3/1.
//

import UIKit

class PXRefreshStateHeader: PXRefreshHeader {
    var stateLabel:UILabel!
    var lastUpdatedTimeLabel:UILabel!
    private var stateTitles:[PXRefreshState:String] = [:]
    
    override func prepare() {
        super.prepare()
        
        stateLabel = UILabel.pxLabel()
        addSubview(stateLabel)
        
        lastUpdatedTimeLabel = UILabel.pxLabel()
        addSubview(lastUpdatedTimeLabel)
        
        textConfiguration()
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if stateLabel.isHidden { return }
        if lastUpdatedTimeLabel.isHidden {
            stateLabel.frame = bounds
        }else{
            let stateLabelH = height * 0.5
            // 状态
            stateLabel.frame = CGRect.init(x: 0, y: 0, width: width, height: stateLabelH)
            // 更新时间
            lastUpdatedTimeLabel.frame = CGRect.init(x: 0, y: stateLabelH, width: width, height: stateLabelH)
        }
    }
    
    func textConfiguration() {
        // 初始化文字
        setTitle(PXRefreshHeaderIdleText, for: .idle)
        setTitle(PXRefreshHeaderPullingText, for: .pulling)
        setTitle(PXRefreshHeaderRefreshingText, for: .refreshing)
        
        updateTimeLabel()
    }
    
    func setTitle(_ title: String?,
                  for state: PXRefreshState){
        let text = title ?? ""
        stateTitles[state] = text
        stateLabel.text = stateTitles[self.state]
    }
    
    func updateTimeLabel(){
        // 如果label隐藏了，就不用再处理
        if lastUpdatedTimeLabel.isHidden { return }
        
        let lastUpdatedTime = UserDefaults.standard.object(forKey: PXRefreshHeaderLastUpdatedTimeKey) as? Date
        
        let bundle = PXRefreshBundle.shared
        if let lastUpdatedTime = lastUpdatedTime {
            // 1.获得年月日
            let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
            let unitFlags:NSCalendar.Unit = [.year,.month,.day,.hour,.minute]
            let cmp1 = calendar?.components(unitFlags, from: lastUpdatedTime)
            let cmp2 = calendar?.components(unitFlags, from: Date.init())
            
            // 2.格式化日期
            let formatter = DateFormatter.init()
            var isToday = false
            if cmp1?.day == cmp2?.day { // 今天
                formatter.dateFormat = " HH:mm";
                isToday = true
            } else if cmp1?.year == cmp2?.year { // 今年
                formatter.dateFormat = "MM-dd HH:mm"
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            }
            let time = formatter.string(from: lastUpdatedTime)
            
            // 3.显示日期
            lastUpdatedTimeLabel.text = "\(bundle.localizedString(forKey: PXRefreshHeaderLastTimeText))\(isToday ? bundle.localizedString(forKey:PXRefreshHeaderDateTodayText) : "")\(time)"
        } else {
            lastUpdatedTimeLabel.text = "\(bundle.localizedString(forKey: PXRefreshHeaderLastTimeText))\( bundle.localizedString(forKey:PXRefreshHeaderNoneLastDateText))"
        }
    }
    
    override var state: PXRefreshState{
        didSet{
            stateLabel.text = stateTitles[self.state]
            updateTimeLabel()
        }
    }
}
