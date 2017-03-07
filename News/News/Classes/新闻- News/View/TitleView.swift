//
//  TitleView.swift
//  News
//
//  Created by Liu Chuan on 2016/11/11.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

// MARK:- 定义协议
protocol TitleViewDelegate : class {
    func titleView(_ titleView : TitleView, selectedIndex index : Int)
}

// MARK:- 定义全局常量
private let NormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)          // 默认状态下的颜色
private let SelectColor : (CGFloat, CGFloat, CGFloat) = (60,179,113)          // 选择状态下的暗绿色

//private let SelectColor : (CGFloat, CGFloat, CGFloat) = (30, 144, 255)        // 选择状态下的颜色


// MARK:标题视图
// MARK: - 定义TitleView类
class TitleView: UIView {
    
    // MARK: - 定义属性
    //    fileprivate var titles: [String]
    
    fileprivate var currentIndex : Int = 0          // 当前的下标值
    fileprivate var margin : CGFloat = 0
    
    fileprivate lazy var channels = ChannelModel.channels()  // 频道列表
    
    weak var delegate : TitleViewDelegate?
    
    
    // MARK: - 懒加载属性
    // 定义titleLabels 记录 UILabel
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    // 滚动视图
    fileprivate lazy var scrollView: UIScrollView = {
       
        // 创建 UIScrollView
        let scrollView = UIScrollView()
        
        // 是否显示水平指示器
        scrollView.showsHorizontalScrollIndicator = false
        
/*       scrollsToTop 是 UIScrollView 的一个属性.
         主要用于点击设备的状态栏时，是scrollsToTop == true的控件滚动返回至顶部。
         每一个默认的UIScrollView的实例，他的 scrollsToTop 属性默认为YES，
*/
        scrollView.scrollsToTop = false
        scrollView.delegate = self
        
        // 设置是否边缘弹动效果, 默认为true.表示开启动画，设置为false时，当滑动到边缘就是无效果
        scrollView.bounces = true
        
        return scrollView
        
    }()
    
    
    // MARK: - 底部滚动滑块
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        return scrollLine
    }()
    

//    // MARK:- 自定义构造函数
//    init(frame: CGRect, titles: [String]) {
//        
//        self.titles = titles
//        super.init(frame: frame)
//        
//        setupUI()
//        
//    }
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 设置UI
        setupUI()
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK:- 设置UI界面
extension TitleView {
    
    fileprivate func setupUI() {
        // 添加 Scrollview
        addSubview(scrollView)
        
        scrollView.frame = bounds
        
        // 添加title对应的Label
        setUpTitleLabels()
        
        // 设置底线和滚动的滑块
        setupBottomLineAndScrollLine()

    }
    
    // MARK:- 分类底部滑块\长线
    fileprivate func setupBottomLineAndScrollLine() {
        
/*
         // 添加底部长线
         let bottomLine = UIView()
         bottomLine.backgroundColor = UIColor.lightGray
         
         // 底部长线条的高度
         let lineH : CGFloat = 1.0
         //底线的 y: 标题滚动视图的高度 + 导航栏的高度 + 状态栏的高度 - 底线的高度
         bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
         
         // 添加scrollLine 底部长线
         addSubview(bottomLine)
*/
        // MARK: 设置滑块的 View
        // 获取第一个Label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = colorLan
        
        let lineX = firstLabel.frame.origin.x
        let lineY = frame.height - scrollLineH   //bounds.height - scrollLineH
        let lineW = firstLabel.frame.width
        let lineH = scrollLineH
        
        
        // 设置scrollLine的属性
        scrollLine.frame = CGRect(x: lineX, y: lineY, width: lineW, height: lineH)
        
 /*
        
        let templabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        templabel.text = firstLabel.text;
        templabel.sizeToFit()
        
        margin = firstLabel.frame.width / 2 - templabel.frame.width / 2
        
        scrollLine.frame = CGRect(x: firstLabel.frame.width / 2 - templabel.frame.width / 2 , y: frame.height - scrollLineH, width: templabel.frame.width, height: scrollLineH)
        
*/
        
        scrollLine.backgroundColor = colorLan
        scrollView.addSubview(scrollLine)
    }
 
    
    
    // MARK:- 设置标题栏的分类
    fileprivate func setUpTitleLabels() {
        /*
         * 临时常量\变量
         标题的个数必须和数组的个数相同"
         定义一个常量表示标题按钮的个数, 即就是数组元素的个数
         */
        let labelWidth: CGFloat = 60
        let labelHeight: CGFloat = frame.height - scrollLineH
        let labelY: CGFloat = 0
        
//        for (index, title) in titles.enumerated() {
        
        for index in 0 ..< channels.count {
            
            // 创建 Label
            let label = UILabel()
            
            // 设置 Label的属性
            label.text = channels[index].tname
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            label.isUserInteractionEnabled = true   // 开启 Label 用户交互
            
            // 设置 Label 的 frame
            let labelX: CGFloat = labelWidth * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
            
            // 给Label添加手势点击事件
            label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(labelClick(_:))))
            
