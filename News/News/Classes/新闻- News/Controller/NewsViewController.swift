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
  
    // MARK: - 懒加载属性
    
    // 频道分类
    fileprivate lazy var channels = ChannelModel.channels()
    
    // 详情页
    fileprivate lazy var detaiModels: [DetailViewModel] = [DetailViewModel]()
    
    // 右边的展开按钮
    fileprivate var spreadBtn: UIButton = UIButton()
    
    // 是否展开
    fileprivate var isOpen: Bool = false
 
    
    // ==================
    // MARK: - 标题滚动视图
    // ==================
    fileprivate lazy var titleView: TitleView = {[weak self] in
       
//        let titlesArray = ["头条", "数码", "要闻","娱乐", "手机","体育", "视频", "财经", "汽车","军事", "时尚", "健康", "彩票", "搞笑"]
        
        // MARK: - SwiftJSON 解析数据
//        let path = Bundle.main.path(forResource: "topic_news", ofType: "json")
        
//        let jsonData = NSData(contentsOfFile: path!)
//        let ParseJson = JSON(data: jsonData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers)
//    
//        
////        let name = ParseJson["tList"]
////        let tname = ParseJson["tList"][0]["tname"].string
////        let tid = ParseJson["tList"][0]["tid"].string
////        let img = ParseJson["tList"][0]["img"].string
////
////        print("\(name)")
////        print("\(tname!)")
////        print("\(tid!)")
////        print("\(img!)")
////        print(ParseJson["tList"][2]["tname"].string!)
////        print(ParseJson["tList"][3]["tname"].string!)
////        print(ParseJson["tList"][4]["tname"].string!)
////        print(ParseJson["tList"][5]["tname"].string!)
////        print(ParseJson["tList"][6]["tname"].string!)
////        print(ParseJson["tList"][7]["tname"].string!)
        
        
        // 标题滚动视图Y值: 状态栏高度 + 导航栏高度
        let titleFrame = CGRect(x: 0, y: statusH + navigationH, width: screenW, height: titleViewH)
        
        //  let title_View = TitleView(frame: titleFrame, titles: titlesArray)
        
        let title_View = TitleView(frame: titleFrame)
        title_View.backgroundColor = .clear
        title_View.delegate = self
        return title_View
        
    }()
    
    // ==================
    // MARK: - 内容滚动视图
    // ==================
    fileprivate lazy var contentView : ContentView = {[weak self] in
        
        // 设置内容视图的frame
        // contentH = 屏幕高度 - 状态栏高度 - 导航栏高度 - 标题滚动视图高度 - 底部线条的高度
        //  let contentH = screenH - statusH - navigationH - titleViewH - scrollLineH

        let contentH = screenH - statusH
        let contentFrame = CGRect(x: 0, y: statusH + navigationH, width: screenW, height: contentH)
       
        // 确定所有的子控制器
        var childVcs = [UIViewController]()
//        childVcs.append(HeadlineViewController())
//        childVcs.append(Apple_ViewController())

        // 继续创建剩下的 controller
        for _ in 0 ..< ChannelModel.channels().count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)), green: CGFloat(arc4random_uniform(255)), blue: CGFloat(arc4random_uniform(255)))
            
            childVcs.append(vc)
        }
        
        let content_View = ContentView(frame: contentFrame, childVCs: childVcs, parentViewController: self!)
        content_View.delegate = self
        return content_View
        
        }()
    
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // 设置UI界面
        setupUI()
        
              
    }
}


// MARK:- 设置UI界面
extension NewsViewController {
    
    fileprivate func setupUI() {
        
        // iOS7以后, 导航控制器中ScrollView顶部会添加 64 的额外高度
        automaticallyAdjustsScrollViewInsets = false
        
       
        // 设置导航栏
        setupNavigationColorAndLogo()
        
        // 设置模糊效果
        set_BlurView()
        
        // 配置展开按钮\阴影
        setupSpreadBtn_And_Shadow()
        
        
        // 添加控件
        view.addSubview(contentView)
        view.addSubview(titleView)
    }

    // MARK: 设置模糊效果
    fileprivate func set_BlurView() {
       
        // 创建模糊效果类实例
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        
        // 创建效果视图类实例
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        // 设置效果视图类实例的尺寸
        blurView.frame.size = CGSize(width: screenW, height: titleViewH)
        
        // 设置模糊透明度
        blurView.alpha = 1
        
        // 将模糊效果视图类实例放入背景中
        titleView.insertSubview(blurView, at: 0)

    }
    
