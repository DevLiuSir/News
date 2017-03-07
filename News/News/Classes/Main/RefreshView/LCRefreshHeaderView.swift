//
//  LCRefreshHeaderView.swift
//  News
//
//  Created by Liu Chuan on 2016/12/23.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit


// MARK: - 刷新视图 - 头部
class LCRefreshHeaderView: UIView {

    // MARK: - 控件属性
    @IBOutlet weak var image: UIImageView!                 // 图片
    @IBOutlet weak var activity: UIActivityIndicatorView!  // 活动指示器
    @IBOutlet weak var contentLabel: UILabel!              // 文字标签
    @IBOutlet weak var lastUpdateTimeLabel: UILabel!       // 最后的更新时间Label
    
    // MARK: - 定义属性
    
    // 定义可以滚动的视图, 用于监听父控件的滚动
    var superScrollView: UIScrollView!
  
    // 记录当前刷新状态
    var Header_refreshStatus: LCRefresh_HeaderStatus!
    
    // MARK: - 提供一个设置状态的方法
    func setStatus(_ status:LCRefresh_HeaderStatus){
        
        Header_refreshStatus = status
        switch status {
        case .normal:
            setNomalStatus()
            break
        case .waitRefresh:
            setWaitRefreshStatus()
            break
        case .refreshing:
            setRefreshingStatus()
            break
        }
    }
    
}

// MARK: - 扩展 LCRefreshHeaderView
extension LCRefreshHeaderView{
    
    // MARK: - 提供一个快速创建类方法
    class func Load_Refresh_HeaderView() -> LCRefreshHeaderView {
        
        return Bundle.main.loadNibNamed("LCRefreshHeaderView", owner: nil, options: nil)?.first as! LCRefreshHeaderView
    }
    
    // MARK: - ** 各种状态切换 **
    
    // MARK: 正常状态
    fileprivate func setNomalStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        contentLabel.text = "下拉可以刷新"
        image.isHidden = false
        
        UIView.animate(withDuration: 0.25) {
            self.image.transform = CGAffineTransform.identity
        }
     }
    
    
    // MARK: 等待刷新状态
    fileprivate func setWaitRefreshStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        contentLabel.text = "松开立即刷新"
        image.isHidden = false
        
        UIView.animate(withDuration: 0.25) {  // 图片旋转180°
            self.image.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
        }
    }
    
    // MARK: 正在刷新状态
    fileprivate func setRefreshingStatus() {
        activity.isHidden = false
        activity.startAnimating()
        contentLabel.text = "正在刷新数据..."
        image.isHidden = true
        
        print("发送请求给服务器")
        
        // 执行2秒, 增大内边距
        UIView.animate(withDuration: 0.25, animations: {
            
            self.superScrollView.contentInset = UIEdgeInsets(top: self.superScrollView.contentInset.top + refresh_HeaderViewHeight, left: self.superScrollView.contentInset.left, bottom: self.superScrollView.contentInset.bottom, right: self.superScrollView.contentInset.right)
            
        })
        
        // 结束刷新
        self.endRefreshing()
    }
    
    // MARK: 结束刷新
    fileprivate func endRefreshing() {
      
        // 保存刷新时间
        self.last_UpdateTime()
        
        
        // 延迟2秒执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC))/Double(NSEC_PER_SEC) , execute: {
            
            // 执行2秒, 减小内边距
            UIView.animate(withDuration: 0.25, animations: {
                
                self.superScrollView.contentInset = UIEdgeInsets(top: self.superScrollView.contentInset.top - refresh_HeaderViewHeight, left: self.superScrollView.contentInset.left, bottom: self.superScrollView.contentInset.bottom, right: self.superScrollView.contentInset.right)
                
                print("结束刷新了!!!!!")
                
            })
            
            // 恢复正常状态
            self.Header_refreshStatus = LCRefresh_HeaderStatus.normal
        
        })
        
    }
    
    // MARK: - 最后更新的时间..
    fileprivate func last_UpdateTime() {
        
        // 创建一个日期格式器
        let formatter = DateFormatter()
        
        let now = NSDate()
        
        // 为日期格式器设置格式字符串
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss aa"
        
        // 使用日期格式器，格式化日期、时间
        let dateStr = formatter.string(from: now as Date)
        
        // 显示日期
        self.lastUpdateTimeLabel.text = "最后更新: \(dateStr)"
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
                
           
            // 参数: addObserver: 监听的对象, 谁来监听  forKeyPath: 需要监听的属性
            // 注意: 使用 KVO 和通知一样, 需要注销
            // KVO 的使用: 用监听对象调用 addObserver: forKeyPath: options: context 方法
            
            // MARK: 监听属性
            superScrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        }
    }
    
    // MARK: 属性发生改变
    // 当监听对象的熟悉发生改变时, 调用 addObserver对象的 observeValue(forKeyPath keyPath: of object:  change: [NSKeyValueChangeKey : Any]?, context:
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
//        print(" 监听父控件的滚动!.........\(superScrollView.contentOffset.y)")
        
        //MARK: - 根据拖动进度, 切换状态
        // 判断是否滚动
        if self.superScrollView.isDragging {
            
            // 如果当前状态处于刷新, 直接返回
            if Header_refreshStatus == LCRefresh_HeaderStatus.refreshing { return }
            
            let refreshView_OffSet: CGFloat = -(titleViewH + refresh_HeaderViewHeight)      // 刷新视图高度
        
            // MARK: 手指拖动: normal -> waitRefresh ;  waitRefresh -> normal

/*
            if superScrollView.contentOffset.y > refreshView_OffSet { // Header_refreshStatus == LCRefresh_HeaderStatus.waitRefresh &&
                setStatus(.normal)          // 切换到正常状态
            } else if superScrollView.contentOffset.y <= refreshView_OffSet { // Header_refreshStatus == LCRefresh_HeaderStatus.normal &&
                setStatus(.waitRefresh)     // 切换到等待刷新状态
            } 
            
        } else {
            // MARK: 手指松开: waitRefresh -> refreshing
            if Header_refreshStatus == LCRefresh_HeaderStatus.waitRefresh {
                setStatus(.refreshing)      // 切换到刷新中状态
            }
        }
 */
            guard superScrollView.contentOffset.y > refreshView_OffSet else {
                setStatus(.waitRefresh)     // 切换到等待刷新状态
                return
            }
            setStatus(.normal)              // 切换到正常状态
        }
        
        // MARK: - 手指松开:
       if Header_refreshStatus == LCRefresh_HeaderStatus.waitRefresh {
            setStatus(.refreshing)          // 正在刷新状态
        }
        
    }
  
 
    // MARK: - 移除 KVO 的监听
    override func removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
        
        //监听对象调用 removeObserver
        superScrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
}

