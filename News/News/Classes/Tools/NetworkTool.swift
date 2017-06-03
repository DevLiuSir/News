//
//  NetworkingTool.swift
//  
//
//  Created by Liu Chuan on 2016/11/9.
//
//

import UIKit
import Alamofire

// MARK:- 封装工具类

// 请求方式
enum MethodType {
    case get
    case post
}

class NetworkTool {
    
    class func requsetData(_ URLString: String, type: MethodType, parameters: [String: Any]? = nil, finishedCallback: @escaping (_ result: Any) -> ()) {

        //MARK: 状态栏是否显示风火轮
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ProgressHUD.show()
        
      
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
             ProgressHUD.dismiss()
            
            // 效验是否有结果
//            if let result = response.result.value {
//                finishedCallback(result)
//
//            } else {
//                print(response.result.error!)
//            }

            // 1.校验是否有结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 2.将结果回调出去
            finishedCallback(result)
        
            
        }
      
    }


}
