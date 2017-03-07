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

// MARK: - 内容视图 Cell
class ContentViewCell: UICollectionViewCell {
  
    var urlStr: String!
    
    var channel: String!
    var tid: String! {
        didSet {
            urlStr = "http://c.m.163.com/nc/article/\(tid)/0-20.html"
        }
    }

    
    // MARK: - 控件属性
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - 懒加载
    
    // MARK: - 模型属性
    fileprivate lazy var newsModels: [NewsModel] = [NewsModel]()
    fileprivate lazy var tidArray = ChannelModel.channels()
    
    
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
    
    
    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // 设置 UI
        setupUI()
        
        // 加载数据
        loadData()
        
    }
}


 // MARK: - 设置 UI
extension ContentViewCell {
    
    fileprivate func setupUI() {
        
        // 添加控件
        tableView.insertSubview(refresh_HeaderView, at: 0)
        tableView.tableHeaderView = cycle_View
        tableView.tableFooterView = refresh_FooterView
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // 注册 cell
        tableView.register(UINib(nibName: "NewViewCell", bundle: nil), forCellReuseIdentifier: BaseCell)
        tableView.register(UINib(nibName: "BigViewCell", bundle: nil), forCellReuseIdentifier: BigIdentify)
        tableView.register(UINib(nibName: "ThreeImagesViewCell", bundle: nil), forCellReuseIdentifier: ThreeIdentify)
        
        // 设置 tableView 底部\顶部内边距, 使Footer\ Header显示, 不反弹回去
        tableView.contentInset = UIEdgeInsets(top: titleViewH, left: 0, bottom: refresh_FooterViewHeight, right: 0)
 
    }
}

// MARK:- 网络数据的请求
extension ContentViewCell {
    fileprivate func loadData() {
 
        
        for i in 0 ..< tidArray.count {

           let title =  tidArray[i].tid!
            
            print(title)
        
        }
//            if  let a = ParseJson["tList"][i]["tid"].string {
            

               // print(ParseJson["tList"][a]["tid"].string)
        
                NetworkTool.requsetData("http://c.3g.163.com/nc/article/headline/\(tidArray[20].tid!)/0-140.html", type: .get)
                { (result: Any) in
      
                    
        //        NetworkTool.requsetData("http://c.m.163.com/nc/topicset/ios/subscribe/manage/listspecial.html", type: .get)
        //        { (result: Any) in
         
        //            print(result)
                    
                    // 将 Any 类型转换成字典类型
                    guard let resultDictionary = result as? [String : Any] else { return }
                    
                    // 根据 T1348649079062 的key 取出内容
        //            guard let dataArray = resultDictionary["T1348647853363"] as? [[String : Any]] else { return }
                    guard let dataArray = resultDictionary["\(self.tidArray[20].tid!)"] as? [[String : Any]] else { return }
          
                    // 遍历字典, 将字典转换成模型对象
                    for dict in dataArray {
                        self.newsModels.append(NewsModel(dict: dict))
                    }
                    
                    // 刷新表格
                    self.tableView.reloadData()
                }
                
        
         
            }
        }
        

// MARK: - 遵守 UItableView 数据源协议
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
        
        if news.imgextra?.count == 2 {          // 三张图
            identifier = ThreeIdentify
        } else if news.imgType == 1 {           // 大图
            identifier = BigIdentify
        } else {                               // 基本样式
            identifier = BaseCell
        }
        
//        let cell = NewViewCell.cell(withIdentifier: identifier, for: indexPath, tableView: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)  as! NewViewCell
        cell.newModel = news
        return cell
    }
    
}


// MARK: - 遵守 UItableView 代理协议
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
}
    
 /*
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
//        self.navigationController?.pushViewController(detailVC, animated: true)
        

    }
*/



