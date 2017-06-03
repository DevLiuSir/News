//
//  showNewStatusCount.swift
//  News
//
//  Created by Liu Chuan on 2017/3/17.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

    
    // MARK: - 显示新数据个数
    func showNewStatusCount(count: Int, label: UILabel) {
    
        //创建Label
        let label = UILabel()
        
        //设置Label的背景图片
        label.backgroundColor = UIColor.orange
        label.frame.size.width = screenW
        label.frame.size.height = 35
        
        if count == 0 {
            label.text = "没有新的微博数据，请稍后再试"
        } else {
            
            label.text = "共有\(count)条新的微博数据"
        }
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.frame.origin.y = 64 - label.frame.size.height
        
        
        /*
         
         //将label添加到导航栏控制器的view中，并且是盖在导航栏下边
         [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
         //动画设置
         CGFloat duration=1.0; //通过定义动画执行的时间来控制动过程的速度
         
         [UIView animateWithDuration:duration animations:^{
         label.transform=CGAffineTransformMakeTranslation(0, label.height);
         } completion:^(BOOL finished) {
         CGFloat delay=1.0; //定义控件悬停的时间
         [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
         label.transform=CGAffineTransformIdentity;
         } completion:^(BOOL finished) {
         //动画控件执行完整个过程后将其从父视图移除
         [label removeFromSuperview];
         }];
         }];
         */
        
    }
        




// **************

//animating navigation bar










