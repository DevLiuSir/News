
//
//  SearchViewController.swift
//  News
//
//  Created by Liu Chuan on 2016/9/25.
//  Copyright © 2016年 LC. All rights reserved.
//



import UIKit

// MARK: - 重用标识符
private let reuseIdentifier = "hotSearch"
private let reuseHeaderIdentifier = "hotHeader"

private let layout_minimumLineSpacing: CGFloat = 10         // 单元格之间的最小 行间距
private let layout_minimumInteritemSpacing: CGFloat = 0     // 单元格之间的最小 列间距
private let itemWidth: CGFloat = screenW / 2 - 15           // 单元格宽度
private let itemHeight: CGFloat = 30                        // 单元格高度
private let headerHeight: CGFloat = 40                      // 集合视图头部高度


class SearchViewController: UIViewController {
    
    // MARK: - 懒加载
    /// 模型vedioListModels对象
    fileprivate lazy var search_models: [SearchModel] = [SearchModel]()
    
    /// 搜索条
    lazy var searchBar: UISearchBar = {
    
//     fileprivate lazy var searchBarController : UISearchController = {
        
        let searchBar = UISearchBar()
        
//        let searchController = UISearchController(searchResultsController: nil)
        
        // 设置搜索框风格
//        searchBar.searchBarStyle = UISearchBarStyle.default
        
        
        // 开始输入时，背景是否变暗
//        searchController.dimsBackgroundDuringPresentation = false
        
        
        // 设置搜索条渲染颜色 , 光标颜色
        searchBar.tintColor = darkGreen
        
        // 设置搜索条背景颜色
//        searchBar.barTintColor = UIColor.yellow
        
        // 设置搜索框的提示文字
        searchBar.placeholder = "搜索你感兴趣的内容"
        
        // 自动调整搜索框大小
        searchBar.sizeToFit()
        
        // 是否显示范围栏
        searchBar.showsScopeBar = true
      
        
        // MARK: 改变提示文字颜色\输入框背景
        
        // 现在我们来获取它， 并且设置颜色为咖啡色
        
        // 首先取出textfield
        //let searchBarTextField: UIView = (searchBar.subviews.first?.subviews.first)!

        // 首先取出textfield
//        let searchFiled = searchController.searchBar.value(forKey: "searchFiled") as? UITextField
        
//        let searchFiled = searchBar.value(forKey: "searchFiled") as? UITextField
        
        
        // 然后取出textField的placeHolder
//        let PlaceholderLabel = searchFiled?.value(forKey: "placeholderLabel") as? UILabel
//        PlaceholderLabel?.textColor = UIColor.red
        
        // 设置输入框里面的背景颜色
//        searchFiled?.backgroundColor = UIColor(red:0.19, green:0.24, blue:0.29, alpha:1.00)
//        searchFiled?.leftViewMode = UITextFieldViewMode.never
        
        searchBar.delegate = self
        
        
        return searchBar
        
        
//        return searchController
        
    }()
    
    /// 集合视图
    fileprivate lazy var collectionView: UICollectionView = {
        
        // 创建布局
        let layout = UICollectionViewFlowLayout()
        
        // 设置集合视图: 头视图的大小
        layout.headerReferenceSize = CGSize(width: screenW, height: headerHeight)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)    // 设置单元格的大小
        layout.minimumLineSpacing = layout_minimumLineSpacing             // 设置单元格之间的 最小 行间距
        layout.minimumInteritemSpacing = layout_minimumInteritemSpacing   // 设置单元格之间的 最小 列间距
        layout.scrollDirection = .vertical                                // 设置布局方向为: 水平滚动
        
        // 创建集合视图
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), collectionViewLayout: layout)
        

        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true          // 总是垂直弹动
        
        // 使得 collectionView 的高度/宽度 随着父控件拉伸而拉伸
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
 
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 设置collectionView边距
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // 注册cell\头部
        collectionView.register(HotSearchCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
       
        return collectionView
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configUI()
        requestSearchData()
    }
    
    
    /// 配置UI
    private func configUI() {
        
        view.addSubview(collectionView)
        
        configNavigationBar()
        
    }
    
    /// 配置导航栏
    private func configNavigationBar() {
        navigationController?.navigationBar.barTintColor = darkGreen
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "  取消", style: .plain, target: self, action: #selector(backButtonClick))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15)], for: .normal)
    }
    
    // MARK: 取消按钮点击事件
    @objc private func backButtonClick() {
        
        searchBar.resignFirstResponder()        // searchBar 不再是第一响应, 收回键盘
        
        // 非模态返回
        _ = navigationController?.popViewController(animated: true)
        
        // 模态返回
        //_ = navigationController?.dismiss(animated: true, completion: nil)
    
    }
}

