//
//  ChannelViewController.swift
//  News
//
//  Created by Liu Chuan on 2017/3/14.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


private let itemW: CGFloat = (screenW - 100) * 0.25     // 单元格宽度

// 单元格重用标识符
private let collectionCell = "collectionCell"
private let collectionHead = "collectionHead"



class ChannelViewController: UIViewController {
    
    
    var headerArr = [["切换频道","点击添加更多频道"],["长按拖动排序","点击添加更多频道"]]
    var selectedArr = ["头条", "数码", "要闻","娱乐", "手机","体育", "视频", "财经", "汽车","军事", "时尚", "健康", "彩票", "搞笑","社会", "NBA", "图片","科技","国际","星座","电影","时尚","文化","游戏","教育","动漫","政务","纪录片","房产","佛学","股票","理财"]

    
    
    var recommendArr = ["有声","家居","电竞","美容","电视剧","搏击","健康","摄影","生活","旅游","韩流","探索","综艺","美食","育儿"]
    
    
    /// 是否编辑
    var isEdite = false

    
    //MARK: - 懒加载collectionView
    private lazy var collectionView: UICollectionView = {[weak self] in
        
        // UICollectionView 的layout 属性: 支持 Flow\ Custom 2中布局方式. 横排\纵排 -> 网格
        
        // 创建 UICollectionViewFlowLayout 布局对象
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: screenW, height: 40)   // 设置头部视图的尺寸
        layout.itemSize = CGSize(width: itemW, height: itemW * 0.5)     // 设置单元格的大小
        layout.minimumLineSpacing = 15                                  // 设置单元格之间的最小 行间距
        layout.minimumInteritemSpacing = 20                             // 设置单元格之间的最小 列间距
//        layout.scrollDirection = .vertical                              // 设置布局方向为: 水平滚动
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        // 创建collectionView
        
//        let frame = CGRect(x: 0, y: navigationH, width: screenW, height: screenH - navigationH)
        
        let collectionView = UICollectionView(frame: (self?.view.frame)!, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        // 注册cell
        collectionView.register(CollectionViewNormalCell.self, forCellWithReuseIdentifier: collectionCell)
        
        // 注册头部视图
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHead)
        
//        collectionV.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHead)
        
        // 创建手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
       
        collectionView.addGestureRecognizer(longPress)
        
        return collectionView
    }()

    
    
    private lazy var dragingItem: CollectionViewNormalCell = {
        
        let cell = CollectionViewNormalCell(frame: CGRect(x: 0, y: 0, width: itemW, height: itemW * 0.5))
        cell.isHidden = true
        return cell
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        configUI()
    }
    
    
    /// 配置UI界面
    private func configUI() {
        
        navigationItem.title = "频道管理"
        view.addSubview(collectionView)
        collectionView.addSubview(dragingItem)
    }
    
    
    //MARK: - 长按动作
    @objc private func longPressGesture(_ tap: UILongPressGestureRecognizer) {
    
        
    }
    
}



// MARK: - UICollectionViewDataSource 数据源协议
extension ChannelViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 0 ? selectedArr.count : recommendArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCell, for: indexPath) as! CollectionViewNormalCell
        
         cell.text = indexPath.section == 0 ? selectedArr[indexPath.item] : recommendArr[indexPath.item]
         cell.edite = (indexPath.section == 0 && indexPath.item == 0) ? false : isEdite
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        // 取出HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionHead, for: indexPath) as! CollectionHeaderView
        
        
        // 给HeaderView设置属性
        headerView.text = isEdite ? headerArr[1][indexPath.section] : headerArr[0][indexPath.section]
        
        headerView.button.isSelected = isEdite
       
        if indexPath.section > 0 {
            
            headerView.button.isHidden = true
        } else {
            headerView.button.isHidden = false
        }
        
        
        headerView.clickCallback = {[weak self] in
            
            self?.isEdite = !(self?.isEdite)!
            
            collectionView.reloadData()
            
        }
        return headerView
    }
    
}


// MARK: - UICollectionViewDelegate 代理协议
extension ChannelViewController: UICollectionViewDelegate {
    
    
    
}


