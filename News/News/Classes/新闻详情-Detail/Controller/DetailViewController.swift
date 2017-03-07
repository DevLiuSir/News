//
//  DetailViewController.swift
//  News
//
//  Created by Liu Chuan on 2017/1/1.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit
    
// MARK: - 详情控制器
class DetailViewController: UIViewController {
    

    @IBOutlet weak var webView: UIWebView!
    
    var detail_ : DetailViewModel?


    override func viewDidLoad() {
        super.viewDidLoad()

        
//        loadData()
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
}





// MARK:- 请求网络数据
extension DetailViewController {
    
    fileprivate func loadData() {
/*
        NetworkTool.requsetData("http://c.m.163.com/nc/article/CA3TQ4EQ00097U7T/full.html", type: .get)
        { (result: Any) in
            
//            print(result)
            
            // 将 Any 类型转换成字典类型
            guard let resultDictionary = result as? [String : Any] else { return }
            
            // 根据 BUCHPIS100963VRO 的key 取出内容
            guard let dataArray = resultDictionary["CA3TQ4EQ00097U7T"] as? [[String : Any]] else { return }
            
            // 遍历字典, 将字典转换成模型对象
            for dict in dataArray {
                
                self.detail_.append(DetailViewModel(dict: dict))
            }
            
            // 刷新表格
          //  self.tableView.reloadData()
            
            
            // 构建 HTML界面
            self.build_HTML(detail: self.detail!)
        }
        
 */
       
        let urlString = "http://c.m.163.com/nc/article/CA3TQ4EQ00097U7T/full.html"

        let url = URL(string: urlString)
        
        let urlRequest = URLRequest(url: url!) as URLRequest
        
        webView.loadRequest(urlRequest)
        
//        build_HTML(detail: detail_!)
        
        
        
    }
    
    // MARK: 构建 HTML界面
    func build_HTML(detail: DetailViewModel) {
        
        
        var htmlString = "<html>"
        
        
        htmlString.append("<head>")
        
        
        htmlString.append("<body>")
        
        
        htmlString.append(detail_!.body)
        
        
        

        htmlString.append("</body>")

        
        htmlString.append("</head>")
        
        
        htmlString.append("</html>")
        
        webView.loadHTMLString(htmlString, baseURL: nil)
        
    }

}
