//
//  ProgressHUD.swift
//  News
//
//  Created by Liu Chuan on 2016/9/25.
//  Copyright © 2016年 LC. All rights reserved.
//



import UIKit
import SVProgressHUD

class ProgressHUD: NSObject {
    
    /// 显示 HUD
    static func show() {
        // 自定义提示的内容
        SVProgressHUD.show(withStatus: "正在加载")
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.8))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setCornerRadius(12.0)
    }
    
    /// 隐藏 HUD
    static func dismiss() {
        SVProgressHUD.dismiss()
    }
    
}
