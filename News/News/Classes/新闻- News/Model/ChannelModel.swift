//
//  Channel.swift
//  News
//
//  Created by Liu Chuan on 2016/12/31.
//  Copyright © 2016年 LC. All rights reserved.
//

import Foundation
//import SwiftyJSON

// MARK: - 频道列表模型
class ChannelModel : NSObject {
    
    /// 新闻ID
    var tid: String?
    
    /// 新闻频道标题
    var tname: String?
    
    var urlString: String?
    
    var topicid: String?
    
    var cid: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
 
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    /// 通过json文件加载标题按钮
    static func channels() -> [ChannelModel] {
        
        /// 定义变量, 存储模型数组
        var arrM = [ChannelModel]()
        
        // MARK: - try?: 弱try   如果解析成功, 就有值, 否则为nil
        
        // 加载 json 文件
        //let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "topic_news", ofType: "json")!))
        
        // 加载URL
        let data = try? Data(contentsOf: URL(string: "http://c.m.163.com/nc/topicset/ios/subscribe/manage/listspecial.html")!)
        
        // MARK: 反序列化 解析URL
        let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: AnyObject]
        
        // 根据 tList 的 key 取出内容
        let channels = json?["tList"] as! [[String: AnyObject]]

        
        // 遍历字典, 将字典转换成模型对象
        for i in 0 ..< channels.count {
            // 字典转模型
            let channelModel = ChannelModel(dict: channels[i])

            // 添加到数组中
            arrM.append(channelModel)
        }
      
        //对模型中的tid进行排序
        arrM.sort(by: { (s1, s2) -> Bool in

            //return s1.tid! < s2.tid!
            //return s1.topicid! < s2.topicid!
            return s1.cid! < s2.cid!
        })
        return arrM
    }
    
    
}

        
//      let channels = json?["tList"] as! [[String: AnyObject]]
//        do {
//            
//            var json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: AnyObject]
// 
//            // 根据 tList 的 key 取出内容
//            let channels = json?["tList"] as! [[String: AnyObject]]
//
//             // 遍历字典, 将字典转换成模型对象
//            for i in 0 ..< channels.count {
//            
//                 //字典转模型
//                let channelModel = ChannelModel(dict: channels[i])
//                
//                // 添加到数组中
//                arrM.append(channelModel)
//            }
//           //对模型中的tid进行排序
//            arrM.sort(by: { (s1, s2) -> Bool in
//            
////                return s1.tid! < s2.tid!
////                return s1.topicid! < s2.topicid!
//                return s1.cid! < s2.cid!
//            })
//            
//        }
//        catch {
//            
//        }
//        return arrM
//    }
//}
