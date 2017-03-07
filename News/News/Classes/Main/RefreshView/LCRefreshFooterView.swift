//
//  LCRefreshFooterView.swift
//  News
//
//  Created by Liu Chuan on 2016/12/23.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit




// MARK: - 刷新视图 - 底部
class LCRefreshFooterView: UIView {

    // MARK: - 控件
    @IBOutlet weak var activity: UIActivityIndicatorView!   // 活动指示器
    @IBOutlet weak var contentLabel: UILabel!               // 文字标签
    

    
    // 定义可以滚动的视图, 用于监听父控件的滚动
    var superScrollView: UIScrollView!
    
    // 定义属性记录当前刷新状态
    var Footer_refreshStatus: LCRefresh_FooterStatus?
    
    func setStatus(_ status:LCRefresh_FooterStatus){
        Footer_refreshStatus = status
        switch status {
        case .normal:
            setNomalStatus()
            break
        case .waitLoad:
            setWaitLoadStatus()
            break
        case .loading:
            setLoadingStatus()
            break
        case .loadover:
            setLoadoverStatus()
            break
        }
    }

}

// MARK: - 扩展 LCRefreshFooterView
extension LCRefreshFooterView {
    
        // MARK: - 提供一个快速创建类方法
        class func Load_Refresh_FooterView() -> LCRefreshFooterView {
            
            // 通过 xib 加载界面
            return Bundle.main.loadNibNamed("LCRefreshFooterView", owner: nil, options: nil)?.first as! LCRefreshFooterView
        }
    
    
    /** 各种状态切换 */
    
    // MARK: 正常状态
    fileprivate func setNomalStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        contentLabel.text = "上拉加载更多数据"
    }
    
    // MARK: 等待加载
    fileprivate func setWaitLoadStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        contentLabel.text = "松开加载更多数据"
    }
    
    // MARK: 正在加载
    fileprivate func setLoadingStatus() {
        activity.isHidden = false
        activity.startAnimating()
        contentLabel.text = "正在加载更多数据..."
        
        // 刷新延迟2秒后, 执行 setLoadoverStatus 加载完毕
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC))/Double(NSEC_PER_SEC) , execute: {
            
            self.setStatus(.loadover)        // 全部加载完毕
            
        })
    }
    
    
    // MARK: 加载完毕
    fileprivate func setLoadoverStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        contentLabel.text = "全部加载完毕"
        
       // 加载完成时, 延迟1秒执行以下代码
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC))/Double(NSEC_PER_SEC) , execute: {
            
            // MARK: 加载完毕后, 增加\减小内边距, 使FooterView 还原(隐藏起来)
            
            // 执行2秒, 减小内边距
            UIView.animate(withDuration: 0.25, animations: {
                
                self.superScrollView.contentInset = UIEdgeInsets(top: self.superScrollView.contentInset.top, left: self.superScrollView.contentInset.left, bottom: self.superScrollView.contentInset.bottom - tabBarH, right: self.superScrollView.contentInset.right)
                
                print("结束刷新了!!!!!")
                
            })
            
            // 执行2秒, 增加内边距
            UIView.animate(withDuration: 0.25, animations: {
                
                self.superScrollView.contentInset = UIEdgeInsets(top: self.superScrollView.contentInset.top, left: self.superScrollView.contentInset.left, bottom: self.superScrollView.contentInset.bottom + tabBarH, right: self.superScrollView.contentInset.right)
                
            })
            // 加载完毕之后隐藏文字
            self.contentLabel.text = ""
            
        })
        
    }
    
    // MARK: - ***** 监听 tableView 的滚动 ******
    // 控件将要添加到父控件时, 调用此函数
    override func willMove(toSuperview: UIView?){
        super.willMove(toSuperview: toSuperview)
        
        //print("toSuperview is \(toSuperview)..........")
        
        // 可以获取父控件
        // 只要父控件能滚动时, 才可以监听
        if (toSuperview?.isKind(of: UIScrollView.classForCoder()))! {
            
            superScrollView = toSuperview as! UIScrollView
            
            // MARK: - ****** KVO *****
            
            // 监听父控件, 就是监听 superScrollView 的 contentOffSet 的属性的改变
            // 监听一个对象的属性的改变, 一般用 KVO
            // KVO: key - value - observing
            // 作用: 监听对象属性的改变
         /*
            添加KVO:添加一个键值观察者{
                第一个参数observer: 观察者; 谁是观察者,谁就要实现 一个方法
                第二个参数forKeyPath: 需要观察对象的属性
                第三个参数options: 新值还是旧值
                第四个参数: 默认填 nil
         */
            
            // 注意: 使用 KVO 和通知一样, 需要注销
            // KVO 的使用: 用监听对象调用 addObserver: forKeyPath: options: context 方法
            
            superScrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        }
    }

    // 当监听对象的熟悉发生改变时, 调用 addObserver对象的 observeValue(forKeyPath keyPath: of object:  change: [NSKeyValueChangeKey : Any]?, context:

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //print(" 监听父控件的滚动!.........\(superScrollView.contentOffset.y)")
        
        //MARK: - 根据拖动进度, 切换状态
        // 判断是否滚动
        if self.superScrollView.isDragging {
            
            // 如果当前状态处于加载中, 直接返回, 避免一直加载
            if Footer_refreshStatus == LCRefresh_FooterStatus.loading { return }
            
            // MARK: superScrollView  这里代表父类 UITableView
            
            // 如果当前tableView 的内容高度为0, 没有内容的时候,直接返回.
            if superScrollView.contentSize.height == 0 { return }
            

            // MARK: 手指拖动: 正常状态(normal) ->  等待加载(waitRefresh)
            
            // 实现FooderView加载一半, 就做出改变
            // refreshView_FooderOffSet = (tableView内容高度 + tableView底部内边距) - refresh_FooterView高度 - refresh_FooterView高度一半
           
            let refreshView_FooderOffSet: CGFloat = (superScrollView.contentSize.height + superScrollView.contentInset.bottom) - superScrollView.frame.height

/*
            if superScrollView.contentOffset.y < refreshView_FooderOffSet {
                
                setStatus(.normal)          // 正常状态 -上拉加载更多
            
            } else if superScrollView.contentOffset.y >= refreshView_FooderOffSet {
                
                setStatus(.waitRefresh)     // 等待刷新 - 松开加载更多
            }
                
        }
        
        else { // MARK: - 手指离开: 正在刷新(refreshing) -> 加载完毕(loadover)

            if Footer_refreshStatus == LCRefresh_FooterStatus.waitRefresh {

                 setStatus(.loading)             // 加载中
            }
        }
    }

 */
    
            guard superScrollView.contentOffset.y < refreshView_FooderOffSet else {
                setStatus(.waitLoad)        // 松开加载更多
                return
            }
            setStatus(.normal)              // 正常状态
        }

        // MARK: - 手指松开:
        if Footer_refreshStatus == LCRefresh_FooterStatus.waitLoad {
            setStatus(.loading)             // 加载中
        }
        
    }
  
    


            
    // MARK: - 移除 KVO 的监听
    override func removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
        
        //监听对象调用 removeObserver
        superScrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
}


