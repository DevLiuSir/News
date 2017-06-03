//
//  LCWaveView.swift
//  News
//
//  Created by Liu Chuan on 2017/3/15.
//  Copyright © 2017年 LC. All rights reserved.
//


import UIKit


class LCWaveView: UIView {

    /// 角速度
    var waveFrequency: CGFloat = 1.5
    /// 速度
    var waveSpeed: CGFloat = 0.6
    /// 高度
    var waveHeight: CGFloat = 5
    /// 真实图层
    fileprivate var realWaveLayer: CAShapeLayer = CAShapeLayer()
    /// 蒙版图层
    fileprivate var maskWaveLayer: CAShapeLayer = CAShapeLayer()
    /// 浮动view
    var overView: UIView?
    /// 时间
    fileprivate var timer: CADisplayLink?
    
    /// 真实图层颜色
    var realWaveColor: UIColor = UIColor.white {
        didSet {
            realWaveLayer.fillColor = realWaveColor.cgColor
        }
    }
    /// 蒙版图层颜色
    var maskWaveColor: UIColor = UIColor.orange {
        didSet {
            maskWaveLayer.fillColor = maskWaveColor.cgColor
        }
    }
    /// 偏距
    fileprivate var offset: CGFloat = 0
    
    fileprivate var priFrequency: CGFloat = 0
    fileprivate var priWaveSpeed: CGFloat = 0
    fileprivate var priWaveHeight: CGFloat = 0
    
    /// 开始
    fileprivate var isStarting: Bool = false
    
    /// 停止
    fileprivate var isStopping: Bool = false
    
    /// init View
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var f = self.bounds
        f.origin.y = frame.size.height
        f.size.height = 0
        maskWaveLayer.frame = f
        realWaveLayer.frame = f
        
        self.backgroundColor = .clear
        self.layer.addSublayer(realWaveLayer)
        self.layer.addSublayer(maskWaveLayer)
        
    }
    /// convenience init
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        
        realWaveColor = color
        maskWaveColor = color.withAlphaComponent(0.7)
        
        realWaveLayer.fillColor = realWaveColor.cgColor
        maskWaveLayer.fillColor = maskWaveColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 添加漂浮view
    func addOverView(oView: UIView) -> Void {
        overView = oView
        overView?.center = self.center
        overView?.frame.origin.y = self.frame.height - (overView?.frame.height)!
        self.addSubview(overView!)
    }
    
    /// 开始浮动
    func startWave() -> Void {
        if !isStarting {
            stop()
            isStarting = true
            isStopping = false
            priWaveHeight = 0
            priFrequency = 0
            priWaveSpeed = 0
            
            timer = CADisplayLink(target: self, selector: #selector(waveEvent))
            timer?.add(to: .current, forMode: .commonModes)
        }
    }
    
    /// 停止浮动
    func stop() -> Void {
        
        guard timer != nil else {return}
        timer?.invalidate() // 移除定时器
        timer = nil
    }
    
    
    func stopWave() -> Void {
        
        if !isStopping {
            isStarting = false
            isStopping = true
        }
    }
    
    /// 浮动事件
    func waveEvent() -> Void {
        
        if isStarting {

            guard priWaveHeight < waveHeight else {
                isStarting = false
                return
            }
            var f = self.bounds
            priWaveHeight = priWaveHeight + waveHeight/100.0
            f.origin.y = f.size.height - priWaveHeight
            f.size.height = priWaveHeight
            maskWaveLayer.frame = f
            realWaveLayer.frame = f
            priFrequency = priFrequency + waveFrequency/100.0
            priWaveSpeed = priWaveSpeed + waveSpeed/100.0
            
        }

        if isStopping {
            
            guard priWaveHeight > 0 else {
                isStopping = false
                stopWave()
                return
            }
            priWaveHeight = priWaveHeight - waveHeight / 50.0
            var f = self.bounds
            f.origin.y = f.size.height
            f.size.height = priWaveHeight
            maskWaveLayer.frame = f
            realWaveLayer.frame = f
            priFrequency = priFrequency - waveFrequency / 50.0
            priWaveSpeed = priWaveSpeed - waveSpeed / 50.0
        }

        
        offset += priWaveSpeed
        
        let width = frame.width
        let height = CGFloat(priWaveHeight)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height))
        var y: CGFloat = 0
        
        let maskPath = CGMutablePath()
        maskPath.move(to: CGPoint(x: 0, y: height))
        
        let offset_f = Float(offset * 0.045)
        let waveFrequency_f = Float(0.01 * priFrequency)
        
        for x in 0...Int(width) {
            y = height * CGFloat(sinf(waveFrequency_f * Float(x) + offset_f))
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            maskPath.addLine(to: CGPoint(x: CGFloat(x), y: -y))
        }

        guard overView != nil else {
            
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
            realWaveLayer.path = path
            
            maskPath.addLine(to: CGPoint(x: width, y: height))
            maskPath.addLine(to: CGPoint(x: 0, y: height))
            maskPath.closeSubpath()
            maskWaveLayer.path = maskPath
            return
        }
        
        let centX = self.bounds.size.width / 2
        let centY = height * CGFloat(sinf(waveFrequency_f * Float(centX) + offset_f))
        let center = CGPoint(x: centX , y: centY + self.bounds.size.height - overView!.bounds.size.height/2 - priWaveHeight - 1 )
        
        overView?.center = center

    }
}
