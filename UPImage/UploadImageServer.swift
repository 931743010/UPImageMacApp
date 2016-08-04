//
//  UploadImageServer.swift
//  UPImage
//
//  Created by Pro.chen on 16/7/9.
//  Copyright © 2016年 chenxt. All rights reserved.
//

import Foundation
import Qiniu
import Alamofire

func arc() -> UInt32 { return arc4random() % 100000 }

func timeInterval() -> Int {
	
	return Int(NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970)
}

var isUseSet: Bool {
	get {
		if let isUseSet = NSUserDefaults.standardUserDefaults().valueForKey("isUseSet") {
			return isUseSet as! Bool
		}
		return false
	}
	set {
		NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "isUseSet")
	}
	
}

var uploadUrl = "getToken"
var setQiniuUrl = "setQNConfig"
var picUrlPrefix = "http://7xqmjb.com1.z0.glb.clouddn.com/"

var QiniuToken: String {
	get {
		if let QiniuToken = NSUserDefaults.standardUserDefaults().valueForKey("QiniuToken") {
			return QiniuToken as! String
		}
		return ""
	}
	set {
		NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "QiniuToken")
	}
	
}

var timeQiniuToken: Int {
	get {
		if let timeQiniuToken = NSUserDefaults.standardUserDefaults().valueForKey("timeQiniuToken") {
			return timeQiniuToken as! Int
		}
		return 0
	}
	set {
		NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "timeQiniuToken")
	}
	
}

var UUID: String {
	get {
		if let UUID = NSUserDefaults.standardUserDefaults().valueForKey("UUID") {
			return UUID as! String
		}
		return ""
	}
	set {
		NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "UUID")
	}
	
}

var urlPrefix: String {
	get {
		if let urlPrefix = NSUserDefaults.standardUserDefaults().valueForKey("urlPrefix") {
			return urlPrefix as! String
		}
		return ""
	}
	set {
		NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "urlPrefix")
	}
	
}

var accessKey: String {
	get {
		if let accessKey = NSUserDefaults.standardUserDefaults().valueForKey("accessKey") {
			return accessKey as! String
		}
		return ""
	}
	set {
		NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "accessKey")
	}
	
}

var secretKey: String {
	get {
		if let secretKey = NSUserDefaults.standardUserDefaults().valueForKey("secretKey") {
			return secretKey as! String
		}
		return ""
	}
	set {
		NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "secretKey")
	}
	
}

var bucket: String {
	get {
		if let bucket = NSUserDefaults.standardUserDefaults().valueForKey("bucket") {
			return bucket as! String
		}
		return ""
	}
	set {
		NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "bucket")
	}
	
}

func QiniuUpload(pboard: NSPasteboard) {
	
	var param: [String: AnyObject]?
	
	// 是否自定义
	if isUseSet {
		param = ["id": UUID]
		picUrlPrefix = urlPrefix
		
	} else {
		picUrlPrefix = "http://7xqmjb.com1.z0.glb.clouddn.com/"
		param = nil
	}
	
	let files: NSArray? = pboard.propertyListForType(NSFilenamesPboardType) as? NSArray
	
	// Token时效验证机制，59分钟重置
	if timeInterval() - timeQiniuToken > 60 * 59 {
		QiniuToken = ""
		timeQiniuToken = timeInterval()
	}
	
	if let files = files {
		statusItem.button?.image = NSImage(named: "loading-\(0)")
		statusItem.button?.image?.template = true
		
		guard let _ = NSImage(contentsOfFile: files.firstObject as! String) else {
			return
		}
		
		if QiniuToken != "" {
			
			QiniuSDKUpload(files.firstObject as? String, data: nil, token: QiniuToken)
		} else {
			HttpRequest(Resource(path: uploadUrl, method: .GET, param: param, headers: nil), completion: { (result) in
				result.failure({ (error) in
					NotificationMessage("服务器炸了", informative: "我会尽快修复，请通过email: chenxtdo@gmail.com  联系我，或点击使用说明中下载最新版")
					
					statusItem.button?.image = NSImage(named: "StatusIcon")
					statusItem.button?.image?.template = true
					return
				})
					.success({ (value) in
						guard let token = value.valueForKeyPath("data")?.valueForKeyPath("token") as? String else {
							return
						}
						QiniuToken = token
						print("2" + token)
						QiniuSDKUpload(files.firstObject as? String, data: nil, token: token)
				})
			})
		}
		
	}
	
	guard let data = pboard.pasteboardItems?.first?.dataForType("public.tiff") else {
		return
	}
	guard let _ = NSImage(data: data) else {
		return
	}
	
	statusItem.button?.image = NSImage(named: "loading-\(0)")
	statusItem.button?.image?.template = true
	
	if QiniuToken != "" {
		
		QiniuSDKUpload(nil, data: data, token: QiniuToken)
		
	} else {
		
		HttpRequest(Resource(path: uploadUrl, method: .GET, param: param, headers: nil), completion: { (result) in
			result.failure({ (error) in
				NotificationMessage("服务器炸了", informative: "我会尽快修复，请通过email: chenxtdo@gmail.com  联系我，或点击使用说明中下载最新版")
				statusItem.button?.image = NSImage(named: "StatusIcon")
				statusItem.button?.image?.template = true
				
				return
			})
				.success({ (value) in
					guard let token = value.valueForKeyPath("data")?.valueForKeyPath("token") as? String else {
						return
					}
					QiniuToken = token
					QiniuSDKUpload(nil, data: data, token: token)
			})
		})
	}
	
}