// MARK: - 遵守 UICollectionViewDataSource 协议
extension SearchViewController: UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search_models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // 根据模型取出属性
//        let rankNumber = vedioList_Models[indexPath.item].rank          //热门搜索数字
        
        let hotTitle = search_models[indexPath.row].hotWord
        
        // 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HotSearchCollectionViewCell
       
        cell.hotButton.setTitle(hotTitle, for: .normal)                 // 设置热门搜索中按钮的文字
        cell.hotButton.setBackgroundImage(UIImage(named: "" ), for: .normal)
        //        cell.hotButton.addTarget(self, action: #selector(hotBtnClicked), for: .touchUpInside)
        
//        cell.deleteButton.isHidden = true                               // 隐藏删除按钮
//        cell.RankLabel.text = "\(rankNumber)"                           // 设置排行榜文字
        
//        // 根据模型 rank 属性 设置标签背景色
//        switch rankNumber {
//        case 1:
//            cell.RankLabel.backgroundColor = UIColor.red
//        case 2:
//            cell.RankLabel.backgroundColor = UIColor(red:0.87, green:0.33, blue:0.12, alpha:1.00)
//        case 3:
//            cell.RankLabel.backgroundColor = UIColor(red:0.88, green:0.46, blue:0.13, alpha:1.00)
//        default:
//            cell.RankLabel.backgroundColor = UIColor(red:0.21, green:0.27, blue:0.31, alpha:1.00)
//            break
//        }
        return cell
        
    }
    // MARK: 集合视图头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        /// 头部视图
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath)
     
        /// 头部标签
        let headerLabel = UILabel()
        headerLabel.text = "热门搜索"
        headerLabel.textColor = UIColor.lightGray
        headerLabel.font = UIFont.systemFont(ofSize: 15)
        
        /// 换一换按钮
        let exchangeBtn = UIButton()
        exchangeBtn.setImage(UIImage(named: "mbReload"), for: .normal)
        exchangeBtn.setTitle("换一换", for: .normal)
        exchangeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        exchangeBtn.setTitleColor(UIColor.lightGray, for: .normal)
   
        // 添加控件
        reusableView.addSubview(headerLabel)
        reusableView.addSubview(exchangeBtn)
        
        // MARK: SnapKit布局
        headerLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        exchangeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.top)
            make.right.equalTo(10)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        
        return reusableView
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let ad = search_models[indexPath.item].hotWord
     
        
    }
    
    // 移动cell
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
}

// MARK: - 遵守UISearchBarDelegate 协议
extension SearchViewController: UISearchBarDelegate {

    // MARK: 当搜索框内文本发生改变时,自动进行搜索. 触发该方法
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
    }
    // MARK: 开始编辑时,调用
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        print("正在编辑.........")
    }
    
    
    // MARK: 结束编辑时,调用
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        //        searchBar.becomeFirstResponder()
        //        searchBar.resignFirstResponder()
    }
    
    
    //MARK: 键盘中的搜索按钮的点击事件
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
    
    // MARK: 当点击搜索框进行编辑时,触发该方法
    // false: searchBar 成为第一响应者  true: searchBar 不成为第一响应者
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        // 点击搜索框弹出键盘
//        searchBar.becomeFirstResponder()
        searchBar.resignFirstResponder()
        //controlAccessoryView

        return true
    }
    
    
    //searchDisplayControllerDidBeginSearch
    

//
//    // MARK: 当点击搜索框结束编辑时,触发该方法
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//
//        // false: searchBar 结束第一响应者 true: searchBar 不会结束第一响应者
//        return true
//    }
    
  
    

    
}


// MARK: - 请求搜索数据
extension SearchViewController {
    
    /// 请求搜索数据
    func requestSearchData() {
        
        NetworkTool.requsetData("http://c.m.163.com/nc/search/hotWord.html", type: .get) { ( result: Any) in
            
            // 将 Any 类型转换成字典类型
            guard let resultDict = result as? [String : Any] else { return }
            
            // 根据 hotWordList 的 key 取出内容
            guard let dataArray = resultDict["hotWordList"] as? [[String : Any]] else { return }
            
            // 遍历字典, 将字典转换成模型对象
            for dict in dataArray {
                self.search_models.append(SearchModel(dict: dict))
            }
            // 刷新集合视图
            self.collectionView.reloadData()
        }
    }
}

// MARK: - 点击事件
extension SearchViewController {
    
//    @objc fileprivate func hotBtnClicked() {
//        
//        print("...........")
//    }
}




