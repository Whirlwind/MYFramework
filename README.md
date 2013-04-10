MYFramework
===========

一款采用Notification和Router为核心思想的Framework。

-----------

安装方法

使用CocoaPods进行安装： pod 'MYFramework', :git=>'https://github.com/Whirlwind/MYFramework.git'

使用方法

在pch中加入：#import "MYFramework.h"
将*AppDelegate继承自MYFrameworkAppDelegate，注意先import "MYFrameworkAppDelegate.h"，删除无用的Delegate方法，所有Delegate均要加上[super ...]

广播文件格式(.broadcast)

触发的方法, 响应的方法, 执行的线程类型(0为当前线程，1为主线程，2为后台线程，默认为0)
如  
*/application:didFinishLaunchingWithOptions:, MYApplicationObserver/migrateUserDatabase:, 2
*代表任何类。
程序启动时，将会实例化一个MYApplicationObserver类，并执行migrateUserDatabase:方法，传递一个NSNotification类型的参数，用后台线程执行。

路由文件格式(.route)

同广播文件格式，不同的是没有线程类型，只能在当前线程中执行，并且有返回值。
如果同一个监听方法被注册多个route，将会只执行第一个route方法（加载顺序不确定）
