//
//  VedioViewCell.swift
//  News
//
//  Created by Liu Chuan on 2017/3/13.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit
import Kingfisher

class VedioViewCell: UITableViewCell {
    
    
    // MARK: - 控件属性
    @IBOutlet weak var iconImageView: UIImageView!  // 图片
    @IBOutlet weak var playImageView: UIImageView!  // 图片
    @IBOutlet weak var titleLabel: UILabel!         // 内容标题
    @IBOutlet weak var durationLabel: UILabel!      // 持续时间
    @IBOutlet weak var sourceLabel: UILabel!        // 来源
    
    // MARK: - 定义模型属性
    var vedios: VedioModel? {
        // 监听模型改变
        didSet {
            
            // 设置基本信息
            titleLabel.text = (vedios?.data?["title"])! as? String
            sourceLabel.text = (vedios?.data?["source"])! as? String
            durationLabel.text = vedios?.data?["duration"] as? String
            
            // 圆角
            durationLabel.layer.cornerRadius = 3
            durationLabel.layer.masksToBounds = true
            
            // 设置图片
            // 圆角
            iconImageView.layer.cornerRadius = 10
            iconImageView.layer.masksToBounds = true
            
            let ve = vedios?.data?["covers"] as! [String]
            let iconStr = ve[0]
            let iconURL = URL(string: iconStr)
            iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "_cycleview_loadingimage"))
        }
    }
    
}
