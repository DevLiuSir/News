
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
        title = "登录"
//        baseSetNavLeftButtonWithTitle("取消")
//        baseSetNavRightButtonWithTitle("注册")
    }
    
//    override func baseNavLeftButtonPressed(_ button: UIButton) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    override func baseNavRightButtonPressed(_ button: UIButton) {
//        let registerVC = RegisterViewController.initFromNib()
    
    
    func clicked() {
    
        let nib = UINib(nibName: "LoginViewController", bundle: nil)
        
        let registerVC = nib.instantiate(withOwner: nil, options: nil)[0] as! LoginViewController
        
        navigationController?.pushViewController(registerVC, animated: true)
    }
    

}
