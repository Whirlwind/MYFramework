//
//  MYThread.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-22.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

// 主线程队列
#define MY_FOREGROUND_QUEUE                     dispatch_get_main_queue()
// 后台线程队列
#define MY_BACKGROUND_QUEUE_WITH_PRIORITY(x)    dispatch_get_global_queue(x, 0)


#define MY_FOREGROUND_BEGIN                     dispatch_async(MY_MAIN_THREAD_QUEUE, ^{
#define MY_FOREGROUND_DELAY(ms)                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC), MY_MAIN_THREAD_QUEUE, ^{
#define MY_FOREGROUND_COMMIT                    });


#define MY_BACKGROUND_BEGIN_WITH_PRIORITY(x)    dispatch_async(MY_BACKGROUND_QUEUE_WITH_PRIORITY(x), ^{
#define MY_BACKGROUND_BEGIN                     MY_BACKGROUND_BEGIN_WITH_PRIORITY(DISPATCH_QUEUE_PRIORITY_DEFAULT)
#define MY_BACKGROUND_DELAY(x)                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC), MY_BACKGROUND_QUEUE_WITH_PRIORITY(DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
#define MY_BACKGROUND_COMMIT                    });