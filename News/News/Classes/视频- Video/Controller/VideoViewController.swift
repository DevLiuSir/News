//
//  VideoViewController.swift
//  News
//
//  Created by Liu Chuan on 16/8/10.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class VideoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏背景色
        navigationController?.navigationBar.barTintColor = colorLan
        //修改导航栏文字颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}
