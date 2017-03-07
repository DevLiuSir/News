//
//  CycleViewModel.swift
//  News
//
//  Created by Liu Chuan on 2016/12/22.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class CycleViewModel: NSObject {
    
   
    var title  : String = ""      // 标题
    var imgsrc : String = ""     // 展示的图片地址

//    var ads    : [[String: Any]]? // 轮播图
    
    // MARK:- 自定义构造函数
    // KVC 字典转模型
    init(dict: [String: Any]) {
        super.init()
    
        // 将字典里面的每一个key的值赋值给对应的模型属性
        setValuesForKeys(dict)
    
    }
        
     override func setValue(_ value: Any?, forUndefinedKey key: String) {}
  
}