            // 将label添加到 titleView 的 scrollView 中
            scrollView.addSubview(label)
            
            // 将 label 加到 titleLabels 数组中
            titleLabels.append(label)
            
            // 如何标签索引为 0, 设置第一个Label颜色
            if index == 0 {
                let firstLabel = titleLabels.first
                firstLabel?.textColor = colorLan
            }
        }
        
        // 设置 (标题\内容) 滚动视图的滚动范围
       // scrollView.contentSize = CGSize(width: titles.count * Int(labelWidth), height: 0)
        scrollView.contentSize = CGSize(width: channels.count * Int(labelWidth), height: 0)
        
    }
}

//MARK:- 监听顶部 label手势点击事件
extension TitleView {
    
    @objc fileprivate func labelClick(_ tap: UITapGestureRecognizer) {
        
        print(tap.view!)
        
        // MARK: - 标题居中
        // 本质: 修改 标题滚动视图 的偏移量
        // 偏移量 = label 的中心 * 减去屏幕宽度的一半
        
        // 获取当前 label
        let index = tap.view as? UILabel
        
        var offset: CGPoint = scrollView.contentOffset
        offset.x = (index?.center.x)! - screenW * 0.5
        
        // 最大的偏移量 = scrollView的宽度 减去 屏幕的宽度
        let offsetMax = scrollView.contentSize.width - screenW
        
        // 如果偏移量小于0, 就不居中, 而且如果偏移量 小于最大偏移量, 让偏移量 = 最大偏移量, 从而实现不居中
        // 左边超出处理
        if offset.x < 0  {
            offset.x = 0
        } else if (offset.x > offsetMax) {  //右边超出的处理
            offset.x = offsetMax
        }
        
        // 滚动标题,带动画
        scrollView.setContentOffset(offset, animated: true)
        
        // 获取当前 label
        guard let currentLabel = tap.view as? UILabel else { return }
        
        // 如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 获取之前的 label
        let oldLabel = titleLabels[currentIndex]
        
        //MARK:- 切换文字的颜色
        currentLabel.textColor = colorLan
        oldLabel.textColor = UIColor.darkGray
        
        //MARK:- 标题字体缩放: 通过改变label的大小
        // CGAffineTransform(scaleX: _ )     : 设置缩放比例. 仅通过设置缩放比例就可实现视图扑面而来和缩进频幕的效果。
        // label缩放的同时添加动画
        UIView.animate(withDuration: 0.25) {
            currentLabel.transform =  CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        
        UIView.animate(withDuration: 0.25) {
            // 还原缩放大小
            oldLabel.transform = CGAffineTransform.identity
        }
        // 保存最新Label的下标值
        currentIndex = currentLabel.tag
        
        // 改变滚动条的位置
        // 底部滑块的 X 值: 当前下标值 * 底部滑块的宽度
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        //给滑块添加动画
        UIView.animate(withDuration: 0.25) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
    
        // 通知代理
        delegate?.titleView(self, selectedIndex: currentIndex)
    }

}

// MARK:- 对外暴露的方法
extension TitleView : UIScrollViewDelegate {

    
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
    
/*
        let beforeTitle = titleLabels[sourceIndex]      // 以前的标题
        let targetTitle = titleLabels[targetIndex]      // 目标标题
        
        let templabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        templabel.text = beforeTitle.text
        templabel.sizeToFit()
        
        let moveX = (targetTitle.frame.origin.x - beforeTitle.frame.origin.x) * progress
        
        let isLimit : Bool = moveX == targetTitle.frame.origin.x - beforeTitle.frame.origin.x
        
        if !isLimit {
            
            if moveX > 0  {
                
                scrollLine.frame.size.width = templabel.frame.size.width + (templabel.frame.size.width + self.margin * 2) * progress * 2
                //判定下划线是否跳跃
                if progress < 0.5 {
                    
                    scrollLine.frame.size.width = templabel.frame.size.width + (templabel.frame.size.width + self.margin * 2) * progress * 2
                    scrollLine.frame.origin.x = beforeTitle.frame.origin.x + margin
                }else{
                    scrollLine.frame.size.width = templabel.frame.size.width + (templabel.frame.size.width + self.margin * 2) - (templabel.frame.size.width + self.margin * 2) * (progress * 2 - 1)
                    scrollLine.frame.origin.x = beforeTitle.frame.origin.x + margin + (templabel.frame.size.width + self.margin * 2) * (progress * 2 - 1)
                }
                
            }else{
                
                if progress < 0.5 {
                    
                    scrollLine.frame.size.width = templabel.frame.size.width + (templabel.frame.size.width + self.margin * 2) * progress * 2
                    scrollLine.frame.origin.x = targetTitle.frame.origin.x + margin - (templabel.frame.size.width + self.margin * 2) * (progress * 2 - 1)
                    
                }else{
                    
                    scrollLine.frame.size.width = templabel.frame.size.width + (templabel.frame.size.width + self.margin * 2) - (templabel.frame.size.width + self.margin * 2) * (progress * 2 - 1)
                    scrollLine.frame.origin.x = targetTitle.frame.origin.x + margin
                }
                
                
            }
        }

*/

