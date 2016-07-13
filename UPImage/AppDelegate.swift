//
//  AppDelegate.swift
//  UPImage
//
//  Created by Pro.chen on 16/7/10.
//  Copyright © 2016年 chenxt. All rights reserved.
//

import Cocoa
import MASPreferences
import TMCache

func checkImageFile(pboard: NSPasteboard) -> Bool {
	
	let files: NSArray = pboard.propertyListForType(NSFilenamesPboardType) as! NSArray
	let image = NSImage(contentsOfFile: files.firstObject as! String)
	guard let _ = image else {
		return false
	}
	return true
}

var version: Int {
	get {
		if let version = NSUserDefaults.standardUserDefaults().valueForKey("version") {
			return version as! Int
		}
		return 5
	}
	set {
		NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "version")
	}
	
}

let updata = "checkVersion.php"

var appDelegate: NSObject?

var statusItem: NSStatusItem!

var imagesCacheArr: [[String: AnyObject]] = Array()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	@IBOutlet weak var window: NSWindow!
	
	@IBOutlet weak var statusMenu: NSMenu!
	@IBOutlet weak var cacheImageMenu: NSMenu!
	
	@IBOutlet weak var uploadMenuItem: NSMenuItem!
	
	@IBOutlet weak var cacheImageMenuItem: NSMenuItem!
	lazy var preferencesWindowController: NSWindowController = {
		
		let imageViewController = ImagePreferencesViewController()
		let controllers = [imageViewController]
		let wc = MASPreferencesWindowController(viewControllers: controllers, title: "设置")
		imageViewController.window = wc.window
		return wc
	}()
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
		if UUID == "" {
			UUID = NSUUID().UUIDString
		}
		window.center()
		appDelegate = self
		statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
		let statusBarButton = DragDestinationView(frame: (statusItem.button?.bounds)!)
		statusItem.button?.superview?.addSubview(statusBarButton, positioned: .Below, relativeTo: statusItem.button)
		let iconImage = NSImage(named: "StatusIcon")
		iconImage?.template = true
		statusItem.button?.image = iconImage
		statusItem.button?.action = #selector(showMenu)
		statusItem.button?.target = self
	}
	
	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
	
	func showMenu() {
		
		let pboard = NSPasteboard.generalPasteboard()
		let files: NSArray? = pboard.propertyListForType(NSFilenamesPboardType) as? NSArray
		
		if let files = files {
			let i = NSImage(contentsOfFile: files.firstObject as! String)
			i?.scalingImage()
			uploadMenuItem.image = i
			
		} else {
			let i = NSImage(pasteboard: pboard)
			i?.scalingImage()
			uploadMenuItem.image = i
		}
		
		let object = TMCache.sharedCache().objectForKey("imageCache")
		if let obj = object as? [[String: AnyObject]] {
			imagesCacheArr = obj
			
		}
		cacheImageMenuItem.submenu = makeCacheImageMenu(imagesCacheArr)
		
		statusItem.popUpStatusItemMenu(statusMenu)
	}
	
	@IBAction func statusMenuClicked(sender: NSMenuItem) {
		switch sender.tag {
			// 上传
		case 1:
			let pboard = NSPasteboard.generalPasteboard()
			QiniuUpload(pboard)
			// 设置
		case 2:
			preferencesWindowController.showWindow(nil)
			preferencesWindowController.window?.center()
			NSApp.activateIgnoringOtherApps(true)
		case 3:
			// 退出
			NSApp.terminate(nil)
			
		case 4:
			NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.jianshu.com/p/66d453d99c71")!)
		case 5:
			checkVersion()
		default:
			break
		}
		
	}
	
	@IBAction func btnClick(sender: NSButton) {
		switch sender.tag {
		case 1:
			NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.jianshu.com/p/66d453d99c71")!)
			self.window.close()
		case 2:
			self.window.close()
			
		default:
			break
		}
	}
	
	func makeCacheImageMenu(imagesArr: [[String: AnyObject]]) -> NSMenu {
		let menu = NSMenu()
		if imagesArr.count == 0 {
			let item = NSMenuItem(title: "没有历史", action: nil, keyEquivalent: "")
			menu.addItem(item)
		} else {
			for index in 0..<imagesArr.count {
				let item = NSMenuItem(title: "", action: #selector(cacheImageClick(_:)), keyEquivalent: "")
				item.tag = index
				let i = imagesArr[index]["image"] as? NSImage
				i?.scalingImage()
				item.image = i
				menu.addItem(item)
			}
		}
		
		return menu
	}
	
	func cacheImageClick(sender: NSMenuItem) {
		
		NSPasteboard.generalPasteboard().clearContents()
		let picUrl = imagesCacheArr[sender.tag]["url"] as! String
		
		NSPasteboard.generalPasteboard().setString(picUrl, forType: NSStringPboardType)
		
	}
	
	func checkVersion() {
		HttpRequest(Resource(path: updata, method: .GET, param: ["version": version], headers: nil)) { (result) in
			result.failure({ (error) in
				if error.code == 110 {
					NotificationMessage("已经使用的是最新版本", informative: "更新一些实用的功能，请随时保持关注", isSuccess: true)
				}
			}).success({ [weak self](value) in
				
				self?.window.makeKeyAndOrderFront(nil)
				
				NSApp.activateIgnoringOtherApps(true)
			})
		}
	}
	
}

extension AppDelegate: NSUserNotificationCenterDelegate {
	// 强行通知
	func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
		return true
	}
	
}

