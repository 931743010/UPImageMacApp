# 一款小软件（用于上传图片生成markdown格式的外链接）
> 模仿iPic应用开发，感谢[Mac App 基础开发教程](http://www.macdev.io/)学习指导，感谢[谷歌](https://www.google.com/)的问题解答 
####上传图片到图床，然后直接生成markdown的图片链接到剪贴板




###如果你觉得好，请Star✨下

#### 最新版本下载（以下链接是最新的，更新请下载进行覆盖）

[点击下载](http://7xqmjb.com1.z0.glb.clouddn.com/U%E5%9B%BE%E5%BA%8A0.9.dmg)



___



#####可能有未知bug，请通过 chenxtdo@gmail.com 给予反馈，阿里阿都
___

![Icon_128x128.png](http://7xqmjb.com1.z0.glb.clouddn.com/54979Icon_128x128.png)

####已有功能：
1. 拖拽图片文件到状态栏图标直接上传（随手一拖）
2. 复制图片文件，点击状态栏上传按钮上传（CMD＋C 图片后 点击应用上传件直接上传）
3. 用截图工具保存在剪贴板的图片，点击上传直接上传(**此处可能有BUG，现阶段通过七牛云的SDK进行上传，好像有点BUG，无法指定data的格式，也有可能操作有误。现阶段通过七牛云转码接口进行处理**)
4. 配置自己的图床（暂时支持七牛云）
5. 增加上传进度展示
6. 新增上传图片的展示，与最近5张的上传历史，点击直接复制链接
![146839423724135.png](http://oa3bvfelk.bkt.clouddn.com/146839423724135.png?imageView2/0/format/png)


####ToDo:

1. ~~上传的历史列表（可以复制之前的链接）~~
2. ~~上传进度展示（网速慢的时候我都不知道有没有在传呀。－ －！）~~
3. 多图同时上传(一次性好几张图一起来更佳爽)
5. 图片的比例更改（目前可以通过更改七牛云的链接进行裁剪，[七牛云图片处理文档](http://developer.qiniu.com/code/v6/api/kodo-api/image/imageview2.html)） 
6. 去掉SDK，通过API上传图片
4. 等等


#### 注意：

上传图片需要千牛云的token，该token是通过后台服务器获取的，返回给客户端，用于上传图片，为了不每次去获取token，本地会在获取一次后记录token。**可是，这个token可能过期，导致图片上传失败**（其实我也不太清楚会不会过期，😄）。这里需要你再一次尝试上传。

上传图片失败：**不是自定义配置信息错误，就是token过期**



#### 演示



> 下面演示的图标已经更换为最新图标，下图第二个图标

![14682270098979.png](http://oa3bvfelk.bkt.clouddn.com/14682270098979.png?imageView2/0/format/png)



**拖拽上传：**

![2016-07-12 23_00_20.gif](http://oa3bvfelk.bkt.clouddn.com/637162016-07-12 23_00_20.gif)

**复制上传：**

![2016-07-12 23_25_23.gif](http://oa3bvfelk.bkt.clouddn.com/641462016-07-12 23_25_23.gif)


![742212016-07-13 21_53_52.gif](http://7xqmjb.com1.z0.glb.clouddn.com/742212016-07-13 21_53_52.gif)


**截图上传：**

![2016-07-12 23_32_08.gif](http://7xqmjb.com1.z0.glb.clouddn.com/589982016-07-12 23_32_08.gif)


**现在应该能满足基本需求，功能不断完善中**



##License
This project is under MIT License. See LICENSE file for more information.

