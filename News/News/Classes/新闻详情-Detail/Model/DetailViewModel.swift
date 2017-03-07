//
//  DetailViewModel.swift
//  News
//
//  Created by Liu Chuan on 2017/1/1.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class DetailViewModel: NSObject {

    
    var title       : String = ""  // 新闻标题
    var ptime       : String = ""  // 新闻发布时间
    var replyBoard  : String = ""  // 模块名
    var body        : String = ""  // 新闻内容
    var replyCount = 0             // 回复数
    var img = [Any]()              // 新闻配图(希望这个数组中以后放HMNewsDetailImg模型)
    
  
    var temArray = [Any]()
    
    // MARK: 定义字典转模型的构造函数
    init(dict : [String : Any]) {
        super.init()
        
        // 将字典里面的每一个key的值赋值给对应的模型属性
        setValuesForKeys(dict)
        
        var detail: DetailViewModel? {
            
            didSet {
                detail!.title        = dict["title"]        as! String
                detail!.ptime        = dict["ptime"]        as! String
                detail!.body         = dict["body"]         as! String
                detail!.replyBoard   = dict["replyBoard"]   as! String
                detail!.replyCount   = dict["replyCount"]   as! Int
                detail!.img          = dict["img"]          as! [Any]
            }
            
        
        }
           
//        for dict in img {
//            let imgModel : DetailViewModel = DetailViewModel(dict: dict as! [String : Any])
//            temArray.append(imgModel)
//        }
//            detail?.img = temArray

    }
    
   
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
  
    
}
 
 
 
