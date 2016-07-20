# 一款Mac小软件（用于上传图片到图床生成外链接(支持生成markdown链接)）
> 模仿iPic应用开发，感谢[Mac App 基础开发教程][1]学习指导，感谢[谷歌][2]的问题解答 
#### 上传图片到图床，然后直接生成图片链接到剪贴板(支持生成markdown链接)
#### 大大省去了写论坛，博客插图的麻烦事，配合[Chrome插件Markdown here][3]在一切可以写富文本的地方如微信公众号文章，方便快捷得插图



### 如果你觉得好，请Star✨下

#### 最新版本下载见最下面

---- 



##### 可能有未知bug，请通过 chenxtdo@gmail.com 给予反馈，阿里阿都
---- 

![Icon\_128x128.png][image-1]

#### 已有功能：
1. 拖拽图片文件到状态栏图标直接上传（随手一拖）
2. 复制图片文件，点击状态栏上传按钮上传（CMD＋C 图片后 点击应用上传件直接上传）
3. 用截图工具保存在剪贴板的图片，点击上传直接上传(**此处可能有BUG，现阶段通过七牛云的SDK进行上传，好像有点BUG，无法指定data的格式，也有可能操作有误。现阶段通过七牛云转码接口进行处理**)
4. 配置自己的图床（暂时支持七牛云）
5. 增加上传进度展示
6. 新增上传图片的展示，与最近5张的上传历史，点击直接复制链接
![146839423724135.png][image-2]


#### ToDo:

1. \~\~上传的历史列表（可以复制之前的链接）\~\~
2. \~\~上传进度展示（网速慢的时候我都不知道有没有在传呀。－ －！）\~\~
3. 多图同时上传(一次性好几张图一起来更佳爽)
5. 图片的比例更改（目前可以通过更改七牛云的链接进行裁剪，[七牛云图片处理文档][4]） 
6. 去掉SDK，通过API上传图片
4. 等等


#### 注意：

上传图片需要千牛云的token，该token是通过后台服务器获取的，返回给客户端，用于上传图片，为了不每次去获取token，本地会在获取一次后记录token。**可是，这个token可能过期，导致图片上传失败**（其实我也不太清楚会不会过期，😄）。这里需要你再一次尝试上传。

上传图片失败：**不是自定义配置信息错误，就是token过期**



#### 演示



> 下面演示的图标已经更换为最新图标，下图第二个图标

![14682270098979.png][image-3]

**公众号，邮件等可以富文本的地方插图**

![656852016-07-18 15\_58\_25.gif](http://7xqmjb.com1.z0.glb.clouddn.com/656852016-07-18 15\_58\_25.gif)

**拖拽上传：**

![2016-07-12 23\_00\_20.gif](http://oa3bvfelk.bkt.clouddn.com/637162016-07-12 23\_00\_20.gif)

**复制上传：**
![233512016-07-17 12\_46\_43.gif](http://oa3bvfelk.bkt.clouddn.com/233512016-07-17 12\_46\_43.gif)



![742212016-07-13 21\_53\_52.gif](http://7xqmjb.com1.z0.glb.clouddn.com/742212016-07-13 21\_53\_52.gif)


**截图上传：**

![2016-07-12 23\_32\_08.gif](http://7xqmjb.com1.z0.glb.clouddn.com/589982016-07-12 23\_32\_08.gif)


**使用上传历史**
![414832016-07-17 12\_40\_59.gif](http://oa3bvfelk.bkt.clouddn.com/414832016-07-17 12\_40\_59.gif)


**现在应该能满足基本需求，功能不断完善中**

[下载方式点击此处][5]

## License
This project is under MIT License. See LICENSE file for more information.

[1]:	http://www.macdev.io/
[2]:	https://www.google.com/
[3]:	http://markdown-here.com/
[4]:	http://developer.qiniu.com/code/v6/api/kodo-api/image/imageview2.html
[5]:	http://lzqup.com

[image-1]:	http://7xqmjb.com1.z0.glb.clouddn.com/54979Icon_128x128.png
[image-2]:	http://oa3bvfelk.bkt.clouddn.com/146839423724135.png?imageView2/0/format/png
[image-3]:	http://oa3bvfelk.bkt.clouddn.com/14682270098979.png?imageView2/0/format/png