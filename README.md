
# 资讯新闻类APP.


![](https://camo.githubusercontent.com/f3bc68f8badf9ec1143275e35cba2114910b0522/687474703a2f2f696d672e736869656c64732e696f2f62616467652f6c616e67756167652d73776966742d627269676874677265656e2e7376673f7374796c653d666c6174)
[![Swift compatible](https://img.shields.io/badge/swift-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift/)
[![Swift &3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
![](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg)
![](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![](https://img.shields.io/github/watchers/badges/shields.svg?style=social&label=Watch)


## Swift项目-仿网易新闻客户端
### 效果图: 

![](https://ws1.sinaimg.cn/mw690/c3a20316gy1fdegatfuhjg20bj0j64qu)

## 说明
数据接口来源: 通过 Charles 抓包获得.

## 环境设置
- 项目环境
	- Xcode 8.2.1（低于这个版本会报错）。
	- Swift 3.0.2
	- iOS 10.0 +
- 使用 cocoaPods 管理第三方库
- 项目中使用的第三方库
	- SnapKit： 布局
	- Kingfisher： 缓存图片
	- SVProgressHUD：提示框 (待集成)
	- FDFullscreenPopGesture：侧滑 (待集成)
	- Alamofire ：网络请求
	- SwiftyJSON：解析 json数据

# 实现的功能

1. 获取网易新闻数据接口
2. 完成首页的布局和数据的显示
3. 实现首页顶部标题栏(TitleView)和内容视图(contentView)的联动
4. 新闻详情界面简单实现 (待完善)
5. 自定义刷新框架
6. 启动界面的简单实现动画谈出


# 项目所用API

附上API

- 新闻顶部轮播图数据 http://c.m.163.com/nc/ad/headline/0-4.html
- 首页新闻数据 http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html 
- 天气预报接口http://c.3g.163.com/nc/weather/省份|城市.html 
- 图片接口 http://image.baidu.com/wisebrowse/data?tag1=一级分类&tag2=二级分类 
- 视频接口  http://c.m.163.com/nc/video/home/0-10.html 
- 直播 http://data.live.126.net/livechannel/previewlist.json
- 近期热点  http://c.m.163.com/nc/search/hotWord.html
- 热点 http://c.3g.163.com/recommend/getSubDocPic?passport=&devId=B45E64F7-002F-4126-8C7E-3DB0ACF6C85E&size=40

###待完善```


