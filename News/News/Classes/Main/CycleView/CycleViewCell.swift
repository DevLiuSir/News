//
//  CycleViewCell.swift
//  News
//
//  Created by Liu Chuan on 2016/12/27.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import Kingfisher

class CycleViewCell: UICollectionViewCell {

    
    // MARK: - 控件属性
    @IBOutlet weak var iconImageView: UIImageView!      // 图片
    @IBOutlet weak var titleLabel: UILabel!             // 标题
    
    
    // MARK: 定义模型属性
    var cycleModel : CycleViewModel? {
       
        // 监听模型改变
        didSet {
            
            titleLabel.text = cycleModel?.title
            
            // 设置图片
            let iconURL = URL(string: cycleModel?.imgsrc ?? "")
            iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "_cycleview_loadingimage"))
    
        }
    }
}


