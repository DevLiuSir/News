
//
//  EditChannelView.swift
//  News
//
//  Created by Liu Chuan on 2017/3/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


// 重用标识符
private let reuseIdentifier = "hotSearch"
private let reuseHeaderIdentifier = "hotHeader"
private let ShakeAnimationKey = "ShakeAnimationKey"

private let collectionHeaderHeight: CGFloat = 55    // 集合视图头部高度
private let itemHeight: CGFloat = 30                // 单元格的高度
private let interval: CGFloat = 10                  // 集合视图cell之间的间距
private let intervalCount: CGFloat = 5              // 5个间隔
private let lineItemCount: CGFloat = 4              // 每行item个数

// MARK: - 编辑频道视图
class EditChannelView: UIView {

    
    /// 模型属性
//    fileprivate lazy var channels: [ChannelModel] = [ChannelModel]()
    
    /// 频道分类
    //    fileprivate lazy var editChannelTitles = ChannelModel.channels()
    
    fileprivate lazy var channels = ChannelModel.channels()  // 频道列表
    
    /*
     
     var channelTitles: [NewsModel] = [] {
     didSet {
     collectionView.reloadData()
     }
     }
     */
 
    var editChannelTitles = [HomeTopDataModel]()
    
    var channelTitles: [HomeTopDataModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
 
    var isHasEdit = false  //是否是编辑状态
    

    
    /// 集合视图
    fileprivate lazy var collectionView: UICollectionView = {
        
        // 创建布局, 并设置其相关属性
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical           // 设置布局方向
        
        // 设置单元格大小
        layout.itemSize = CGSize(width: (screenW - interval * intervalCount) / lineItemCount, height: itemHeight)
        
        
        // 创建集合视图, 并设置集合视图相关属性
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenW, height: self.frame.height), collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true          // 总是垂直弹动
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 添加间距
        collectionView.contentInset = UIEdgeInsets(top: navigationH + statusH, left: 0, bottom: 0, right: 0)
        
        // 注册cell
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.register(HotSearchCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // 注册头部
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        
        return collectionView
        
    }()

    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)  // 添加控件

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 默认频道列表: 正常状态
    func normalChannel() {
        isHasEdit = false
        collectionView.reloadData()
    }
    /// 编辑频道列表: 编辑状态
    func editChannel() {
        isHasEdit = true
        collectionView.reloadData()
    }

}

// MARK: - 遵守 UICollectionViewDataSource 协议
extension EditChannelView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
//        if isHasEdit == false { // 是否处于编辑
//            return editChannelTitles.count > 0 ? 2 : 1
//        }
//        return 1
//        
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if section == 0 {
//            return channelTitles.count
//        }
//        return editChannelTitles.count
        
//        return 20
        
        
        return channels.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HotSearchCollectionViewCell
       
//        let hotTitle = channels[indexPath.item].tname
//        cell.hotButton.setTitle(hotTitle, for: .normal)
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        cell.backgroundColor = UIColor.orange
        
        


        if indexPath.section == 0 { // 第一组
            
            
            // 取出模型, 根据模型判断模型的属性
//            let channel = channelTitles[indexPath.item].tname
//            cell.hotButton.setTitle(channel, for: .normal)
            
            
            let hotTitle = channels[indexPath.item].tname
            cell.hotButton.setTitle(hotTitle, for: .normal)
            cell.hotButton.removeTarget(self, action: #selector(cellItemButtonClick(button:)), for: .touchUpInside)
        
            if isHasEdit {
               
                if indexPath.item == 0 {    // 设置第一个item
                    
                    cellItemBackGroundColor(cell: cell, backGroundColor: UIColor.clear, titleColor: UIColor.lightGray, borderColor: UIColor.clear.cgColor, cornerRadius: 0, hiddenDeleteButton: true)
                
                } else {    // 设置其他item
//                    cellItemBackGroundColor(cell: cell, backGroundColor: UIColor.white, titleColor: UIColor.darkGray, borderColor: BaseColor.BorderColor.cgColor, cornerRadius: 3, hiddenDeleteButton: false)
                    
                    cellItemBackGroundColor(cell: cell, backGroundColor: UIColor.white, titleColor: UIColor.darkGray, borderColor: UIColor.gray.cgColor, cornerRadius: 3, hiddenDeleteButton: false)
                    
                    addAnimation(cell: cell)
                    
                    cell.deleteButton.addTarget(self, action: #selector(deleteItem(button:)), for: .touchUpInside)
                    
                    cell.deleteButton.tag = indexPath.item
                    
                    
//                    cell.deleteButton.Base_setUserInfo(obj_: cell.deleteButton, value: channel)
                }
            } else {
                
                
//                cellItemBackGroundColor(cell: cell, backGroundColor: UIColor.white, titleColor: BaseColor.GrayColor, borderColor: BaseColor.BorderColor.cgColor, cornerRadius: 3, hiddenDeleteButton: true)
                
                
                cellItemBackGroundColor(cell: cell, backGroundColor: UIColor.white, titleColor: UIColor.darkGray, borderColor: UIColor.gray.cgColor, cornerRadius: 3, hiddenDeleteButton: true)
                
                removeAnimation(cell: cell)
            }
        } else {
            
            cellItemBackGroundColor(cell: cell, backGroundColor: UIColor.white, titleColor: UIColor.gray, borderColor: UIColor.gray.cgColor, cornerRadius: 3, hiddenDeleteButton: true)
            
            
            removeAnimation(cell: cell)
            
//            let channel = editChannelTitles[indexPath.item]
//            cell.hotButton.setTitle(channel.name, for: .normal)
            
            let channel = channels[indexPath.item].tname
            cell.hotButton.setTitle(channel, for: .normal)
            cell.hotButton.addTarget(self, action: #selector(cellItemButtonClick(button:)), for: .touchUpInside)
            cell.hotButton.tag = indexPath.item
            
//            cell.hotButton.Base_setUserInfo(obj_: cell.hotButton, value: channel)
            
        }
 
 
 
        return cell
    }
   
    
    // 头部视图
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
        
        if indexPath.section == 1 {
        
            /// 头部
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath)
           
            /// 创建头部View
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: 55))
            
            /// 头部标签
            let headerLabel = UILabel(frame: CGRect(x: 0, y: 10, width: screenW, height: 35))
            headerLabel.text = "    点击添加更多频道"
            headerLabel.textColor = UIColor.white
            headerLabel.backgroundColor = UIColor.darkGray
            headerLabel.font = UIFont.systemFont(ofSize: 15)
            
            headerView.addSubview(headerLabel)
            reusableView.addSubview(headerView)
            
            return reusableView
        }
         
        return UICollectionReusableView()
    }
    

}


