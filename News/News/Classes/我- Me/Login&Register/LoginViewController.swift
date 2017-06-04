//
//  LoginViewController.swift
//  News
//
//  Created by Liu Chuan on 2017/3/15.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    /// 手机号
    @IBOutlet weak var mobileField: UITextField!
    /// 密码
    @IBOutlet weak var passwordField: UITextField!
    /// 登录按钮
    @IBOutlet weak var loginButton: UIButton!
    /// 忘记密码按钮
    @IBOutlet weak var forgetPwdBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBar()
    }
    
    
    /// 配置导航栏
    private func configNavigationBar() {
//        navigationController?.title = "登录"
        navigationController?.navigationBar.barTintColor = darkGreen
        navigationController?.navigationBar.tintColor = .white
        
        // 修改导航栏文字颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // 隐藏返回按钮上的文字
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(regiisterButtonClick))

    }

    /// 取消按钮点击
    @objc private func cancelButtonClick() {
        dismiss(animated: true, completion: nil)
    }

    /// 注册按钮点击
    @objc private func regiisterButtonClick() {
        let registerVC = RegisterViewController()
        registerVC.title = "注册"
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    
    /// 返回按钮点击事件
    @objc private func backBtnClicked() {
        
        
        // searchBar 不再是第一响应, 收回键盘
        mobileField.resignFirstResponder()
        
        
        // 非模态返回
        _ = navigationController?.popViewController(animated: true)
        

    }

}
