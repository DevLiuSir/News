//
//  NewsViewController.swift
//  News
//
//  Created by Liu Chuan on 2016/9/25.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ChameleonFramework

class NewsViewController: UIViewController {
  
    // MARK: - 懒加载
    /// 详情页
    fileprivate lazy var detaiModels: [DetailViewModel] = [DetailViewModel]()
    
    /// 频道分类
    fileprivate lazy var channels = ChannelModel.channels()
    
    /// 展开按钮
    fileprivate lazy var spreadBtn: UIButton = UIButton()
    
    /// 是否展开
    fileprivate var isOpen: Bool = false
    
    /// 创建一层UIView, 作为: 旋转展开按钮的背景
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView(frame: CGRect(x: 0, y: navigationH + statusH, width: screenW, height: titleViewH))
        return bgView
    }()
    
    /// 标题滚动视图
    fileprivate lazy var titleView: TitleView = {[weak self] in
        
        let titleFrame = CGRect(x: 0, y: 0, width: screenW - titleViewH, height: titleViewH)
        let title_View = TitleView(frame: titleFrame)
        title_View.backgroundColor = UIColor.clear
        title_View.delegate = self
        return title_View
    }()
    
    /// 内容滚动视图
    fileprivate lazy var contentView : ContentView = {[weak self] in
        
        // 设置内容视图的frame
        // contentH = 屏幕高度 - 状态栏高度 - 导航栏高度
        let contentH = screenH - statusH - navigationH
        let contentFrame = CGRect(x: 0, y: statusH + navigationH, width: screenW, height: contentH)
       
        // 确定所有的子控制器
        var childVcs = [UIViewController]()
       // childVcs.append(HeadlineViewController())
        
        // 继续创建剩下的 controller
        for _ in 0 ..< ChannelModel.channels().count {
           
            let vc = UIViewController()
            // 设置随机色
            //vc.view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)), green: CGFloat(arc4random_uniform(255)), blue: CGFloat(arc4random_uniform(255)))
            
            childVcs.append(vc)
        }
        
        let content_View = ContentView(frame: contentFrame, childVCs: childVcs, parentViewController: self!)
        content_View.delegate = self
        return content_View
        
        }()
    
    
    /// 切换频道标题视图
    fileprivate lazy var channelTitleView = ChannelTitleView.returnTitleView()
    
    /// 编辑频道视图
    fileprivate lazy var editChannelView: EditChannelView = {
        let editChannelView = EditChannelView(frame: CGRect(x: 0, y: 35, width: screenW, height: screenH - 35))
        editChannelView.backgroundColor = UIColor.white
        // 默认缩小Y值, 使得处于隐藏状态
        editChannelView.transform = CGAffineTransform(translationX: 0, y: -editChannelView.frame.height)
        return editChannelView
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}


// MARK: - 配置UI界面
extension NewsViewController {
    
    /// 设置UI界面
    fileprivate func setupUI() {
        
        // iOS7以后, 导航控制器中ScrollView顶部会添加 64 的额外高度
        automaticallyAdjustsScrollViewInsets = false        // 取消自动调整scrollView边距
        
        // 添加控件
        view.addSubview(contentView)
        view.addSubview(bgView)
        view.insertSubview(editChannelView, aboveSubview: contentView)
        bgView.addSubview(titleView)
        bgView.addSubview(spreadBtn)
        bgView.insertSubview(channelTitleView, belowSubview: (navigationController?.navigationBar)!)
        
        configNavigationBar()
        configSpreadBtn_And_Shadow()
        configBlurView()
        configChannelTitleView()
  
    }

