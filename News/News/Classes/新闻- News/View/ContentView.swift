//
//  ContentView.swift
//  News
//
//  Created by Liu Chuan on 2016/9/26.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit


protocol ContentViewDelegate : class {
    func contentView(_ contentView : ContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

// 单元格重用标识符
private let identify = "cell"
private let contentCell = "contentViewCell"


//MARK: - 内容视图
class ContentView: UIView {

    // MARK: - 定义属性
    fileprivate var childVCs: [UIViewController]
    
    fileprivate weak var parentViewController: UIViewController?
    
    fileprivate var startOffsetX : CGFloat = 0
    
    fileprivate var isForbidScrollDelegate : Bool = false       // 是否禁止代理方法
    
    weak var delegate : ContentViewDelegate?
    
    
    
    fileprivate lazy var channels = ChannelModel.channels()  // 频道列表
    
    
    
    
    
    //MARK: - 懒加载属性
   
    //MARK: 集合视图: UICollectionView
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        
        // 创建 UICollectionViewFlowLayout 布局对象
        // UICollectionView 的layout 属性: 支持 Flow\ Custom 2中布局方式. 横排\纵排 -> 网格
        
        let layout = UICollectionViewFlowLayout()
        
         // 设置单元格的大小
        layout.itemSize = (self?.bounds.size)!
        
        // 设置单元格之间的最小 行间距
        layout.minimumLineSpacing = 0
        
        // 设置单元格之间的最小 列间距
        layout.minimumInteritemSpacing = 0
        
        // 设置布局方向为: 水平滚动
        layout.scrollDirection = .horizontal
        
        // 创建UICollectionView
        // CGRect.Zero: 是一个高度和宽度为零、位于(0，0)的矩形常量
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // 是否显示水平方向指示器
        collectionView.showsVerticalScrollIndicator = false
        
        // 是否分页显示
        collectionView.isPagingEnabled = true
        
        // 设置边缘是否弹动效果
        collectionView.bounces = false
        
        // 设置点击状态栏是否回到顶部
        collectionView.scrollsToTop = false
        
        // 设置 collectionView 数据源\代理为当前类
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 注册 cell. 由于内容滚动视图没用 storyboard， 因此需要注册。
        collectionView.register(UINib(nibName: "ContentViewCell", bundle: nil), forCellWithReuseIdentifier: contentCell)
        
        return collectionView

    }()
    
    
    // MARK: - 自定义构造函数
    // 参数: frame\ 对应的控制器 \ 父控制器
    init(frame: CGRect, childVCs: [UIViewController], parentViewController: UIViewController) {
       
        self.childVCs = childVCs
        self.parentViewController = parentViewController

        super.init(frame: frame)
        
        // 设置 UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


//MARK: - 设置 UI 界面
extension ContentView {
    
     func setupUI() {
        
        // 将所有的子控制器添加到父控制器中
        for childV in childVCs {
            parentViewController?.addChildViewController(childV)
        }
        // 添加 UICollectionView, 方便 cell 中存放控制器的 View
        addSubview(collectionView)
     
        collectionView.frame = bounds
     
    }
}


// MARK: - 遵守 UICollectionViewDataSource 数据源协议
extension ContentView: UICollectionViewDataSource {
    
    // 设置collectionView单元格的数量
    // 每一组有多少条数据
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return childVCs.count
    }
    
    // 初始化\返回集合视图的单元格
    // 每一行 cell 的显示具体内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCell, for: indexPath) as! ContentViewCell
/*
        // 设置cell内容
        // cell 有循环利用, 可能会添加多次, 因此先把之前的移除, 再添加
        // 移除之前的
        for view in cell.contentView.subviews {
            // 先移除所有的view，还有优化的空间
            view.removeFromSuperview()
        }
        // 取出控制器
        let childV = childVCs[indexPath.item]
        childV.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childV.view)
*/
        return cell

    }
    
}

// MARK: - 遵守 UICollectionViewDelegate 协议
extension ContentView: UICollectionViewDelegate {
    
    // 开始拖拽时,调用
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
        
    }
    // 滚动完成时,调用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 判断是否是点击事件
        if isForbidScrollDelegate { return }
    
        // 定义获取需要的数据
        var progress: CGFloat = 0   // 当前滚动的进度
        var sourceIndex: Int = 0    // 起始位置下标值
        var targetIndex: Int = 0    // 目标位置下标值
        
        // 获取进度
        let currentOffsetX = scrollView.contentOffset.x
        let ratio = currentOffsetX / scrollView.bounds.width
        progress = ratio - floor(ratio)
        
        let scrollViewW = scrollView.bounds.width
        
        // 判断滑动的方向. 左滑/右滑
        if currentOffsetX > startOffsetX { // 向左滑动
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
            
        }
        
        // 3.通知代理. 将progress/sourceIndex/targetIndex传递给titleView
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
}

// MARK: - 对外暴露的方法
extension ContentView {
     func setCurrentIndex(_ currentIndex : Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