// MARK: - 遵守 UICollectionViewDelegateFlowLayout 布局协议
extension EditChannelView: UICollectionViewDelegateFlowLayout {
    
    // MARK: 设置单元格边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    }
    
    // MARK: 设置头部视图尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
     
        if section == 1 {
            return CGSize(width: screenW, height: collectionHeaderHeight)
        }
        return CGSize(width: screenW, height: 0)
        
    }
   
    
}


// MARK: - 扩展方法
extension EditChannelView {
    
    /// 自动回滚到顶部
    func scrollToTop() {
        var offset = self.collectionView.contentOffset
        offset.y = -self.collectionView.contentInset.top
        self.collectionView.setContentOffset(offset, animated: false)
    }
    
    
    
    /// 设置item状态
    func cellItemBackGroundColor(cell:HotSearchCollectionViewCell,backGroundColor: UIColor,titleColor: UIColor,borderColor: CGColor,cornerRadius:CGFloat,hiddenDeleteButton: Bool) {
        
        cell.hotButton.layer.borderColor = borderColor
        cell.hotButton.layer.cornerRadius = cornerRadius
        cell.hotButton.backgroundColor = backGroundColor
        cell.hotButton.setTitleColor(titleColor, for: .normal)
        cell.deleteButton.isHidden = hiddenDeleteButton
    }
    /// 添加动画
    func addAnimation(cell:HotSearchCollectionViewCell) {
        
        if cell.containerView.layer.animation(forKey: ShakeAnimationKey) == nil {
            
            // CAKeyframeAnimation: 帧动画，做一些连续的流畅的动画。
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
            
            /* values	NSArray对象。里面的元素称为“关键帧”(keyframe)。
             动画对象会在指定的时间（duration）内，依次显示values数组中的每一个关键帧*/
            
            animation.values = [(-M_PI_4 * 0.03), (M_PI_4 * 0.03), (-M_PI_4 * 0.03)]
            
            /*removedOnCompletio : 默认为true，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。
             如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为kCAFillModeForwards */
            
            animation.isRemovedOnCompletion = false         // 完成后,是否被移除
            animation.fillMode = kCAFillModeForwards        // 当动画结束后,layer会一直保持着动画最后的状态
            animation.duration = 0.2                        // 动画的持续时间（秒）
            animation.repeatCount = MAXFLOAT                // 重复次数，无限循环可以设置HUGE_VALF或者MAXFLOAT
            
            // 给cell添加动画
            cell.containerView.layer.add(animation, forKey: ShakeAnimationKey)
        }
    }
    
    /// 移除动画
    func removeAnimation(cell:HotSearchCollectionViewCell) {
        cell.hotButton.layer.removeAnimation(forKey: ShakeAnimationKey)
    }
    
    func deleteItem(button: UIButton) {
//        channelTitles.remove(at: button.tag)
//        let channel = Base_getUserInfo(obj_: button) as! HomeTopDataModel
//        editChannelTitles.append(channel)
        
        
        print("deleteItem=========")
    }
    
    func cellItemButtonClick(button: UIButton) {

//        editChannelTitles.remove(at: button.tag)
//        let channel = Base_getUserInfo(obj_: button) as! HomeTopDataModel
//        channelTitles.append(channel)
        print("cellItemButtonClick ============")
    }

    
}
