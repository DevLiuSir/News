//
//  BaseViewController.swift
//  News
//
//  Created by Liu Chuan on 2016/11/17.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        launchAnimation()
        
    }

    
    
    
    // MARK: - 播放启动画面动画
    private func launchAnimation() {
        //获取启动视图
        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "launch")
        let launchview = vc.view!
        
        let delegate = UIApplication.shared.delegate
        
        delegate?.window!!.addSubview(launchview)
        
        //播放动画效果，完毕后将其移除
        UIView.animate(withDuration: 2, delay: 1.5, options: .beginFromCurrentState,
                       animations: {
                        launchview.alpha = 0.0
                        let transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
                        launchview.layer.transform = transform
        }) { (finished) in
            launchview.removeFromSuperview()
        }
    }
    
    
    // MARK: - 显示\隐藏 导航栏
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // false: 向下    true: 向上
        var scroll_Up_Or_Down : Bool = false
        
        //定义起初 Y 轴偏移量
        let newY : CGFloat = 0
        var oldY : CGFloat = 0
        
        //获取当前滚动视图的contentOffset.y
//        newY = tableView.contentOffset.y
        
        //判断滚动视图向上还是向下
        if newY != oldY && newY > oldY {
            
            scroll_Up_Or_Down = true
            
        } else if newY < oldY {
            
            scroll_Up_Or_Down = false
            
        } else  {
            
            oldY = newY
        }
        
        
        //定义初始的navigationBar的位置
        if newY == -60 {
            
            UIView.animate(withDuration: 1, animations: {
                self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: screenW, height: navigationH)
            })
            
        }else {
            
            if scroll_Up_Or_Down == true {  // 向上, 隐藏
                
                UIView.animate(withDuration: 1, animations: {
                    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: -40, width: screenW, height: navigationH + statusH)
                    self.navigationController?.navigationBar.lc_setElementsAlpha(alpha: 0) // 导航栏图片透明
                    
                })
                
            } else if scroll_Up_Or_Down == false { // 向下, 显示
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: screenW, height: navigationH)
                    
                    self.navigationController?.navigationBar.lc_setElementsAlpha(alpha: 1) // 导航栏图片不透明
                })
            }
        }
    }
    
}

