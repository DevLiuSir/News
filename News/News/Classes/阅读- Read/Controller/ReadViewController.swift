//
//  ReadViewController.swift
//  News
//
//  Created by Liu Chuan on 16/8/10.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import WebKit

class ReadViewController: UIViewController {

//    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏背景色
        navigationController?.navigationBar.barTintColor = darkGreen
        //修改导航栏文字颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        configUI()
    }

    
    
    /// 配置UI
    private func configUI(){
        
//        // 1.URL 定位资源 需要的资源的地址
//        let url = URL(string: "http://ih2.ireader.com/zybook4/app/iphone.php?usr=i1141220689&rgt=7&p1=642B86E00EA24BD8824EF3535237822D&p2=111010&p3=662007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p16=iPhone7%2C2&p21=10103&p22=iOS%2C10.2&zyeid=2e94d2511ab74b93a46c65fe16871be2&pk=17B11248128&pca=bookshelf&ca=search.TagList&idfa=F4E014BE-2F8A-407C-97E6-B77F5002C6C4&currentPage=1&keyword=%E7%B2%BE%E9%80%89&attr=1326&complete=Y")
//        
//        // 2.把URL发送给服务器。请求从url请求数据
//        let request = URLRequest(url: url!)
//        
//        //3.发送请求数据
//        webView.loadRequest(request)
//        
        
        
        // 创建WKWebView
        let webView = WKWebView(frame: UIScreen.main.bounds)
        
        
        // 设置访问的URL
        // 1.URL 定位资源 需要的资源的地址
        let url = NSURL(string: "http://ih2.ireader.com/zybook4/app/iphone.php?usr=i1141220689&rgt=7&p1=642B86E00EA24BD8824EF3535237822D&p2=111010&p3=662007&p4=501607&p5=1001&p6=AAAAAAAAAAAAAAAAAAAA&p7=AAAAAAAAAAAAAAA&p9=0&p11=584&p16=iPhone7%2C2&p21=10103&p22=iOS%2C10.2&zyeid=2e94d2511ab74b93a46c65fe16871be2&pk=17B11248128&pca=bookshelf&ca=search.TagList&idfa=F4E014BE-2F8A-407C-97E6-B77F5002C6C4&currentPage=1&keyword=%E7%B2%BE%E9%80%89&attr=1326&complete=Y")
        
        
        // 根据URL创建请求
        let requst = NSMutableURLRequest(url: url as! URL)
        
        // 设置请求方法为POST
        requst.httpMethod = "GET"
       
        // WKWebView加载请求
        // 2.把URL发送给服务器。请求从url请求数据
        webView.load(requst as URLRequest)
        
        
        // 将WKWebView添加到视图
        view.addSubview(webView)
        
        
    }
    
}
