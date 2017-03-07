//
//  NewsView+Extension.swift
//  News
//
//  Created by Liu Chuan on 2016/9/25.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

// MARK:- 定义全局常量

let screenW = UIScreen.main.bounds.width    // 屏幕的宽度
let screenH = UIScreen.main.bounds.height   // 屏幕的高度
let statusH: CGFloat = 20                   // 状态栏的高度
let navigationH: CGFloat = 44               // 导航栏的高度
let tabBarH: CGFloat = 49                   // 标签栏的高度
let scrollLineH: CGFloat = 2                // 底部滚动滑块的高度
let titleViewH: CGFloat = 44                // 标题滚动视图的高度
let CycleViewHeight = screenW * 3 / 6       // 轮播图高度
let refresh_HeaderViewHeight: CGFloat = 90  // 刷新视图高度
let refresh_FooterViewHeight: CGFloat = 60  // 底部加载更多视图高度
let SpreadMaxH:CGFloat = screenH - 64       // 默认下拉展开的最大高度

//let colorLan = UIColor(hue:0.56, saturation:0.76, brightness:1.00, alpha:1.00)
//let colorLan = UIColor(hue:0.59, saturation:1.00, brightness:1.00, alpha:0.80)        //全局颜色: 蓝色

let colorLan = UIColor(hue:0.40, saturation:0.78, brightness:0.68, alpha:1.00)           // 暗绿



let BASE_URL = "http://c.3g.163.com/nc/"    // 服务器地址
