//
//  RefreshView.swift
//  News
//
//  Created by Liu Chuan on 2016/11/18.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit


private let Cycle_Cell = "CycleCell"


// MARK: - 自定义轮播视图
class  CycleView: UIView {
    
    
    // MARK: - 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // MARK: - 懒加载 cycleModels对象
    fileprivate lazy var cycleModels: [CycleViewModel] = [CycleViewModel]()

    // MARK: - 定义模型属性
    var cycleTimer : Timer?
    
    
    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK: 设置改控件不随着父控件拉伸而拉伸
         autoresizingMask = UIViewAutoresizing(rawValue: 0)

        // 注册 cell
        collectionView.register(UINib(nibName: "CycleViewCell", bundle: nil), forCellWithReuseIdentifier: Cycle_Cell)
        
    }
    
    // 布局尺寸必须在 layoutSubViews 中, 否则获取的 size 不正确
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        
        // 设置 CollectionView 界面
        setup_CollectionView_UI()
        
        // 请求轮播数据
        requestCycleData()
        
        // 添加定时器: 先移除 ,再添加定时器
        removeCycleTimer()
        addCycleTimer()
    }

}


// MARK: - 提供一个通过 Xib 快速创建的类方法
extension  CycleView {

    class func Load_CycleView() -> CycleView {
        return Bundle.main.loadNibNamed("CycleView", owner: nil, options: nil)?.first as! CycleView
    }
    
     // MARK: 设置 collectionView 界面
    fileprivate func setup_CollectionView_UI() {
        
        // 设置collectionView的布局
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 设置 collectionView 单元格大小
        layout.itemSize = collectionView.bounds.size
        
        // 设置单元格之间的最小 行间距
        layout.minimumLineSpacing = 0
        
        // 设置单元格之间的最小 列间距
        layout.minimumInteritemSpacing = 0
        
        // 设置布局方向为: 水平滚动
        layout.scrollDirection = .horizontal
        
        // 是否分页显示
        collectionView.isPagingEnabled = true
        
        // 是否显示 水平\ 垂直方向指示器
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    
    }
    
    // MARK: 对定时器操作方法
    // 自动滚动功能: 添加定时器. 每隔3秒钟自动滚动到下一个
    
    // MARK: 添加定时器
    fileprivate func addCycleTimer() {
    
        cycleTimer = Timer(timeInterval: 3, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
       
        // 将定时器加入运行循环
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    // MARK: 移除定时器
    fileprivate func removeCycleTimer() {
        cycleTimer?.invalidate()    // 从运行循环中移除
        cycleTimer = nil
    }
    // MARK: 滚动到下一页
    @objc fileprivate func scrollToNext() {
        
        // 滚动collectionView
        // 获取当前滚动偏移量
        let currentOffSet = collectionView.contentOffset.x + collectionView.bounds.width
        // 滚动到位置
        collectionView.setContentOffset(CGPoint(x: currentOffSet, y: 0), animated: true)
    }


}

// MARK: -遵守 UIColletionView 数据源协议
extension CycleView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return cycleModels.count * 10000     //返回无限个数
    }
    
    // 设置cell数据
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cycle_Cell, for: indexPath) as! CycleViewCell
       
        cell.cycleModel = cycleModels[indexPath.item % cycleModels.count]
        
        return cell
        
    }
}


// MARK: -遵守 UIColletionView 代理协议
extension CycleView : UICollectionViewDelegate {
    
    // MARK: 随着用户的滚动，改变pageControl的显示
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 获取滚动的偏移量
        let offset = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
 
        // 计算 pageControl 的 currentIndex
        pageControl.currentPage = Int(offset / scrollView.bounds.width) % 5
        
    }
    
    // 开始拖拽时, 移除定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    // 结束拖拽, 添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}


extension CycleView  {
    
    // MARK: 请求轮播数据
    func requestCycleData() {
        
        NetworkTool.requsetData("http://c.m.163.com/nc/ad/headline/0-5.html", type: .get)  { (result: Any) in

            // 将 Any 类型转换成字典类型
            guard let resultDictionary = result as? [String : Any] else { return }
            
            // 根据 headline 的key 取出内容
            guard let dataArray = resultDictionary["headline_ad"] as? [[String : Any]] else { return }

            // 遍历字典, 将字典转换成模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleViewModel(dict: dict))
            }
            
            // 刷新表格
            self.collectionView.reloadData()
        }
    }
}
