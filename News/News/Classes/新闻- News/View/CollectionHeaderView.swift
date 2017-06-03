//
//  CollectionHeaderView.swift
//  News
//
//  Created by Liu Chuan on 2017/3/14.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    
    /// 标签
    private lazy var label: UILabel = {
        
        let label = UILabel(frame: self.bounds)
        label.frame.origin.x = 20
        return label
    }()
    
    /// 按钮
    lazy var button: UIButton = {
        
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: screenW - 80, y: 0, width: 80, height: self.frame.height)
        btn.setTitle("排序删除", for: .normal)
        btn.setTitle("完成", for: .selected)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        return btn
    }()
    
    var clickCallback: (() -> ())?
    
    var text: String? {
        
        didSet {
            
            label.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    /// 设置UI界面
    private func setupUI() {
        
        addSubview(label)
        addSubview(button)
        backgroundColor = UIColor.groupTableViewBackground // 背景色为TableView 分组色
    }
    
    /// 按钮点击事件
    @objc private func buttonClick() {
        if (clickCallback != nil) { clickCallback!() }
    }
    
      required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
