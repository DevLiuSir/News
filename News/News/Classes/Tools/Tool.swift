//
//  Tool.swift
//  News
//
//  Created by Liu Chuan on 2017/3/8.
//  Copyright © 2017年 LC. All rights reserved.
//

import Foundation
import AFNetworking


class Tool: AFHTTPSessionManager {
    
    
    // 单例的存在, 使可以全局访问状态
    /// 单例实现    
    static let tool = Tool(baseURL: URL(string: "http://c.3g.163.com/nc/"), sessionConfiguration: .default)
    
    
    /// 类型方法使用static修饰的话，子类不能重写
    static func sharedTool() -> Tool {
        return tool
    }
    
    override init(baseURL url: URL?, sessionConfiguration configuration: URLSessionConfiguration?) {
        super.init(baseURL: url, sessionConfiguration: configuration)
        // 支持"text/html格式
        responseSerializer.acceptableContentTypes?.insert("text/html")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
