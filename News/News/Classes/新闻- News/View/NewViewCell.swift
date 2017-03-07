//
//  NewViewCell.swift
//  网易新闻
//
//  Created by Liu Chuan on 2016/11/10.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import Kingfisher


class NewViewCell: UITableViewCell {

    // MARK: - 控件属性
    @IBOutlet weak var iconImageView: UIImageView!  // 图片
    @IBOutlet weak var titleLabel: UILabel!         // 内容标题
    @IBOutlet weak var sourceLabel: UILabel!        // 来源
    @IBOutlet weak var replyCountLabel: UILabel!    // 回复数/跟帖
    @IBOutlet var extraImages: [UIImageView]!       //另外二张图
    
    
    
    static func cell(withIdentifier identifier: String, for indexPath: IndexPath, tableView: UITableView) -> NewViewCell {

//    static func cell(_ identifier: String, tableView: UITableView) -> NewViewCell  {
//        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NewViewCell
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NewViewCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed(identifier, owner: nil, options: nil)?.first as? NewViewCell
        }
        return cell!
    }
    
    // MARK: - 定义模型属性
    var newModel: NewsModel? {
        // 监听模型改变
        didSet {
            
            // 设置基本信息
            titleLabel.text = newModel?.title                        // 内容标题
            sourceLabel.text = newModel?.source                      // 来源
            replyCountLabel.text = "\(newModel?.replyCount ?? 0)跟帖" // 回复数/跟帖数
            
            // 设置图片
            let iconURL = URL(string: newModel?.imgsrc ?? "")
            iconImageView.kf.setImage(with: iconURL)
            
            guard extraImages != nil else { return }
            
            for i in 0 ..< extraImages.count {                  // 另外二张图
                
                let iv = extraImages[i]
                
                iv.kf.setImage(with: URL(string: (newModel?.imgextra?[i]["imgsrc"])! as! String))
            }
            
        }
        
    }
    
}

