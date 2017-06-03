//
//  ChannelTitleView.swift
//  News
//
//  Created by Liu Chuan on 2017/3/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit



typealias editChannelButtonClick = (UIButton) -> Void


class ChannelTitleView: UIView {
    
    
    var editChannelButton: editChannelButtonClick?
    
    // MARK: - 懒加载控件
    
    /// 顶部标签
    lazy var tipLabel: UILabel = {
        let tipLabel = UILabel()
        tipLabel.text = "切换频道"
        tipLabel.font = UIFont.systemFont(ofSize: 15)
        tipLabel.textColor = UIColor.gray
        return tipLabel
    }()
    
    /// 编辑按钮
    lazy var clickButton: UIButton = {
        let clickButton = UIButton(type: .custom)
        clickButton.setTitle("排序删除", for: .normal)
        clickButton.sizeToFit()
        clickButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        clickButton.setTitleColor(UIColor.red, for: .normal)
        clickButton.setBackgroundImage(UIImage(named: "column_edit_button"), for: .normal)
        return clickButton
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.yellow
        return lineView
    }()
    
    
    // MARK: - 提供一个快速创建视图的类方法
    class func returnTitleView() -> ChannelTitleView {
        
        let titleView = ChannelTitleView()
        titleView.clickButton.addTarget(titleView, action: #selector(editChannel(button:)), for: .touchUpInside)
        
        // 添加控件
        titleView.addSubview(titleView.tipLabel)
        titleView.addSubview(titleView.clickButton)
        titleView.addSubview(titleView.lineView)
        
        // MARK: snapkit布局控件
        titleView.tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleView.snp.left).offset(15)
            make.centerY.equalTo(titleView.snp.centerY)
        }
        titleView.clickButton.snp.makeConstraints { (make) in
            make.right.equalTo(titleView.snp.right).offset(-15)
            make.centerY.equalTo(titleView.snp.centerY)
        }
        titleView.lineView.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.height.equalTo(15)
            make.width.equalTo(0.5)
            make.centerY.equalTo(titleView.snp.centerY)
        }
        return titleView
        
    }
    

    // MARK: - 标题视图点击事件
    func editChannel(button: UIButton){
        if editChannelButton != nil {
            editChannelButton!(button)
        }
    }
    /// 默认title
    func normalTitle() {
        tipLabel.text = "切换频道"
        clickButton.setTitle("排序删除", for: .normal)
        clickButton.isSelected = false
    }
     /// 选择编辑频道后的title
    func selectTitle() {
        tipLabel.text = "拖动排序"
        clickButton.setTitle("完成", for: .normal)
        clickButton.isSelected = true
    }

}
