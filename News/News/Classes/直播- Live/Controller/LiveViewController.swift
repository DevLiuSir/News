//
//  LiveViewController.swift
//  News
//
//  Created by Liu Chuan on 16/8/10.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import WebKit


private let liveCell = "liveCell"


class LiveViewController: UITableViewController {
    

    // MARK: - 懒加载
    
    /// 模型属性
    fileprivate lazy var live_Model: [LiveModel] = [LiveModel]()
    
    
    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        requstData()
        
    }
    
    /// 配置UI界面
    private func configUI() {
        
        // 设置导航栏背景色
        navigationController?.navigationBar.barTintColor = darkGreen
        // 修改导航栏文字颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // 注册cell
        tableView.register(UINib(nibName: "LiveViewCell", bundle: nil), forCellReuseIdentifier: liveCell)
        
        // 取消分割线
        tableView.separatorStyle = .none
        
    }
}



// MARK: - 重写 UITableView 数据源协议方法
extension LiveViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return live_Model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: liveCell, for: indexPath) as! LiveViewCell
        cell.lives = live_Model[indexPath.row]
        return cell
        
    }
    
}


// MARK: - 重写 UITableViewDelegate 协议方法
extension LiveViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 取出模型, 根据模型判断, 当前选择的ID
        let selected_Cell = live_Model[indexPath.row]
        
        // newsID: MbvFHp5I8umuqe0K-0-yizhibo
        //链接:  http://m.yizhibo.com/l/MbvFHp5I8umuqe0K.html
        
        
        var id = selected_Cell.newsId
        // 删除后面10个字符, 为链接
        let id2 = id.index(id.endIndex, offsetBy: -10)..<id.endIndex
        id.removeSubrange(id2)
        
        // MARK: 创建新控制器
        let vc = UIViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
       
        
        // MARK: 创建WKWebView
        let webView = WKWebView(frame: vc.view.frame)
        
        
        // 设置访问的URL
        // 1.URL定位资源, 需要的资源的地址
        let url = NSURL(string: "http://m.yizhibo.com/l/\(id).html")
        
        // 根据URL创建请求
        // 2.把URL发送给服务器。请求从url请求数据
        let requst = NSMutableURLRequest(url: url as! URL)
        
        // 设置请求方法为POST
        requst.httpMethod = "GET"
        
        // WKWebView加载请求
        // 3.发送请求数据
        webView.load(requst as URLRequest)
        
        //手指往下拖动，会露出灰色空背景
        //禁用UIWebView和WKWebView的下拉拖动效果
        webView.scrollView.bounces = false
        
        // 简写
        //  webView.load(URLRequest(url: URL(string: "http://m.yizhibo.com/l/\(id).html")!))
        
        // 将WKWebView添加到视图
        vc.view.addSubview(webView)
    
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


// MARK: - 请求数据
extension LiveViewController {
    
    /// 请求数据
    fileprivate func requstData() {
        
        NetworkTool.requsetData("http://newsapi.sina.cn/?resource=bn/colList&accessToken=&chwm=3023_0001&city=&connectionType=2&deviceId=6df85e6f7f2f25ce31764b263224a472d8734d82&deviceModel=apple-iphone6&from=6060193012&idfa=F4E014BE-2F8A-407C-97E6-B77F5002C6C4&idfv=4B048203-4CBB-4E66-891A-BE940DB48AA4&imei=6df85e6f7f2f25ce31764b263224a472d8734d82&location=0.000000%2C0.000000&osVersion=10.2&resolution=750x1334&sfaId=6df85e6f7f2f25ce31764b263224a472d8734d82&ua=apple-iphone6__SinaNews__6.0.1__iphone__10.2&weiboSuid=&weiboUid=&wm=b207&rand=983&urlSign=f409f5a614&columnId=beauty&page=1", type: .get)  {
            (result: Any) in
            
            
//            print(result)
            
            // 将 Any 类型转换成字典类型
            guard let resultDictionary = result as? [String : Any] else { return }
            
            // 根据 data 的 key 取出内容
            guard let dataArray = resultDictionary["data"] as? [String : Any] else { return }
            
            // 根据 feed 的 key 取出内容
            guard let dataResult = dataArray["feed"] as? [[String : Any]] else { return }
            
            
            // 遍历字典, 将字典转换成模型对象
            for dict in dataResult {
                self.live_Model.append(LiveModel(dict: dict))
            }
            // 刷新表格
            self.tableView.reloadData()
            
        }
    }
}


// MARK: - 显示\隐藏 导航栏
extension LiveViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY: CGFloat = scrollView.contentOffset.y
        
        print("直播------\(offsetY)")
        
        if offsetY > 0  {
            
            guard offsetY >= 44 else {
                setNavigationBarTransformProgress(progress: offsetY / 44)
                return
            }
            setNavigationBarTransformProgress(progress: 1)
            
        }else {
            setNavigationBarTransformProgress(progress: 0)
        }
    }
    
    func setNavigationBarTransformProgress(progress: CGFloat) {
        
        UIView.animate(withDuration: 0.25) {
            self.navigationController?.navigationBar.lc_setTranslationY(translationY: -44 * progress)
            self.navigationController?.navigationBar.lc_setElementsAlpha(alpha: 1-progress)
            
        }
    }

}