    // MARK: 设置导航栏
    fileprivate func setupNavigationColorAndLogo() {
    
        // 设置导航栏背景色
        navigationController?.navigationBar.barTintColor = colorLan
        
        
        // 修改导航栏按钮颜色
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // 修改导航栏文字颜色
       // navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
   
        // 设置导航栏LOGO
        navigationItem.titleView =  UIImageView(image: UIImage(named: "home_nav_title"))
        
        // 保证图片比例不变
        navigationItem.titleView?.contentMode = .scaleAspectFit
        
        // 设置导航栏半透明
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    // MARK: - 配置展开按钮\阴影
    fileprivate func setupSpreadBtn_And_Shadow() {
    
        // 创建一层 UIView 作为按钮的背景
        let bgView = UIView(frame: CGRect(x: screenW - 40, y: 0.0, width: titleViewH, height: titleViewH))
        bgView.backgroundColor = .white
        
        // 设置右边展开按钮(即: 按钮为正方形) 相关属性
        spreadBtn = UIButton(type: UIButtonType.custom)
        spreadBtn.frame = CGRect(x: screenW - 40 , y: 0 , width: 40, height: 40)
        spreadBtn.backgroundColor = UIColor.clear
        spreadBtn.adjustsImageWhenHighlighted = false    // 取消按钮高亮状态
        spreadBtn.setImage(UIImage(named: "home_arrow_down"), for: .normal)
        spreadBtn.addTarget(self, action: #selector(spreadBtnClick(spreadBtn:)), for: .touchUpInside)
        
        
        titleView.addSubview(bgView)
//        bgView.addSubview(spreadBtn)
        
        // 左右的阴影效果
        let left_shadowImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: titleViewH))
        let right_shadowImageView = UIImageView(frame: CGRect(x: screenW - 60.0, y: 0, width: 60, height: titleViewH))
        
        let navigationBar_Left = UIImage(named: "navbar_left_more")
        let navigationBar_Right = UIImage(named: "navbar_right_more")
        
        left_shadowImageView.image = navigationBar_Left
        right_shadowImageView.image = navigationBar_Right
    
        titleView.addSubview(left_shadowImageView)
//        titleView.addSubview(right_shadowImageView)
        titleView.addSubview(spreadBtn)
    }
    
    //MARK: 旋转展开按钮
    fileprivate func transitionSpreadBtn(toSpread : Bool) {
        UIView.animate(withDuration: 0.25) {
            let angle = toSpread ? M_PI * 1 : -M_PI * 1
            self.spreadBtn.transform = self.spreadBtn.transform.rotated(by: CGFloat(angle))
        }
    }
    
    
    //MARK: 展开按钮点击事件
    @objc fileprivate func spreadBtnClick(spreadBtn : UIButton) {
      
        // MARK: 展开收拢控制
        isOpen = false
        // cover 和 upPromptView通过参数交给内部scrollView控制显示隐藏
//        spreadView.doSpreadOrFold(toSpread: toSpread, cover: cover, upPromptView: upPromptView)
        // 与子控件scrollView同步高度，保证子控件能够响应事件
        self.view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: isOpen ? SpreadMaxH : titleViewH)
        // 旋转按钮layer图层
        transitionSpreadBtn(toSpread: isOpen)
        
        // 当编辑按钮在编辑状态时，收起时要复原
//        if !isOpen && (upPromptView.editBtn?.isSelected)! {
//            // 模拟用户点击了一下edit按钮
//            upPromptView.editButtonClick(editBtn: upPromptView.editBtn!)
//        }
//        spreadView.isSortStatus = !isOpen
//        self.tabBarController?.tabBar.isHidden = isOpen           //控制tabBar的隐藏或显示
//    }
        
        
        
    }
    
}

    
    
    
/*
            if isOpen == false {
            
                UIView.animate(withDuration: 0.25) {
                    // 逆时针旋转 按钮 180°
    //                self.spreadBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2 * 170))
                    
                    self.spreadBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2 * 170))
                    self.colletionView.frame.origin.y = screenH
                    self.colletionView.alpha = 0.2
                }
            
            } else {
                
                UIView.animate(withDuration: 0.25) {
                    // 逆时针旋转 还原按钮
                    self.spreadBtn.transform = CGAffineTransform.identity
                    self.colletionView.frame.origin.y = 10
                    self.colletionView.alpha = 1.0
                    
                }
                
            }
            
        }
    
    }
*/



// MARK:- 遵守PageTitleViewDelegate协议
extension NewsViewController : TitleViewDelegate {
    func titleView(_ titleView: TitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}

// MARK:- 遵守PageContentViewDelegate协议
extension NewsViewController : ContentViewDelegate {
    func contentView(_ contentView: ContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
}
