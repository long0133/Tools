//
//  DBHTradingMarketView.swift
//  FBG
//
//  Created by yy on 2018/3/16.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class DBHTradingMarketView: UIView {
    // 你的观点
    var yourOpinion:String!
    
    // 聊天室id
    var chatRoomId:String!
    
    // 项目id
    var projectId:String!
    
    var max:String!
    
    var min:String!
    
    var titleStr:String!
    
    // 是否设置行情提醒
    var isMarketFollow:String!
    
    //1 声明变量
    lazy var marketDetailView: DBHMarketDetailView = {
        let marketDetailView = DBHMarketDetailView()
        marketDetailView.isMarketFollow = self.isMarketFollow
        marketDetailView.max = self.max
        marketDetailView.min = self.min
        return marketDetailView
    }()
    
    lazy var timeSelectView: DBHTimeSelectView = {
        let timeSelectView = DBHTimeSelectView()
        timeSelectView.clickTime({ (time) in
            self.marketDetailViewModel.getKLineData(withIco_type: self.titleStr, interval: time)
        })
        return timeSelectView
    }()
    
    lazy var grayLineView: UIView = {
        let grayLineView = UIView()
        grayLineView.backgroundColor = UIColor.ch_hex(0xEEEEEE)
        return grayLineView
    }()
    
    lazy var yourOpinionButton: UIButton = {
        let yourOpinionButton = UIButton(type: .custom)
        yourOpinionButton.setTitle(self.yourOpinion, for: UIControlState.normal)
        yourOpinionButton.setTitleColor(UIColor.ch_hex(0x626262), for: UIControlState.normal)
        yourOpinionButton.addTarget(self, action: #selector(respondsToYourOpinionButton), for: UIControlEvents.touchUpInside)
        
        return yourOpinionButton
    }()
    lazy var style: CHKLineChartStyle = {
        let style: CHKLineChartStyle = .base
        // 文字颜色
        style.textColor = UIColor.ch_hex(0x333333)
        
        // 背景颜色
        style.backgroundColor = UIColor.ch_hex(0xFFFFFF)
        
        // 边线颜色
        //        style.lineColor = UIColor(white: 0.2, alpha: 1)
        //
        //        // 虚线颜色
        //        style.dashColor = UIColor(white: 0.2, alpha: 1)
        
        // 选中点的显示的文字颜色
        //        style.selectedTextColor = UIColor(white: 0.8, alpha: 1)
        
        // 删除最后一个分区
        style.sections.removeLast();
        
        // 不显示坐标轴
        style.showYLabel = CHYAxisShowPosition.left
        
        // 把y坐标内嵌到图表中
        style.isInnerYAxis = true
        
        // 边距
        style.padding = UIEdgeInsetsMake(0, 3, 0, 3)
        
        style.showXAxisOnSection = 0
        
        //        style.enableTap = false
        
        // 关闭数据显示
        for section in style.sections {
            section.showTitle = false
            
            if section.isEqual(style.sections.last) {
                section.series.remove(at: style.sections.count - 1)
            }
        }
        
        _ = style.sections.map {
            $0.backgroundColor = style.backgroundColor
        }
        
        return style
    }()
    lazy var chartView: CHKLineChartView = {
        let chartView = CHKLineChartView(frame: self.frame)
        
        chartView.delegate = self
        chartView.style = self.style;
        
        return chartView
    }()
    
    lazy var lineValueView: DBHLineValueView = {
        let lineValueView = DBHLineValueView(frame: self.frame)

        lineValueView.backgroundColor = UIColor.clear
        return lineValueView
    }()
    
    lazy var marketDetailViewModel: DBHMarketDetailViewModel = {
        let marketDetailViewModel = DBHMarketDetailViewModel()
        
        marketDetailViewModel.requestMoneyRealTimePriceBlock { (moneyRealTimePriceModel) in
            self.marketDetailView.model = moneyRealTimePriceModel
            self.marketDetailView.projectId = self.projectId
        }
        marketDetailViewModel.request({ (kLineDataArray) in
            self.klineDatas = kLineDataArray! as [AnyObject]
            self.chartView.reloadData()
        })
        
        return marketDetailViewModel
    }()
    var klineDatas = [AnyObject]()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    //3 增加设置图片方法
    func setUI() {
        self.backgroundColor = UIColor.white;
        
        self.addSubview(self.marketDetailView)
        self.addSubview(self.timeSelectView)
        self.addSubview(self.chartView)
        self.addSubview(self.grayLineView)
        self.addSubview(self.lineValueView)
        //        self.view.addSubview(self.yourOpinionButton)
        
        self.marketDetailView.snp_remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(self.autolayousize(size: 110))
            make.top.centerX.equalToSuperview()
        }
        self.timeSelectView.snp_remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(self.autolayousize(size: 40))
            make.top.equalTo(self.marketDetailView.snp_bottom)
            make.centerX.equalToSuperview()
        }
        self.chartView.snp_remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(self.timeSelectView.snp_bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.grayLineView.snp_top)
        }
        self.grayLineView.snp_remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(self.autolayousize(size: 1))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self)
        }
        self.lineValueView.snp_remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(self.autolayousize(size: 30))
            make.top.centerX.equalTo(self.chartView)
        }
        
        self.lineValueView.isHidden = true
        //        self.yourOpinionButton.snp_remakeConstraints { (make) in
        //            make.width.equalToSuperview()
        //            make.height.equalTo(self.autolayousize(size: 47))
        //            make.centerX.equalToSuperview()
        //            make.bottom.equalToSuperview()
        //        }
    }
    
    
    public func refreshTitleStr() {
        self.marketDetailViewModel.getMoneyRealTimePrice(withIco_type: self.titleStr, isRunLoop: true)
        self.marketDetailViewModel.getKLineData(withIco_type: self.titleStr, interval:String(describing: self.timeSelectView.timeValueArray[self.timeSelectView.currentSelectedIndex]))
    }
    
    /// 你的观点
    func respondsToYourOpinionButton() {
        // 聊天室
        //        let chatViewController = EaseMessageViewController(conversationChatter: chatRoomId, conversationType: EMConversationTypeChatRoom)
        //        chatViewController?.title = self.title
        //        self.navigationController?.pushViewController(chatViewController!, animated: true)
    }
    
    func refreshKLineViewData() {
        self.marketDetailViewModel.getKLineData(withIco_type: self.titleStr, interval: String(describing: self.timeSelectView.timeValueArray[self.timeSelectView.currentSelectedIndex]))
    }
    
    func autolayousize(size: CGFloat) -> CGFloat {
        return 375.0 / UIScreen.main.bounds.size.width * size;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 实现K线图表的委托方法
extension DBHTradingMarketView: CHKLineChartDelegate {
    
    func numberOfPointsInKLineChart(chart: CHKLineChartView) -> Int {
        return self.klineDatas.count
    }
    
    func kLineChart(chart: CHKLineChartView, valueForPointAtIndex index: Int) -> CHChartItem {
        let data : DBHMarketDetailKLineViewModelData = self.klineDatas[index] as! DBHMarketDetailKLineViewModelData
        let item = CHChartItem()
        item.time = Int(Float(data.time) / 1000.0)
        item.openPrice = CGFloat(Float(data.openedPrice)!)
        item.highPrice = CGFloat(Float(data.maxPrice)!)
        item.lowPrice = CGFloat(Float(data.minPrice)!)
        item.closePrice = CGFloat(Float(data.closedPrice)!)
        item.vol = CGFloat(Float(data.volume)!)
        return item
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnYAxisForValue value: CGFloat, section: CHSection) -> String {
        //        var strValue = ""
        //        if value / 10000 > 1 {
        //            strValue = (value / 10000).ch_toString(maxF: section.decimal) + "万"
        //        } else {
        //            strValue = value.ch_toString(maxF: section.decimal)
        //        }
        return ""//strValue
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnXAxisForIndex index: Int) -> String {
        let data : DBHMarketDetailKLineViewModelData = self.klineDatas[index] as! DBHMarketDetailKLineViewModelData
        let timestamp = Int(Float(data.time) / 1000.0)
        return Date.ch_getTimeByStamp(timestamp, format: "HH:mm")
    }
    
    
    /// 调整每个分区的小数位保留数
    ///
    /// - parameter chart:
    /// - parameter section:
    ///
    /// - returns:
    func kLineChart(chart: CHKLineChartView, decimalAt section: Int) -> Int {
        return 2
    }
    
    
    /// 调整Y轴标签宽度
    ///
    /// - parameter chart:
    ///
    /// - returns:
    func widthForYAxisLabel(in chart: CHKLineChartView) -> CGFloat {
        return chart.kYAxisLabelWidth
    }
    
    func kLineChart(chart: CHKLineChartView, didSelectAt index: Int, item: CHChartItem) {
        let longGR : UILongPressGestureRecognizer = chart.gestureRecognizers![1] as! UILongPressGestureRecognizer;
        
        if longGR.state ==  .cancelled || longGR.state == .ended  {
            self.timeSelectView.isShowData = false
            self.lineValueView.isHidden = true
        } else if longGR.state ==  .began {
            self.timeSelectView.isShowData = true
            self.lineValueView.isHidden = false
//            let info = "my name is \(name) , my age is \(age) , my height is \(height)"
            var values = ["", "", ""]
            let titles = ["MA5_Price","MA10_Price","MA30_Price"]
            for (i , title) in titles.enumerated(){
                let value = item.extVal[title]
                values[i] = title.appendingFormat("%.2f", value!)
            }
            
            self.lineValueView .setLabels(values)
            
            let data : DBHMarketDetailKLineViewModelData = self.klineDatas[index] as! DBHMarketDetailKLineViewModelData
            self.timeSelectView.model = data
        } else {
            var values = ["", "", ""]
            let titles = ["MA5_Price","MA10_Price","MA30_Price"]
            for (i , title) in titles.enumerated(){
                let value = item.extVal[title]
                values[i] = title.appendingFormat("%.2f", value!)
            }
            
            self.lineValueView .setLabels(values)
            
            let data : DBHMarketDetailKLineViewModelData = self.klineDatas[index] as! DBHMarketDetailKLineViewModelData
            self.timeSelectView.model = data
        }
    }
}


