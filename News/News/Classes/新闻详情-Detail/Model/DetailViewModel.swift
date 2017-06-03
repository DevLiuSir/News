//
//  DetailViewModel.swift
//  News
//
//  Created by Liu Chuan on 2017/1/1.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailViewModel: NSObject {
//    
//    var title       : String = ""  // 新闻标题
//    var ptime       : String = ""  // 新闻发布时间
//    var replyBoard  : String = ""  // 模块名
//    var body        : String = ""  // 新闻内容
//    var replyCount           = 0   // 回复数
//    var img         : [Any]  = []  // 新闻配图(希望这个数组中以后放HMNewsDetailImg模型)
    var docid       : String = ""
  
//    var temArray = [Any]()
    
    
//    class func detail(withDict dict: [String: Any]) -> DetailViewModel {
//        let detail = DetailViewModel()
//        
//        detail.title = (dict["title"] as? String) ?? ""
//        detail.ptime = (dict["ptime"] as? String) ?? ""
//        detail.body = (dict["body"] as? String) ?? ""
//        detail.replyBoard = (dict["replyBoard"] as? String) ?? ""
//        if let count = dict["replyCount"] as? NSNumber {
//            detail.replyCount = count.intValue
//        } else {
//            detail.replyCount = 0
//        }
//
//        var tempArray = [DetailImgEntity]()
//        let imgArray = dict["img"] as! Array<[String: String]>
//        
//        for d in imgArray {
//            let imgModel = DetailImgEntity.detailImg(withDict: d)
//            tempArray.append(imgModel)
//        }
//        detail.imgs = tempArray
        
//        return detail
//    }

    
    
    
    
    
    // MARK: 定义字典转模型的构造函数
    init(dict : [String : Any]) {
        super.init()
        
        // 将字典里面的每一个key的值赋值给对应的模型属性
        setValuesForKeys(dict)

//        var detail: DetailViewModel? {
//
//            didSet {
//        
//                detail?.title        = dict["title"]        as! String
//                detail!.title        = dict["title"]        as! String
//                detail!.ptime        = dict["ptime"]        as! String
//                detail!.body         = dict["body"]         as! String
//                detail!.replyBoard   = dict["replyBoard"]   as! String
//                detail!.replyCount   = dict["replyCount"]   as! Int
//                detail!.img          = dict["img"]          as! [Any]
//                detail?.docid        = dict["docid"]        as! String
        
//                let array = Array(repeating: img.count, count: img.count)
                
//            }
//        }
    }

    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
  
    static func loadNewsDetailData(_ docid: String, completionHandler: ((DetailViewModel) -> Void)?) {
        
        
        let tools = Tool.sharedTool()
        
        tools.get("article/\(docid)/full.html", parameters: nil, progress: nil, success: { (task, obj) -> Void in
            
            // 根据 tid 的 key 取出内容
            var messages = (obj as! [String: AnyObject])[docid] as! [[String: AnyObject]]

            var arrayM = [DetailViewModel]()
        
            for i in 0 ..< messages.count {
                
                let news = DetailViewModel(dict: messages[i])
                arrayM.append(news)
                
            }

            // 回调传值给arrM
//            completionHandler!(arrayM)
            
        }) { (task, error) -> Void in
            
        }
        
    }
    
    
//    static func loadNewsDetailData(_ docid: String, completionHandler: @escaping (DetailViewModel) -> Void) {
//        let urlStr = "http://c.m.163.com/nc/article/\(docid)/full.html"
    
//        Alamofire.request(.GET, urlStr).responseJSON { (response) -> Void in
//            guard response.result.error == nil else {
//                print("loadNewsDetailData error!")
//                completionHandler(nil)
//                return
//            }
//            
//            let data = JSON(response.result.value!)
//            let news = data[docid]
//            
//            let newsDetailModel = NewsDetailModel(json: news)
//            completionHandler(newsDetailModel)
//        }
//        
        
//            let data = JSON(response.result.value!)
//            let news = data[docid]
//            let model = DetailViewModel(dict: news)
//            
        
//    }
    
}
 
 
 
