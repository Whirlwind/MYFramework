//
//  ValueCheckBoxViewDefine.h
//  iNice
//
//  Created by Whirlwind James on 12-7-15.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

//#define kValueCheckBoxHeight 200.0f

#define kValueCheckBoxViewWidthPerUnit 10.0f
#define kValueCheckBoxViewWidthPerCell 100.0f
#define kValueCheckBoxViewHeightPerCell 81.0f
#define kValueCheckBoxViewExtendCellNumber 3

#define kValueCheckBoxViewPointerImage @"pointer"

// 显示的数值（顶部中间）
#define kValueCheckBoxViewValueSelectedLabelTextColor [UIColor colorWithRed:229.0/255.0 green:20/255.0f blue:0 alpha:1]
#define kValueCheckBoxViewValueSelectedLabelTextFont [UIFont fontWithName:@"Helvetica Neue" size:36]

// 显示的单位（顶部右侧）
#define kValueCheckBoxViewUnitSelectedLabelTextColor [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1]
#define kValueCheckBoxViewUnitSelectedLabelTextFont [UIFont systemFontOfSize:18]

// 单位换算 (顶部左侧)
#define kValueCheckBoxViewSubValueSelectedLabelTextColor [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1]

// 个性化单位 （底部）
#define kValueCheckBoxViewUnitTitleColorForNormal [UIColor colorWithRed:153/255 green:153/255 blue:153/255 alpha:1]
#define kValueCheckBoxViewUnitTitleColorForSelected [UIColor colorWithRed:229.0/255.0 green:20/255.0f blue:0 alpha:1]