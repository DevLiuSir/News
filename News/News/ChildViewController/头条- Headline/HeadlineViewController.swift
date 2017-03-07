//
//  HeadlineViewController.swift
//  News
//
//  Created by Liu Chuan on 16/8/4.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import SwiftyJSON


// MARK: 定义全局常量
private let identify = "BaseCell"
private let bigIdentify = "BigViewCell"
private let ThreeIdentify = "ThreeImagesViewCell"

class HeadlineViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - 模型属性
    fileprivate lazy var newsModels: [NewsModel] = [NewsModel]()
    
    fileprivate lazy var detaiModels: [DetailViewModel] = [DetailViewModel]()
    
    
    // MARK: - 懒加载CycleView对象: 轮播视图
    fileprivate lazy var cycle_View : CycleView = {
        
        let cycle_View = CycleView.Load_CycleView()
        cycle_View.frame = CGRect(x: 0, y: -CycleViewHeight, width: screenW, height: CycleViewHeight)
        return cycle_View
    }()

    // MARK: - 刷新头部视图
    fileprivate lazy var refresh_HeaderView: LCRefreshHeaderView = {
        
        var refresh_HeaderView = LCRefreshHeaderView.Load_Refresh_HeaderView()
        refresh_HeaderView.frame = CGRect(x: 0, y: -refresh_HeaderViewHeight, width: screenW, height: refresh_HeaderViewHeight)
        refresh_HeaderView.backgroundColor = UIColor.white
        return refresh_HeaderView
    }()
    
    
    // MARK: - 刷新底部视图
    fileprivate lazy var refresh_FooterView: LCRefreshFooterView = {
        // 没有大小的 FooterView
        var refresh_FooterView = LCRefreshFooterView.Load_Refresh_FooterView()
        refresh_FooterView.backgroundColor = UIColor.white
        return refresh_FooterView
    }()

    
    // MARK: - 表格视图 tableView
    fileprivate lazy var tableView: UITableView = {[unowned self] in
        
        // 创建 UITableView, 并设置其相关属性
//        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Int(screenW), height: Int(screenH - statusH - navigationH - titleViewH - scrollLineH)))

        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        
        // 设置表格视图的行高
        //tableView.rowHeight = 90
//        tableView.dataSource = self
        tableView.delegate = self
        
        // 注册 cell
        tableView.register(UINib(nibName: "NewViewCell", bundle: nil), forCellReuseIdentifier: identify)
        tableView.register(UINib(nibName: "BigViewCell", bundle: nil), forCellReuseIdentifier: bigIdentify)
        tableView.register(UINib(nibName: "ThreeImagesViewCell", bundle: nil), forCellReuseIdentifier: ThreeIdentify)
        // 设置 tableView 底部内边距, 使Footer显示, 不反弹回去
        tableView.contentInset = UIEdgeInsets(top: titleViewH, left: 0, bottom: tabBarH + refresh_FooterViewHeight, right: 0)
        
        return tableView
        
        }()

    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI界面
        setupUI()
        
        // 请求数据
        loadData()
        
        
    }

   // MARK: - 显示\隐藏 导航栏
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // false: 向下    true: 向上
        var scroll_Up_Or_Down : Bool = false
        
        //定义起初 Y 轴偏移量
        var newY : CGFloat = 0
        var oldY : CGFloat = 0
        
        //获取当前滚动视图的contentOffset.y
        newY = self.tableView.contentOffset.y
        
        //判断滚动视图向上还是向下
        if newY != oldY && newY > oldY {
           
            scroll_Up_Or_Down = true
            
        } else if newY < oldY {
            
            scroll_Up_Or_Down = false
        
        } else  {
            
            oldY = newY
        }
        
        
        //定义初始的navigationBar的位置
        if newY == -60 {
            
            UIView.animate(withDuration: 1, animations: {
                self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: screenW, height: navigationH)
            })
            
        }else {
            
            if scroll_Up_Or_Down == true {  // 向上, 隐藏
                
                UIView.animate(withDuration: 1, animations: {
                    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: -40, width: screenW, height: navigationH + statusH)
                    self.navigationController?.navigationBar.lc_setElementsAlpha(alpha: 0) // 导航栏图片透明
                    
                })
                
            } else if scroll_Up_Or_Down == false { // 向下, 显示
        
                UIView.animate(withDuration: 0.5, animations: {
                    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: screenW, height: navigationH)
                   
                    self.navigationController?.navigationBar.lc_setElementsAlpha(alpha: 1) // 导航栏图片不透明
                })
            }
        }
    }
    
    
    

}


    
 // MARK: - 设置UI界面
