//
//  searchModel.swift
//  News
//
//  Created by Liu Chuan on 2017/5/29.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class SearchModel: NSObject {
    
    var hotWord: String?        // 近期搜索
    
    
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
