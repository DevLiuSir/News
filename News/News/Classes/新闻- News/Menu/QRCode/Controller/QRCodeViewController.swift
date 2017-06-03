//
//  QRCodeViewController.swift
//  News
//
//  Created by Liu Chuan on 2017/5/30.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    
    
    /// 自定义TabBar
    @IBOutlet weak var CustomTabBar: UITabBar!
    
    // MARK: - 关闭按钮点击事件
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        
        // 消失视图
        dismiss(animated: true, completion: nil)
        
        
        // 非模态返回
//        _ = navigationController?.popViewController(animated: true)
      
    }
    

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

  
}
