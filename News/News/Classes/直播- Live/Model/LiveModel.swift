//
//  LiveModel.swift
//  News
//
//  Created by Liu Chuan on 2017/3/14.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class LiveModel: NSObject {

    //http://m.yizhibo.com/l/MbvFHp5I8umuqe0K.html
    
    // MARK: 定义属性
    var title       : String = ""               // 内容标题
    var pic         : String = ""               // 照片
    var onlineNums  : Int = 0                   // 参与人数
    var link        : String = ""               // 链接
    var newsId      : String = ""               // 直播ID
    var startTimeStr: String = ""               // 播放开始的时间
    
    var liveInfo    : [String : Any]?           // 直播信息
    
    
    

    // MARK: 定义字典转模型的构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }


    override func setValue(_ value: Any?, forUndefinedKey key: String) {}


}
