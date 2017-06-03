//
//  VedioViewController.swift
//  News
//
//  Created by Liu Chuan on 16/8/10.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

private let vedioCell = "vedioCell"


class VedioViewController: UITableViewController {
    
    
    // MARK: - 懒加载
    /// 模型属性
    fileprivate lazy var vedio_Model: [VedioModel] = [VedioModel]()

    
    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configUI()
        
        requstData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    /// 配置UI界面
    private func configUI() {
        
        // 设置导航栏背景色
        navigationController?.navigationBar.barTintColor = darkGreen
        // 修改导航栏文字颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // 注册cell
        tableView.register(UINib(nibName: "VedioViewCell", bundle: nil), forCellReuseIdentifier: vedioCell)
        
        
    }

}



// MARK: - 重写 UITableView 数据源协议方法
extension VedioViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vedio_Model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: vedioCell, for: indexPath) as! VedioViewCell
        
        cell.vedios = vedio_Model[indexPath.row]
        
        return cell
        
    }
    
}


// MARK: - 重写 UITableViewDelegate 协议方法
extension VedioViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 取出模型, 根据模型判断, 当前选择的ID
        let selected_Cell = vedio_Model[indexPath.row]
        
        let id = selected_Cell.gid
        
        let vc = UIViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        
        let webview = UIWebView(frame: vc.view.frame)
        
        //简写
        // webview.loadRequest(URLRequest(url: URL(string: "http://p.m.btime.com/detail?id=22n8cjvh02lfr6orjkl8l0fclhh&url=http://item.btime.com/video/22n8cjvh02lfr6orjkl8l0fclhh")!))
        
        // 1.URL 定位资源 需要的资源的地址
        let url = URL(string: "http://p.m.btime.com/detail?id=\(id)&url=http://item.btime.com/video/\(id)")

        // 2.把URL发送给服务器。请求从url请求数据
        let request = URLRequest(url: url!)

        //3.发送请求数据
        webview.loadRequest(request)
        
        vc.view.addSubview(webview)
        
        navigationController?.pushViewController(vc, animated: true)

    }
    
}



// MARK: - 请求数据
extension VedioViewController {
    
    /// 请求数据
    fileprivate func requstData() {
        
        NetworkTool.requsetData("http://api.app.btime.com/news/list?carrier=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A&channel=AppStore&cid=08340f06f74942d11bd6af3d74a8a06f&cname=%E7%B2%BE%E9%80%89&count=12&is_paging=1&net=wifi&net_level=1&offset=0&os=iPhone%206&os_type=iOS&os_ver=10.2&pid=2&pro=360news&protocol=1&refresh=1&refresh_type=1&sign=3ab63a2&timestamp=1489338113&token=B49FA4ABAA8A4804F5B0DF758131E0E8&ver=2.0.0", type: .get)  {
            (result: Any) in
            
            print(result)
            
            // 将 Any 类型转换成字典类型
            guard let resultDictionary = result as? [String : Any] else { return }
            
            // 根据 data 的 key 取出内容
            guard let dataArray = resultDictionary["data"] as? [[String : Any]] else { return }
            
            // 遍历字典, 将字典转换成模型对象
            for dict in dataArray {
                self.vedio_Model.append(VedioModel(dict: dict))
            }
            // 刷新表格
            self.tableView.reloadData()
            
        }
 
        
    }
    
    
}

// MARK: - 滑动隐藏导航栏
extension VedioViewController {
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        navigationController?.setNavigationBarHidden(velocity.y > 0, animated: true)
    }
}



