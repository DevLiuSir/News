//
//  MeViewController.swift
//  News
//
//  Created by Liu Chuan on 16/8/10.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit


/// 头部视图高度
private let headerViewH: CGFloat = 300

class MeViewController: UIViewController {
    
    /// 容器视图
    @IBOutlet weak var containerView: UIView!

    
    /// 头部视图
    var headerView: MyHeaderView = {
        let hdView = MyHeaderView.returnHeaderView()
        return hdView
    }()
    
    /// 波动视图
    var waveView: LCWaveView = {
//        let frame = CGRect(x: 0, y: headerViewH - 20, width: screenW, height: 20)
        
        let frame = CGRect(x: 0, y: 0, width: screenW, height: 20)
        let waveView = LCWaveView(frame: frame, color: UIColor.white)
        return waveView
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    /// 视图将被从屏幕上移除之前执行
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        navigationController?.navigationBar.lc_reset()
    
    }
    
    /// 视图即将显示之前执行
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) // 隐藏导航栏, 带动画
       
        // iOS7以后, 导航控制器中ScrollView\tableView顶部会添加 64 的额外高度
//        automaticallyAdjustsScrollViewInsets = false
    }
    
    
    /// 配置UI
    private func configUI() {
        
        configTableView()
        
        configNavigationBar()
        
        configHaderView()
        
        configWaveView()
    }
    
    
    
    
    /// 配置UITableView
    private func configTableView() {
        
        let table = containerView.subviews[0] as! UITableView
        
        table.backgroundColor = UIColor.groupTableViewBackground
        
        table.delegate = self
        
        // 设置表格顶部间距, 使得HaderView不被遮挡
        table.contentInset = UIEdgeInsets(top: headerViewH, left: 0, bottom: 0, right: 0)
    }

    /// 配置导航栏
    private func configNavigationBar() {
        
        // 设置导航栏背景色
        navigationController?.navigationBar.barTintColor = darkGreen
        
        // 修改导航栏文字颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    /// 配置头部视图
    private func configHaderView() {
        
        headerView.iconButtonClick = {
            let nib = UINib(nibName: "LoginViewController", bundle: nil)
            
            
            let loginVC = nib.instantiate(withOwner: nil, options: nil)[0] as! LoginViewController
            
//            let registerVC = nib.instantiate(withOwner: nil, options: nil)[0] as! RegisterViewController
            
            
            self.present(loginVC, animated: true, completion: nil)
            
            
//            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(300)
        }
    }
    
    /// 配置波纹视图
    private func configWaveView() {
        waveView.waveSpeed = 1                                      // 设置拨动速度 (0 - 1)
        
        
        let tableV = containerView.subviews[0] as! UITableView
        tableV.tableHeaderView = waveView
        
//        headerView.addSubview(waveView)
//      waveView.addOverView(oView: headerView.bgImageView)      // 添加跳动的头像
        waveView.startWave()                                        // 开始浮动
    }
}

// MARK: - 遵守 UITableViewDelegate 协议
extension MeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 18
    }
    
    // MARK: 显示\隐藏 导航栏
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /*
         contentOffset: 即偏移量,contentOffset.y = 内容的顶部和frame顶部的差值,contentOffset.x = 内容的左边和frame左边的差值.
         contentInset:  即内边距,contentInset = 在内容周围增加的间距(粘着内容),contentInset的单位是UIEdgeInsets
         */
        // 偏移量: -200 + 顶部边距: 200, 等于0
        let offsetY = scrollView.contentOffset.y + scrollView.contentInset.top
//        print(offsetY)
        
/*
         // 放大图像
         if offsetY <= 0 {
            // 调整HeaderView\ HeaderImage
            headerView.frame.origin.y = 0
            
            // 增大 Headerview 高度
            headerView.snp.makeConstraints { (make) in
                make.height.equalTo(headerViewH - offsetY)
            }
            
            headerView.bgImageView.alpha = 1
            // 图像视图 Y 值不变
            headerView.bgImageView.frame.origin.y = 0
            
            // 图像视图高度 = HeadView高度
            headerView.bgImageView.frame.size.height = headerViewH - offsetY
            
         } else {    // 整体移动
        
            headerView.frame.size.height = headerViewH
            headerView.frame.origin.y = -offsetY
         
            /// HeaderView最小的Y值
            let headerViewMinY = headerViewH - navigationH
            // min函数: 取最小值
            headerView.frame.origin.y = -min(headerViewMinY, offsetY)
            // 设置透明度
            // 根据输出, 得知当 offsetY / headerViewMinY == 1时,不可见图像
         
            //print(offsetY / headerViewMinY)
            let progress = 1 - (offsetY / headerViewMinY)
            headerView.bgImageView.alpha = progress
            
         
         }
    }
    
*/
// ==============


        guard offsetY <= 0 else {
            
            // MARK: 整体移动
            headerView.frame.size.height = headerViewH
            headerView.frame.origin.y = -offsetY
            
            /// HeaderView最小的Y值
            let headerViewMinY = headerViewH - navigationH - statusH  // 显示导航栏
            //let headerViewMinY = headerviewH - statusH              // 显示状态栏
            
            // min函数: 取最小值
            headerView.frame.origin.y = -min(headerViewMinY, offsetY)
            
            // 设置透明度
            // 根据输出, 得知当 offsetY / headerViewMinY == 1时,不可见图像
            print(offsetY / headerViewMinY)
            let progress = 1 - (offsetY / headerViewMinY)
            headerView.bgImageView.alpha = progress
            
            return
        }
        
        // MARK: 放大图像
        // 调整HeaderView\ HeaderImage
        headerView.frame.origin.y = 0
        
        // 增大 Headerview 高度
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(headerViewH - offsetY)
        }
        
        // 图像视图 Y 值不变
        headerView.bgImageView.frame.origin.y = 0
        headerView.bgImageView.alpha = 1
        
        // 图像视图高度 = HeadView高度
        headerView.bgImageView.frame.size.height = headerViewH - offsetY
    }

}

// MARK: - 监听事件
extension MeViewController {
   
    /// 开关按钮点击事件
    ///
    /// - Parameter sender: UISwitch
    @IBAction func swicthBtn(_ sender: UISwitch) {
        
        if sender.isOn == true {
            //            tableView.backgroundColor = UIColor.darkGray
            containerView.subviews[0].backgroundColor = UIColor.darkGray
        } else {
            //            tableView.backgroundColor = UIColor.groupTableViewBackground
             containerView.subviews[0].backgroundColor = UIColor.groupTableViewBackground
        }
        
    }
    
}