         // 1.取出normal_Label/selected_Label
         let normal_Label = titleLabels[sourceIndex]       // 默认的label
         let selected_Label = titleLabels[targetIndex]     // 选择状态的label
         
        // 2.处理滑块的逻辑
         let moveTotalX = selected_Label.frame.origin.x - normal_Label.frame.origin.x   // 总的滑动距离值
         let moveX = moveTotalX * progress                                              // 需要滑动的x值
         scrollLine.frame.origin.x = normal_Label.frame.origin.x + moveX                // 改变滚动条的位置
 
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出 红\黄\蓝 变化的范围
        let colorDelta = (SelectColor.0 - NormalColor.0, SelectColor.1 - NormalColor.1, SelectColor.2 - NormalColor.2)

        // 3.2.变化默认Label
        normal_Label.textColor = UIColor(red: SelectColor.0 - colorDelta.0 * progress, green: SelectColor.1 - colorDelta.1 * progress, blue: SelectColor.2 - colorDelta.2 * progress)

        // 3.2.变化选择状态下的label
        selected_Label.textColor = UIColor(red: NormalColor.0 + colorDelta.0 * progress, green: NormalColor.1 + colorDelta.1 * progress, blue: NormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
        

        
        // 获取当前页码
        let index = Int(scrollView.contentOffset.x / screenW * 0.5)

//        // 获取左边的按钮
//        let LeftLabel = titleLabels[index]
//        
//        // 获取右边的按钮
//        var RightLabel = UILabel()
//        let indexR = index + 1
//        let count = titleLabels.count
//        if indexR < count  {
//            RightLabel = titleLabels[Int(indexR)]
//        }
        
        // 计算缩放比例
        let scale = scrollView.contentOffset.x / screenW * 0.5
        let scaleR = scale -  CGFloat(index)
        let scaleL = 1 - scaleR
        
        // 设置按钮形变
        UIView.animate(withDuration: 0.3) {
            normal_Label.transform = CGAffineTransform(scaleX: scaleR * 0.3 + 1, y:  scaleR * 0.3 + 1)
            selected_Label.transform = CGAffineTransform(scaleX: scaleL * 0.3 + 1, y: scaleL * 0.3 + 1)
        }
        
        
        
        
/*
        // MARK: - 缩放标题
        // label缩放的同时添加动画
        UIView.animate(withDuration: 0.3) {
            // 原label 放大1.0倍 = 还原
            normal_Label.transform = CGAffineTransform.identity
//            self.scrollLine.transform = CGAffineTransform.identity
        }
        
        
        UIView.animate(withDuration: 0.3) {
            // 目标 label 放大1.2倍
            selected_Label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            // 缩放滑块
//            self.scrollLine.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
 
*/
        
        
        
        
        
        
        
        // MARK: - 标题居中
        // 本质: 修改 标题滚动视图 的偏移量
        // 偏移量 = label 的中心 X 减去屏幕宽度的一半
       
        
        // 获取之前的 label
        // let old_Label = titleLabels[currentIndex]
        
        var offset: CGPoint = scrollView.contentOffset
        offset.x = selected_Label.center.x - screenW * 0.5
        
        // 最大的偏移量 = scrollView的宽度 减去 屏幕的宽度
        let offsetMax = scrollView.contentSize.width - screenW
        
        // 如果偏移量小于0, 就不居中, 而且如果偏移量 小于最大偏移量, 让偏移量 = 最大偏移量, 从而实现不居中
        // 左边超出处理
        if offset.x < 0  {
            offset.x = 0
        } else if (offset.x > offsetMax) {  //右边超出的处理
            offset.x = offsetMax
        }
        
        // 滚动标题,带动画
        scrollView.setContentOffset(offset, animated: true)
        
    }
 
 
// MARK: - 点击状态栏,回到顶部
    //首先要设置 _scrollView.scrollsToTop = YES;
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}


