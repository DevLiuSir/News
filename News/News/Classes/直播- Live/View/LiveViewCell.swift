//
//  LiveViewCell.swift
//  News
//
//  Created by Liu Chuan on 2017/3/14.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class LiveViewCell: UITableViewCell {
    
    // MARK: - 控件属性
    @IBOutlet weak var titleLabel: UILabel!             // 内容标题
    @IBOutlet weak var startTimeStrLabel: UILabel!      // 持续时间
    @IBOutlet weak var onlineNumsLabel: UILabel!        // 参与人数
    @IBOutlet weak var iconImageView: UIImageView!      // 图片
    
    
    // MARK: - 定义模型属性
    var lives: LiveModel? {
        // 监听模型改变
        didSet {
          
            
            // 设置基本信息
            titleLabel.text = lives?.title
            startTimeStrLabel.text = lives?.liveInfo?["startTimeStr"]  as? String
            
            // 当文字超出标签的宽度，会被隐藏一部分，如果不想文字被隐藏
            onlineNumsLabel.adjustsFontSizeToFitWidth = true
            
            //onlineNumsLabel.text = lives?.liveInfo?["onlineNums"] as? String
            
            lives?.onlineNums = (lives?.liveInfo!["onlineNums"] as? Int)!
            onlineNumsLabel.text = "\(lives?.onlineNums ?? 0)"
            

            // 设置图片
            let iconURL = URL(string: lives?.pic ?? "")
            // 圆角
            iconImageView.layer.cornerRadius = 10
            iconImageView.layer.masksToBounds = true
            iconImageView.kf.setImage(with: iconURL)
        }
    }

}
