//
//  Channel.swift
//  News
//
//  Created by Liu Chuan on 2016/12/31.
//  Copyright © 2016年 LC. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: -频道列表
class ChannelModel : NSObject {
    
    
    var tid: String?
    
    var tname: String?      // 分类标题
    
    var urlString: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
       
        setValuesForKeys(dict)

    }
 
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // 通过 json 文件 加载 标题按钮
    static func channels() -> [ChannelModel] {
        
        var arrM = [ChannelModel]()
        
        // 加载 json 文件
//        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "topic_news", ofType: "json")!))
        
        // 加载 html
        let data = try? Data(contentsOf: URL(string: "http://c.m.163.com/nc/topicset/ios/subscribe/manage/listspecial.html")!)
        
        do {
            var json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: AnyObject]

            
            var channels = json["tList"] as! [[String: AnyObject]]
         
            //遍历数据
            for i in 0 ..< channels.count {
            
                 //字典转模型
                let channelModel = ChannelModel(dict: channels[i])
                
                arrM.append(channelModel)
            }
           //对模型中的tid进行排序
            arrM.sort(by: { (s1, s2) -> Bool in
            
                return s1.tid! < s2.tid!
            })
            
        }
        catch {
            
        }
        return arrM
    }
    
    
    
//   static func setTid(_ tid: String) {
//        self.tid = tid
//        self.urlString = "article/headline/\(tid)/0-20.html"
//    }
}
