//
//  CalendarController.swift
//  Calendar
//
//  Created by Liu Chuan on 2017/5/30.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit
import CVCalendar


/// 日历控制器
class CalendarController: UIViewController {
    
    // MARK: - 控件属性
    /// 星期菜单栏
    var menuView: CVCalendarMenuView!
    /// 日历主视图
    var calendarView: CVCalendarView!
    
    // MARK: - 定义属性
    /// 当前日历
    var currentCalendar: Calendar!
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    // 设置状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// 配置UI界面
    private func configUI() {
        
        view.backgroundColor = .white
        
        configNavigationBar()
        
        // 初始化
        currentCalendar = Calendar(identifier: .gregorian)

        //初始化的时候导航栏显示: 年\月\日
        title = CVDate(date: Date(), calendar: currentCalendar).commonDescription

        // 初始化星期菜单栏
        menuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 80, width: screenW, height: 20))
        
        // 初始化日历主视图
        calendarView = CVCalendarView(frame: CGRect(x: 0, y: 110, width: screenW, height: 450))
        
        // 星期菜单栏代理
        menuView.menuViewDelegate = self
        
        // 日历的代理
        calendarView.calendarDelegate = self
        
        // 日历样式代理
        calendarView.calendarAppearanceDelegate = self

        // 添加日历\菜单栏视图
        view.addSubview(menuView)
        view.addSubview(calendarView)
    }
    
    
    /// 配置导航栏
    private func configNavigationBar() {
        
        // 隐藏返回按钮上的文字
//        navigationItem.backBarButtonItem?.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), for: .default)

        // 修改导航栏文字颜色
         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        // 设置导航栏右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "今天", style: .plain, target: self, action: #selector(todayButtonTapped(_:)))
    }
    
    
    //今天按钮点击
    @objc private func todayButtonTapped(_ sender: AnyObject) {
        let today = Date()
        self.calendarView.toggleViewWithDate(today)
    }
    // 布局完成后调用
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //更新日历frame
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
}

// MARK: - 遵守 CVCalendarViewDelegate 协议
extension CalendarController: CVCalendarViewDelegate {
    
    
    /// 设置视图的显示模式
    ///
    /// - Returns: 视图模式
    func presentationMode() -> CalendarMode {
        return .monthView   // 使用月视图
    }
    
    // 每周第一天
    func firstWeekday() -> Weekday {
        return .sunday      // 从星期日开始
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        
        // 导航栏显示当前日历的 年\月\日
        title = date.commonDescription
    }
    
     //每个日期上面是否添加横线(连在一起就形成每行的分隔线)
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return true
    }
    
    //切换月的时候日历是否自动选择某一天（本月为今天，其它月为第一天）
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return true
    }
    
    
    //切换周的时候日历是否自动选择某一天（本周为今天，其它周为第一天）
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return false
    }
    //是否显示非当月的日期
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }

    
}

// MARK: - 遵守 CVCalendarMenuViewDelegate 协议
extension CalendarController: CVCalendarMenuViewDelegate {
    
    // 星期栏文字字体大小
    func dayOfWeekFont() -> UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
    
    //星期栏文字颜色
//    func dayOfWeekTextColor() -> UIColor {
//        return UIColor.white
//    }
//    
    //星期栏背景颜色
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor.white
    }
    //星期文字颜色设置
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday || weekday == .saturday ? UIColor.red : UIColor.black
    }
    
//    func dayOfWeekBackGroundColor(by weekday: Weekday) -> UIColor {
//        return UIColor.lightGray
//    }
    
    //星期栏文字显示类型
    func weekdaySymbolType() -> WeekdaySymbolType {
        /*
         normal：正常模式
         short：缩写模式（默认）
         veryShort：极简模式
         
         */
        
        return WeekdaySymbolType.short
        
    }
    
    // 非当月日期文字颜色
    func dayLabelWeekdayOutTextColor() -> UIColor {
        return UIColor.red.withAlphaComponent(0.1)
    }
    
    // 选中日期调用
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        
        print("当前选择的日期......")
    }
}

/*
// MARK: - 遵守 CVCalendarViewAppearanceDelegate 协议
extension CalendarController: CVCalendarViewAppearanceDelegate {
    
    //        日历样式自定义
    //        要修改日历的默认样式，首先我们要设置相关的样式代理：
    //        接下来我们对默认样式做个修改：
    //        加大文字大小
    //        选中的日期：文字为白色，背景为紫色
    //        周日的日期：文字为红色。选中的话背景变红色，文字变白色。
    
    
    /// 颜色结构体
    struct Color {
        static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0,
                                                 alpha: 1.0)
        static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6,
                                                alpha: 1.0)
        static let sundaySelectionBackground = sundayText
    }
    
    //文字字体设置
//    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont {
//        return UIFont.systemFont(ofSize: 17, weight: UIFontWeightBold)
//    }

//    func dayLabelWeekdayTextSize() -> CGFloat {
//        return 26
//    }
    
//
//    func dayLabelSize(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> CGFloat {
//        return 17
//    }
//    
    
    
//    func dayLabelWeekdayHighlightedFont() -> UIFont {
//        
//        return UIFont.systemFont(ofSize: 22, weight: UIFontWeightBlack)
//    }
//    
//    func dayLabelPresentWeekdayInitallyBold() -> Bool {
//        return true
//    }
//    

    // 文字颜色设置
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        
        switch (weekDay, status, present) {
            
            case (_, .selected, _), (_, .highlighted, _): return UIColor.white
            case (.sunday, .in, _): return Color.sundayText
            case (.saturday, .in, _): return Color.sundayText
            case (.sunday, _, _): return Color.sundayTextDisabled
            case (.saturday, _, _): return Color.sundayTextDisabled
            case (_, .in, _): return UIColor.black
            default: return UIColor.gray
        }
    }
    
    // 文字背景色设置
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        
        switch (weekDay, status, present) {
            
            case (.sunday, .selected, _), (.sunday, .highlighted, _): return Color.sundaySelectionBackground
            case (.saturday, .selected, _), (.saturday, .highlighted, _): return Color.sundaySelectionBackground
            case (_, .selected, _), (_, .highlighted, _): return Color.selectionBackground
            default: return UIColor.red
        }
    }
}
 */