extension HeadlineViewController {
    
    fileprivate func setupUI() {
        
        // 添加控件
        view.addSubview(tableView)
        tableView.insertSubview(refresh_HeaderView, at: 0)
        tableView.tableHeaderView = cycle_View
        tableView.tableFooterView = refresh_FooterView
    }
    
}


// MARK:- 网络数据的请求
extension HeadlineViewController {
    fileprivate func loadData() {
        NetworkTool.requsetData("http://c.3g.163.com/nc/article/headline/T1348647853363/0-140.html", type: .get)
        { (result: Any) in
            
            //print(result)
            
            // 将 Any 类型转换成字典类型
            guard let resultDictionary = result as? [String : Any] else { return }
            
            // 根据 T1348649079062 的key 取出内容
            guard let dataArray = resultDictionary["T1348647853363"] as? [[String : Any]] else { return }
            
            // 遍历字典, 将字典转换成模型对象
            for dict in dataArray {
                
                self.newsModels.append(NewsModel(dict: dict))
            }
            
            // 刷新表格
            self.tableView.reloadData()
        }
        
    }
    
}

/*
// MARK:- 实现 UITableView 数据源协议
extension HeadlineViewController: UITableViewDataSource {
    
    // 有多少组数据
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return newsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // 取出模型, 根据模型判断模型的样式
        let news = newsModels[indexPath.row]

        if news.imgType == 1 {                   // 大图
            
            let bigCell = tableView.dequeueReusableCell(withIdentifier: bigIdentify, for: indexPath) as! BigViewCell
            bigCell.newModel = newsModels[indexPath.row]
            return bigCell
            
        } else if news.imgextra?.count == 2 {   // 三张图
        
            let threeCell = tableView.dequeueReusableCell(withIdentifier: ThreeIdentify, for: indexPath) as! ThreeImagesViewCell
            threeCell.newModel = newsModels[indexPath.row]
            return threeCell
            
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath) as! NewViewCell
            cell.newModel = newsModels[indexPath.row]
            return cell
        
        }
    }
    
    
}
*/

// MARK: - 实现 UItableView 代理协议
extension HeadlineViewController: UITableViewDelegate {
    
    // MARK: 设置tableView的cell的行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 取出模型, 根据模型判断模型的样式
        let news = newsModels[indexPath.row]
    
        if news.imgType > 0 {                  // 大图
            return 200
        } else if news.imgextra?.count == 2 {   // 三张图
            return 150
        } else {
            return 90
        }
    }
    
    // MARK: tableView 选中实现
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // 取出模型, 根据模型判断模型的样式
//        let news = detaiModels[indexPath.row]
        
        // 获取 storyboard
        let story = UIStoryboard(name: "DetailView", bundle: nil)
        
        // 通过 storyboard 中的标识符, 获取控制器
        let detailVC = story.instantiateViewController(withIdentifier: "Detail_ID") as! DetailViewController
        
        
        
//        detailVC.detail = detaiModels[indexPath.row]
        
//        detailVC.detail_ = detaiModels[indexPath.row]
        
        // push 呈现给控制器
        navigationController?.pushViewController(detailVC, animated: true)
        
//        navigationController?.setNavigationBarHidden(true, animated: true)
  
    }
}