func QiniuSDKUpload(filePath: String?, data: NSData?, token: String) {
	let upManager = QNUploadManager()
	let opt = QNUploadOption(progressHandler: { (key, percent) in
		
		statusItem.button?.image = NSImage(named: "loading-\(Int(percent*10))")
		statusItem.button?.image?.template = true
		
	})
	
	if let filePath = filePath {
		
		let fileName = "\(arc())" + NSString(string: filePath).lastPathComponent
		
		upManager.putFile(filePath, key: fileName, token: token, complete: { (info, key, resp) in
			statusItem.button?.image = NSImage(named: "StatusIcon")
			statusItem.button?.image?.template = true
			guard let _ = info, let _ = resp else {
				QiniuToken = ""
				NotificationMessage("上传图片失败", informative: "可能是配置信息错误，或者是Token过去。请仔细检查配置信息，或重新上传")
				return
			}
			NSPasteboard.generalPasteboard().clearContents()
			NSPasteboard.generalPasteboard()
			NSPasteboard.generalPasteboard().setString("![" + NSString(string: filePath).lastPathComponent + "](" + picUrlPrefix + key + ")", forType: NSStringPboardType)
			NotificationMessage("上传图片成功", isSuccess: true)
			var picUrl: String!
			if linkType == 0 {
				picUrl = "![" + key + "](" + picUrlPrefix + key + ")"
			}
			else {
				picUrl = picUrlPrefix + key
			}
			NSPasteboard.generalPasteboard().setString(picUrl, forType: NSStringPboardType)
			
			let cacheDic: [String: AnyObject] = ["image": NSImage(contentsOfFile: filePath)!, "url": picUrlPrefix + key]
			adduploadImageToCache(cacheDic)
			
			}, option: opt)
	}
	
	if let data = data {
		
		let fileName = "\(timeInterval())" + "\(arc()).jpg"
		
		upManager.putData(data, key: fileName, token: token, complete: { (info, key, resp) in
			
			statusItem.button?.image = NSImage(named: "StatusIcon")
			statusItem.button?.image?.template = true
			
			guard let _ = info, let _ = resp else {
				QiniuToken = ""
				NotificationMessage("上传图片失败", informative: "可能是配置信息错误，或者是Token过去。请仔细检查配置信息，或重新上传")
				return
			}
			NotificationMessage("上传图片成功", isSuccess: true)
			NSPasteboard.generalPasteboard().clearContents()
			NSPasteboard.generalPasteboard()
			var picUrl: String!
			if linkType == 0 {
				picUrl = "![" + key + "](" + picUrlPrefix + key + "?imageView2/0/format/jpg)"
			}
			else {
				picUrl = picUrlPrefix + key + "?imageView2/0/format/jpg"
			}
			
			NSPasteboard.generalPasteboard().setString(picUrl, forType: NSStringPboardType)
			
			let cacheDic: [String: AnyObject] = ["image": NSImage(data: data)!, "url": picUrlPrefix + key + "?imageView2/0/format/jpg"]
			adduploadImageToCache(cacheDic)
			
			}, option: opt)
	}
}

func NotificationMessage(message: String, informative: String? = nil, isSuccess: Bool = false) {
	
	let notification = NSUserNotification()
	let notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
	notificationCenter.delegate = appDelegate as? NSUserNotificationCenterDelegate
	notification.title = message
	notification.informativeText = informative
	if isSuccess {
		notification.contentImage = NSImage(named: "success")
		notification.informativeText = "链接已经保存在剪贴板里，可以直接粘贴"
	} else {
		notification.contentImage = NSImage(named: "Failure")
	}
	
	notification.soundName = NSUserNotificationDefaultSoundName;
	notificationCenter.scheduleNotification(notification)
	
}
