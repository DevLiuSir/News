//
//  MyHeaderView.swift
//  News
//
//  Created by Liu Chuan on 2017/3/15.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit
import SnapKit

typealias messageButtonClickMethod = () -> Void
typealias settingButtonClickMethod = () -> Void
typealias iconButtonClickMethod = () -> Void

class MyHeaderView: UIView {
    
    var messageButtonClick: messageButtonClickMethod?
    var settingButtonClick: settingButtonClickMethod?
    var iconButtonClick: iconButtonClickMethod?
    
    // MARK: - 懒加载
    /// 背景图片
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "Me_ProfileBackgroundLight")
        return bgImageView
    }()
    
    /// 右上角设置按钮
    lazy var settingButton: UIButton = {
        let settingButton = UIButton()
        settingButton.tag = 2
        settingButton.setImage(UIImage(named: "Me_settings_20x20_"), for: UIControlState())
        return settingButton
    }()
    
    /// 头像按钮
    lazy var iconButton: UIButton = {
        let iconButton = UIButton()
        iconButton.tag = 3
        iconButton.setBackgroundImage(UIImage(named: "Me_AvatarPlaceholder_75x75_"), for: UIControlState())
        iconButton.layer.cornerRadius = 20 * 0.5
        iconButton.layer.masksToBounds = true
        return iconButton
    }()
    
    /// 昵称标签
//    fileprivate lazy var nameLabel: UILabel = {
//        let nameLabel = UILabel()
//        nameLabel.text = "登录"
//        nameLabel.textColor = UIColor.white
//        nameLabel.font = UIFont.systemFont(ofSize: 14.0)
//        nameLabel.textAlignment = .center
//        nameLabel.numberOfLines = 2
//        return nameLabel
//    }()
    
    /// 登录按钮
    fileprivate lazy var nameBtn: UIButton = {
        let nameBtn = UIButton(type: .custom)
        nameBtn.setTitle("登录", for: .normal)
        nameBtn.titleLabel?.adjustsFontForContentSizeCategory = true    // 自动调整按钮字体大小
        nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)        // 按钮文字大小
        nameBtn.titleLabel?.adjustsFontSizeToFitWidth = true            // 自动调整按钮字体宽度
        nameBtn.layer.borderColor = UIColor.lightText.cgColor           // 按钮边框颜色
        nameBtn.contentHorizontalAlignment = .center                    // 按钮文字对齐方式
        nameBtn.layer.borderWidth = 0.8                                 // 边框宽度
        nameBtn.layer.cornerRadius = 5                                  // 将按钮涂层的边框,设置为圆角
        nameBtn.layer.masksToBounds = true                              // 隐藏边界
        return nameBtn
    }()
    
    /// 类方法创建HeaderView
    ///
    /// - Returns: MyHeaderView
    class func returnHeaderView() -> MyHeaderView {
       
        let headerView = MyHeaderView()
        
        headerView.addSubview(headerView.bgImageView)
//        headerView.addSubview(headerView.messageButton)
        headerView.addSubview(headerView.settingButton)
        headerView.addSubview(headerView.iconButton)
//        headerView.addSubview(headerView.nameLabel)
        headerView.addSubview(headerView.nameBtn)
        
        
        headerView.bgImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(headerView)
            make.height.equalTo(300)
        }
        
//        headerView.messageButton.snp.makeConstraints { (make) in
//            make.size.equalTo(CGSize(width: 44, height: 44))
//            make.left.equalTo(headerView.snp.left)
//            make.top.equalTo(headerView.snp.top).offset(20)
//        }
//        
        headerView.settingButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.right.equalTo(headerView.snp.right)
            make.top.equalTo(headerView.snp.top).offset(20)
        }
        
        headerView.iconButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView.snp.centerX)
            make.size.equalTo(CGSize(width: 75, height: 75))
            make.top.equalTo(headerView.snp.top).offset(70)
        }
        
//        headerView.nameLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(headerView.snp.left).offset(10)
//            make.right.equalTo(headerView.snp.right).offset(-10)
//            make.top.equalTo(headerView.iconButton.snp.bottom).offset(10)
//        }
        
        
        headerView.nameBtn.snp.makeConstraints { (make) in
//            make.left.equalTo(headerView.snp.left).offset(10)
//            make.right.equalTo(headerView.snp.right).offset(-10)
            
            make.centerX.equalTo(headerView.snp.centerX)
            make.size.equalTo(CGSize(width: 90, height: 30))
            make.top.equalTo(headerView.iconButton.snp.bottom).offset(20)
            
        }
        
//        headerView.messageButton.addTarget(headerView, action: #selector(headerView.selectButtonClick(button:)), for: .touchUpInside)
        headerView.settingButton.addTarget(headerView, action: #selector(headerView.selectButtonClick(button:)), for: .touchUpInside)
        headerView.iconButton.addTarget(headerView, action: #selector(headerView.selectButtonClick(button:)), for: .touchUpInside)
        return headerView
    }
 

    func selectButtonClick(button: UIButton) {
        switch button.tag {
//        case 10: if messageButtonClick != nil { messageButtonClick!() }
        case 2: if settingButtonClick != nil { settingButtonClick!() }
        case 3: if iconButtonClick != nil { iconButtonClick!() }
        default:
            break
        }
    }   
}
