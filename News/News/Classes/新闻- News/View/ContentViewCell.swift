//
//  ContentViewCell.swift
//  News
//
//  Created by Liu Chuan on 2017/1/22.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

// MARK: - 重用标识符
private let BaseCell = "BaseCell"
private let BigIdentify = "BigViewCell"
private let ThreeIdentify = "ThreeImagesViewCell"


// MARK: - 内容视图Cell
class ContentViewCell: UICollectionViewCell {
    
    // MARK: - 控件属性
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - 懒加载:模型属性
    fileprivate lazy var newsModels: [NewsModel] = [NewsModel]()
    fileprivate lazy var detaiModels: [DetailViewModel] = [DetailViewModel]()
    
    
//    fileprivate lazy var messages = [NewsModel]()
    
    // 定义属性
    var tid: String? {
        
        // 监听模型改变
        didSet {
            NewsModel.messages(tid!) { (messages) in
                self.newsModels = messages
                self.tableView.reloadData()
                
                print("\(self.tid!)")
                // 如果tid的个数大于0 执行后面的语句
                guard self.newsModels.count > 0 else { return }
                
                //控制tableView 滚动到指定的某一行, 这里默认滚动到顶部
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
            }
            
        }
        
    }
    
/*
    var docid: String? {
        
        didSet {
            DetailViewModel.loadNewsDetailData(docid!) { (loadNewsDetailData) in
                
                self.detaiModels = [loadNewsDetailData]
                self.tableView.reloadData()
                
                print("\(self.docid)")
                
                
                // 如果tid的个数大于0 执行后面的语句
                guard self.detaiModels.count > 0 else { return }
                
                //控制tableView 滚动到指定的某一行, 这里默认滚动到顶部
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)

                
                
                
            }
        }
    }
*/
    
    /// 轮播视图
    fileprivate lazy var cycle_View : CycleView = {
        let cycle_View = CycleView.Load_CycleView()
        cycle_View.frame = CGRect(x: 0, y: -CycleViewHeight, width: screenW, height: CycleViewHeight)
        return cycle_View
    }()
    
    /// 刷新头部
    fileprivate lazy var refresh_HeaderView: LCRefreshHeaderView = {
        var refresh_HeaderView = LCRefreshHeaderView.Load_Refresh_HeaderView()
        refresh_HeaderView.frame = CGRect(x: 0, y: -refresh_HeaderViewHeight, width: screenW, height: refresh_HeaderViewHeight)
        refresh_HeaderView.backgroundColor = UIColor.white
        return refresh_HeaderView
    }()
    
    /// 刷新底部, 没有大小的FooterView
    fileprivate lazy var refresh_FooterView: LCRefreshFooterView = {
        var refresh_FooterView = LCRefreshFooterView.Load_Refresh_FooterView()
        refresh_FooterView.backgroundColor = UIColor.white
        return refresh_FooterView
    }()
    
    
    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setupUI()
    }
}


 // MARK: - 设置 UI
extension ContentViewCell {
    
    /// 设置UI界面
    fileprivate func setupUI() {
        // 添加控件
        tableView.insertSubview(refresh_HeaderView, at: 0)
        tableView.tableHeaderView = cycle_View
        tableView.tableFooterView = refresh_FooterView
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // 注册cell
        tableView.register(UINib(nibName: "NewViewCell", bundle: nil), forCellReuseIdentifier: BaseCell)
        tableView.register(UINib(nibName: "BigViewCell", bundle: nil), forCellReuseIdentifier: BigIdentify)
        tableView.register(UINib(nibName: "ThreeImagesViewCell", bundle: nil), forCellReuseIdentifier: ThreeIdentify)
        
        // 设置 tableView 底部\顶部内边距, 使Footer\ Header显示, 不反弹回去
        tableView.contentInset = UIEdgeInsets(top: titleViewH, left: 0, bottom: refresh_FooterViewHeight, right: 0)
        
        // 设置指示器的顶部间距
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: titleViewH, left: 0, bottom: 0, right: 0)
 
    }
}
// ===========
/*
// MARK: - 网络数据的请求
extension ContentViewCell {
    
    /// 请求数据
    fileprivate func loadData() {
 
        NetworkTool.requsetData("http://c.m.163.com/nc/topicset/ios/subscribe/manage/listspecial.html", type: .get)  {
            (result: Any) in
         
            //print(result)
            
            // 将 Any 类型转换成字典类型
            guard let resultDictionary = result as? [String : Any] else { return }
            
            // 根据 T1348649079062 的 key 取出内容
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
*/

// MARK: - 遵守 UITableViewDataSource 协议
extension ContentViewCell : UITableViewDataSource {
    
    // 有多少组数据
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModels.count
    }
    
    // 每组显示的具体内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        // 定义变量表示标识符
        var identifier = ""
        
        // 取出模型, 根据模型判断模型的样式
        let news = newsModels[indexPath.row]
        
        if news.imgextra?.count == 2 {   // 三张图
            identifier = ThreeIdentify
        } else if news.imgType == 1 {    // 大图
            identifier = BigIdentify
        } else {                         // 基本样式
            identifier = BaseCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)  as! NewViewCell
        cell.newModel = news
        return cell
    }
    
}

// MARK: - 遵守 UITableViewDelegate 协议
extension ContentViewCell : UITableViewDelegate {
    
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
        
        
//        let news = newsModels[tableView.indexPathForSelectedRow!.row]
        
//        let a = detaiModels[tableView.indexPathForSelectedRow!.row]
//         let news = detaiModels[indexPath.row]
        
        // 点击 cell, 闪烁动画
        tableView.deselectRow(at: indexPath, animated: true)
/*
        
        let webView = UIWebView(frame: contentView.bounds)
        let url = URL(string: "http://mini.eastday.com/mobile/170312205219332.html")
        webView.loadRequest(URLRequest(url: url!))
        contentView.addSubview(webView)
        */

        // 取出模型, 根据模型判断模型的样式
//        let news = newsModels[indexPath.row]
        
        
        // 获取 storyboard
        let story = UIStoryboard(name: "DetailView", bundle: nil)
        
        // 通过storyboard中的标识符, 获取控制器
        let detailVC = story.instantiateViewController(withIdentifier: "Detail_ID") as! DetailViewController
        
        
        // 初始化导航视图控制器对象, 并将 detailVC 作为 导航的 根视图控制器
        let nav = UINavigationController(rootViewController: detailVC)
        
        detailVC.view.backgroundColor = UIColor.orange
        
         // 将导航视图控制器对象,添加至当前窗口根视图.
        self.window?.rootViewController = nav
//        nav.pushViewController(detailVC, animated: true)
        

        
        //====================
 
        
//        contentView.addSubview(detailVC.view)

           //detailVC.detail_ = detaiModels[indexPath.row]
        
       // self.contentView.addSubview(detailVC.view)
       
        // push 呈现给控制器
//        self.navigationController?.pushViewController(detailVC, animated: true)
        

        }

    
}
