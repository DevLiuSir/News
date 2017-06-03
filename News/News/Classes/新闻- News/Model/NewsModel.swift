//
//  NewsModel.swift
//  网易新闻
//
//  Created by Liu Chuan on 2016/11/9.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeTopDataModel: NSObject {

    var id: String?
    var tname: String?
    
    init(jsonDic: JSON?) {
        if let jsonDic = jsonDic {
//            editable = jsonDic["editable"].boolValue
            
            id = jsonDic["id"].stringValue
            tname = jsonDic["tname"].stringValue
        }
    }
}

class NewsModel: NSObject {
    
    // MARK: 定义属性
    var title       : String = ""              // 内容标题
    var replyCount  : Int = 0                  // 回复数/跟帖数
    var imgsrc      : String = ""              // 图片地址
    var source      : String = ""              // 来源
    var digest      : String = ""              // 摘要
    var imgextra    : [[String: Any]]?         // 多张配图
    var imgType     : Int = 0                  // 大图
    var tname       : String = ""              // 新闻所属于频道(类别)
    var tid         : String = ""              // 频道ID
    var docid       : String = ""
    
    // MARK: 定义字典转模型的构造函数
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    /// 获取新闻tid的结构体
    static func messages(_ tid: String, completionHandler: (([NewsModel]) -> Void)?) {
        
        //MARK: 状态栏是否显示风火轮
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let tool = Tool.sharedTool()
        
        tool.get("article/headline/\(tid)/0-140.html", parameters: nil, progress: nil, success: { (task, obj) -> Void in
        
            // 根据 tid 的 key 取出内容
            var messages = (obj as! [String: AnyObject])[tid] as? [[String: AnyObject]]
            
            /// 定义变量, 存储模型数组
            var arrM = [NewsModel]()
            
             // 遍历字典, 将字典转换成模型对象
            for i in 0 ..< messages!.count {
               // 字典转模型
                let news = NewsModel(dict: messages![i])
               
                // 添加到数组中
                arrM.append(news)
            }
            // 回调传值给arrM
            completionHandler!(arrM)
            
            //MARK: 状态栏是否显示风火轮
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }) { (task, error) -> Void in
            
        }
    }

}

