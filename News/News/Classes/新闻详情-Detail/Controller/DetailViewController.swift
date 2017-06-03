//
//  DetailViewController.swift
//  News
//
//  Created by Liu Chuan on 2017/1/1.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit
import WebKit
    
// MARK: - 详情控制器
class DetailViewController: UIViewController {
    

    @IBOutlet weak var webView: UIWebView!
    
    fileprivate var details: [DetailViewModel] = [DetailViewModel]()
    
    
    var detailModel: DetailViewModel? {
        didSet {
            
        }
    }
    
    //
    //如果需要传值的话，调用这个方法
    
    // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    
    //  var theSegue = segue.destinationViewController as! Test1
    
    
    //   let navigationEdit = segue.destinationViewController as! UINavigationController
    
    //   let viewContrEdit = navigationEdit.topViewController as! Test1
    
    
    
    //  }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        let src = segue.source
        let dst = segue.destination
        src.navigationController?.pushViewController(dst, animated: true)
        
        
        
//        
//        let ide = segue.identifier
//        if ide == "Detail_ID" {
//            print(segue.destination)
//            print(segue.source)
//            let oneVC = segue.destination as! DetailViewController
//
//        }

        
//        let  TheSegue = segue.destination as! DetailViewController
//        let navSegur = segue.destination as! UINavigationController
    }
    
    
    
    
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
         let web = WKWebView(frame: view.bounds)
         let url = URL(string: "http://mini.eastday.com/mobile/170312205219332.html")
         web.load(URLRequest(url: url!))
         view.addSubview(web)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        loadData()
    }
    
}





// MARK:- 请求网络数据
extension DetailViewController {
    
    fileprivate func loadData() { //http://c.m.163.com/nc/article/CA3TQ4EQ00097U7T/full.html
        
        

        NetworkTool.requsetData("http://c.m.163.com/nc/article/\(detailModel?.docid)/full.html", type: .get)
        { (result: Any) in
            
            print(result)
            
            
            // 将 Any 类型转换成字典类型
//            guard let resultDictionary = result as? [String : Any] else { return }
            
            // 根据 BUCHPIS100963VRO 的key 取出内容
//            guard let dataArray = resultDictionary["CA3TQ4EQ00097U7T"] as? [[String : Any]] else { return }
            
            // 遍历字典, 将字典转换成模型对象
//            for dict in dataArray {
            
//                self.details.append(DetailViewModel(dict: dict))
//            }
            
            // 刷新表格
          //  self.tableView.reloadData()
            
            
            // 构建 HTML界面
//            self.build_HTML(detail: self.details!)
        }
        
 
   
        //http://3g.163.com/touch/article.html?channel=news&child=all&offset=2&docid=CFM1III20001899O
//        
//        let urlString = "http://c.m.163.com/nc/article/CA3TQ4EQ00097U7T/full.html"
//
//        let url = URL(string: urlString)
//        
//        let urlRequest = URLRequest(url: url!) as URLRequest
//        
//        webView.loadRequest(urlRequest)
//        

        
//        let str = "http://c.m.163.com/nc/article/\(details?.docid)/full.html"
        
        
        
//        build_HTML(detail: details!)
        
        
        
    }
    
//    // MARK: 构建 HTML界面
//    func build_HTML(detail: DetailViewModel) {
//        
//        var htmlString = "<html>"
//        
//        // 拼接HTML\head\body
//        
//        // css\js都在head里面
//        htmlString.append("<head>")
//        htmlString.append("<body>")
//        htmlString.append(detail.body)
//        htmlString.append("</body>")
//        htmlString.append("</head>")
//        htmlString.append("</html>")
//        
//       
//        
//        let urlString =  URL(string: "http://c.m.163.com/nc/article/CA3TQ4EQ00097U7T/full.html")
//        
//        webView.loadHTMLString(htmlString, baseURL: urlString!)
//        
//    }

}
