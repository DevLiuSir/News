//
//  BaseViewController.swift
//  News
//
//  Created by Liu Chuan on 2016/11/17.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    
    // UIGestureRecognizerDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //启用滑动返回（swipe back）
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
//        self.navigationController?.popViewController(animated: true)
    }
    
        
    
}
/*
 // MARK: - 显示\隐藏 导航栏
extension BaseViewController {
 
     // MARK: 上推 -> 隐藏   下拉 -> 显示
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let offsetY: CGFloat = scrollView.contentOffset.y
        
        guard offsetY > 0 else {
            
            setNavigationBarTransformProgress(progress: 0)
            return
        }
         guard offsetY >= 44 else {
            
             setNavigationBarTransformProgress(progress: offsetY / 44)
             return
        }
       
        setNavigationBarTransformProgress(progress: 1)
    
    }
     
    /// 设置导航栏改变进度
    ///
    /// - Parameter progress: 进度
    private func setNavigationBarTransformProgress(progress: CGFloat) {
     
        UIView.animate(withDuration: 0.25) {
        
            self.navigationController?.navigationBar.lc_setTranslationY(translationY: -44 * progress)
            self.navigationController?.navigationBar.lc_setElementsAlpha(alpha: 1 - progress)
      
        }
        
    }
 
 }
 

*/

/*
// MARK: 显示\隐藏 导航栏
extension MeViewController {
    
    // MARK: 上推 -> 显示   下拉 -> 隐藏
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY: CGFloat = scrollView.contentOffset.y
        
        guard offsetY < 0 else {
            setNavigationBarTransformProgress(progress: 0)
            self.navigationController?.navigationBar.lc_setBackgroundColor(backgroundColor: darkGreen)
            return
        }
        setNavigationBarTransformProgress(progress: 1)
        
    }
    
    /// 设置导航栏改变进度
    ///
    /// - Parameter progress: 进度
    private func setNavigationBarTransformProgress(progress: CGFloat) {
        
        UIView.animate(withDuration: 0.25) {
            self.navigationController?.navigationBar.lc_setTranslationY(translationY: -64 * progress)
            self.navigationController?.navigationBar.lc_setElementsAlpha(alpha: 1 - progress)
            
        }
    }
    
}
*/