    /// 配置导航栏
    private func configNavigationBar() {
    
        // 设置导航栏背景色
        navigationController?.navigationBar.barTintColor = darkGreen
        
        // 修改导航栏按钮颜色
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // 修改导航栏文字颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
   
        // 设置导航栏LOGO
        navigationItem.titleView =  UIImageView(image: UIImage(named: "home_nav_title"))
        
        // 隐藏返回按钮上的文字
        navigationItem.backBarButtonItem?.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), for: .default)
        
        // 保证图片比例不变
        navigationItem.titleView?.contentMode = .scaleAspectFit
        
        // 设置导航栏半透明
        navigationController?.navigationBar.isTranslucent = true
        
        
        // 左边的Item
        /// 日历按钮
        let calendarBtn = UIButton()
        calendarBtn.setImage(UIImage(named: "日历入口-白天"), for: .normal)
        calendarBtn.setImage(UIImage(named: "日历入口-白天-按下"), for: .highlighted)
        calendarBtn.sizeToFit()
        calendarBtn.addTarget(self, action: #selector(calendarBtnClicked), for: .touchUpInside)
        
        
        // 右边的Item
        /// 尺寸
        let size = CGSize(width: 35, height: 35)
        
        /// 搜索按钮
        let searchBtn = UIButton()
        searchBtn.setImage(UIImage(named: "search_light"), for: .normal)
        searchBtn.frame = CGRect(origin: CGPoint.zero, size: size)
        searchBtn.addTarget(self, action: #selector(searchBtnClicked), for: .touchUpInside)
        
        /// 加号按钮
        let addBtn = UIButton()
        addBtn.setImage(UIImage(named: "加号"), for: .normal)
        addBtn.frame = CGRect(origin: CGPoint.zero, size: size)
        addBtn.addTarget(self, action:  #selector(addBtnClicked(_:)), for: .touchUpInside)
        
        let searchItem = UIBarButtonItem(customView: searchBtn)
        let addItem = UIBarButtonItem(customView: addBtn)
        let calendarItem = UIBarButtonItem(customView: calendarBtn)
        
        navigationItem.rightBarButtonItems = [addItem, searchItem]
        navigationItem.leftBarButtonItem = calendarItem
    }
    
       /// 设置模糊效果
    private func configBlurView() {
        
        // 创建模糊效果类实例
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        
        // 创建效果视图类实例
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        // 设置效果视图类实例的尺寸
        blurView.frame.size = CGSize(width: screenW, height: titleViewH)
        
        // 设置模糊透明度
        blurView.alpha = 1
        
        // 将模糊效果视图类实例放入背景中
        bgView.insertSubview(blurView, at: 0)
        
    }
    
    /// 配置展开按钮\阴影
    private func configSpreadBtn_And_Shadow() {
        // 设置右边展开按钮(即: 按钮为正方形) 相关属性
        spreadBtn.frame = CGRect(x: screenW - titleViewH , y: 0 , width: titleViewH, height: titleViewH)
        spreadBtn.backgroundColor = UIColor.clear
        spreadBtn.setImage(UIImage(named: "home_arrow_down"), for: .normal)
        spreadBtn.addTarget(self, action: #selector(spreadBtnClick(spreadBtn:)), for: .touchUpInside)
    
        // 左右的阴影效果
        let left_shadowImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: titleViewH))
        let right_shadowImageView = UIImageView(frame: CGRect(x: screenW - spreadBtn.frame.width * 2, y: 0, width: titleViewH, height: titleViewH))
        left_shadowImageView.image = UIImage(named: "navbar_left_more")
        right_shadowImageView.image = UIImage(named: "navbar_right_more")
        
        titleView.addSubview(left_shadowImageView)
        //titleView.addSubview(right_shadowImageView)
    }
    
    /// 配置 编辑频道视图 的 频道标题
    private func configChannelTitleView() {
        
        weak var weakSelf = self
        // 设置切换频道标题视图的相关属性
        channelTitleView.frame = CGRect(x: 0, y: 0, width: screenW - titleViewH, height: titleViewH)
        channelTitleView.backgroundColor = UIColor.clear
        channelTitleView.isHidden = true    // 默认隐藏
        
        channelTitleView.editChannelButton = {
            (button) -> Void in
            
            /// 按钮的状态, 默认为 FALSE
            let isSelected = button.isSelected
            
            if isSelected { // 如果没选中排序删除, 切换频道视图设置默认Title, 编辑频道视图,恢复默认频道
                weakSelf?.channelTitleView.normalTitle()
                weakSelf?.editChannelView.normalChannel()
            } else {        // 如果选中排序删除, 切换频道视图设置选中后的Title, 编辑频道视图,编辑状态
                weakSelf?.channelTitleView.selectTitle()
                weakSelf?.editChannelView.editChannel()
            }
        }
    }
    
}


// MARK: - 事件监听
extension NewsViewController {
    
