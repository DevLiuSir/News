//
//  ViewController.swift
//  News
//
//  Created by Liu Chuan on 16/8/12.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        tabBar.tintColor = colorLan
        
        // 启动界面动画
        launchAnimation()
        
    }
    
    
    
    // MARK: - 启动界面动画
    private func launchAnimation() {
        //获取启动视图
        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "launch")
        let launchview = vc.view!
        
//        let delegate = UIApplication.shared.delegate
//        delegate?.window!!.addSubview(launchview)
        
        self.view.addSubview(launchview) //如果没有导航栏，直接添加到当前的view即可
        
        //播放动画效果，完毕后将其移除
        UIView.animate(withDuration: 2, delay: 1.5, options: .beginFromCurrentState, animations: {
          
            launchview.alpha = 0.0
            
            let transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
            
            launchview.layer.transform = transform
        
        }) { (finished) in
        
            launchview.removeFromSuperview()
        }
        
    }
    
    
    
  
}




