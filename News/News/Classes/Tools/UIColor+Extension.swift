//
//  UIColor+Extension.swift
//  News
//
//  Created by Liu Chuan on 2016/9/25.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

// MARK: - UIcolor 扩展
extension UIColor {
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
    
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}