    /// 旋转展开按钮点击事件
    @objc fileprivate func spreadBtnClick(spreadBtn : UIButton) {
        
        // MARK: 展开收拢控制
        UIView.animate(withDuration: 0.5, animations: {
            
            if spreadBtn.isSelected {       // 默认为false
        /*
                 当让控件旋转角度大于M_PI(大于180°)时,先按照顺时针来规划一下旋转后的大概位置.
                 当规划完最终的位置后发现,到达最终的位置逆时针旋转的角度要小于顺时针旋转角度.
                 所以会逆时针转到指定的位置上,当归位时,顺时针完成,这样实现的效果就是,两次旋转动作都在圆的右侧进行
        */
                // MARK: 顺时针 旋转展开按钮180度
                spreadBtn.imageView?.transform = spreadBtn.imageView!.transform.rotated(by: CGFloat(M_PI - 0.001))
                
                // 平移动画
                // 编辑标题视图 y值为:负, 使得向上平移, 隐藏编辑标题视图
                self.editChannelView.transform = CGAffineTransform(translationX: 0, y: -self.editChannelView.frame.height)
                self.titleView.isHidden = false
                self.channelTitleView.isHidden = true
                self.tabBarController?.tabBar.isHidden = false  
                print(spreadBtn.isSelected)
            } else {
                
                // MARK: 逆时针 旋转展开按钮180度
                spreadBtn.imageView?.transform = spreadBtn.imageView!.transform.rotated(by: CGFloat(M_PI + 0.001))
                self.editChannelView.transform = .identity  // 恢复编辑标题视图Y值, 显示编辑标题视图
                self.editChannelView.normalChannel()
                self.channelTitleView.isHidden = false
                self.titleView.isHidden = true
                self.tabBarController?.tabBar.isHidden = true
                print(spreadBtn.isSelected)
            }
            
            // 记录编辑标题视图 最新状态
            self.channelTitleView.normalTitle()
        })
        
        // 记录按钮的最新状态
        spreadBtn.isSelected = !spreadBtn.isSelected
    }
    
    
    
    /// 日历按钮点击事件
    @objc fileprivate func calendarBtnClicked() {
        
        let calendarVC = CalendarController()
        
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    /// 搜索按钮点击事件
    @objc fileprivate func searchBtnClicked() {
        
        print("点击了导航栏搜索按钮")
        
        let search = SearchViewController()
        
        // 1. 修复返回控制器时,searchBar白色背景出现bug
        
        // 移除SearBar背景色
        
        // 1.1 取出searchBar背景上的view : searchBar背景
        let firstSubView = search.searchBar.subviews.first
        //firstSubView?.backgroundColor = UIColor.purple
        
        // 1.2 来获取它，并且移除它
        let backgroundView = firstSubView?.subviews.first
        backgroundView?.removeFromSuperview()
        
        
        // 2.0 设置 搜索控制器 为导航控制器的 根控制器
        let nav = UINavigationController(rootViewController: search)
        
        // 2.1 设置导航控制器相关属性
        nav.navigationBar.tintColor = UIColor.white
        
        // 3.跳转到导航控制器
        // 模态跳转到控制器
        //navigationController?.present(nav, animated: true, completion: nil)
        
        // 非模态跳转
        navigationController?.pushViewController(search, animated: true)
        
        // 延迟1秒执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC))/Double(NSEC_PER_SEC) , execute: {
            
            // searchBar 成为第一响应, 从而弹出键盘
            search.searchBar.becomeFirstResponder()
        })
        
    }
    
    /// 加号按钮点击事件
    @objc fileprivate func addBtnClicked(_ sender: UIButton) {
        
        print("点击了+号按钮!!!")
        
        // 以popover的方式, 展现一个视图控制器
        // 1.创建弹出控制器
        let popVC = PopViewController()
        
        // 设置转场动画的样式
        popVC.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // 如果sourceView是UIBarButtonItem类型，必须要有下面这一句.
        // 这里的sender是UIButton类型的，所已不需要上面那一句
        popVC.popoverPresentationController?.sourceView = spreadBtn

//        popVC.popoverPresentationController?.barButtonItem = sender
     
        // 设置箭头的位置，原点可以参照某一个控件的尺寸设置，宽高通常用于设置附加的偏移量，通常传入0即可
        // 指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
        popVC.popoverPresentationController?.sourceRect = CGRect(x: sender.frame.width, y: navigationH + statusH, width: 0, height: 0)
        
        // 取消箭头
        popVC.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        
        // 设置转场动画的代理
        popVC.popoverPresentationController?.delegate = self
        
        popVC.popoverPresentationController?.backgroundColor = UIColor.white
        
        // 弹出控制器
        present(popVC, animated: true, completion: nil)
    }
    

}


// MARK: - 遵守 TitleViewDelegate 协议
extension NewsViewController : TitleViewDelegate {
    
    func titleView(_ titleView: TitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}

// MARK: - 遵守 ContentViewDelegate 协议
extension NewsViewController : ContentViewDelegate {
    
    func contentView(_ contentView: ContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


// MARK: - 遵守 UIPopoverPresentationControllerDelegate 协议
extension NewsViewController: UIPopoverPresentationControllerDelegate {
    // 模态动画的样式
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // 不使用系统默认的展现样式！
        return UIModalPresentationStyle.none
    }
    // 弹框消失时调用的方法
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    // 点击蒙版是否消失，默认为true
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    
}


