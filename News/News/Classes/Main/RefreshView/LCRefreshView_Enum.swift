//
//  LCRefreshView_Enum.swift
//  News
//
//  Created by Liu Chuan on 2016/12/24.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit


let RefreshHeaderTimeKey:NSString =  "RefreshHeaderView"




// MARK: - 控件的类型
enum LCRefreshViewType{
    case
    LCRefreshHeaderView,    // 头部控件
    LCRefreshFooterView      // 尾部控件
}

// MARK: - 刷新视图的状态. 枚举
// MARK: - ** Header 刷新状态 **
enum LCRefresh_HeaderStatus {
    case
    normal,             // 默认状态
    waitRefresh,        // 等待刷新
    refreshing          // 正在刷新
}
// MARK: - ** Footer 刷新状态 **
enum LCRefresh_FooterStatus {
    case
    normal,
    waitLoad,
    loading,
    loadover            // 加载完毕
}

// MARK: - ** 当前刷新对象 **
enum LCRefresh_Object {
    case none,          // 无
    header,
    footer
}
