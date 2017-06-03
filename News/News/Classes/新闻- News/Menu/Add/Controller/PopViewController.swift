//
//  PopViewController.swift
//  News
//
//  Created by Liu Chuan on 2016/9/25.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


/// 重用标识符
private let cellID = "cellID"

class PopViewController: UITableViewController {
    
    
    // MARK: - 属性
    
    /// 定义一个数组,存储表格视图的数据\Icon
    var dataArray: [Array<String>] {
        let array = [["扫一扫", "扫码"],["反馈", "反馈"]]
        return array
    }

    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTabelView()
    }
    
    
    /// 配置TableView
    private func configTabelView() {
        // 设置tableView相关属性
        preferredContentSize = CGSize(width: 150, height: 88)
        
        // 设置行高
        tableView.rowHeight = 44
        
        // 禁止TableView滚动
        tableView.isScrollEnabled = false
        
        // 设置tableView的分割线 边距
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        // 注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
    }
}



// MARK: - 重写 UITableViewDataSource
extension PopViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row][0]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.imageView?.image = UIImage(named: dataArray[indexPath.row][1])
        return cell
        
    }

}

// MARK: - 重写 UITableViewDelegate
extension PopViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 选中cell 动画
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(dataArray[indexPath.row])
        
        
        if indexPath.row == 0 {
            
            // 获取storyboard 二维码控制器
            let storyBoard = UIStoryboard(name: "QRCodeController", bundle: nil)
            
            let qrcVC = storyBoard.instantiateInitialViewController()
            
            // motal展现
            present(qrcVC!, animated: true, completion: nil)
            // 非 motal 展现
//            _ = navigationController?.pushViewController(qrcVC!, animated: true)

        }
        
    }
    
}
