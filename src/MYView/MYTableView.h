//
//  MYTableView.h
//  Weight
//
//  Created by Whirlwind on 12-11-8.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

@interface MYTableView : UITableView

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier createWithStyle:(UITableViewCellStyle)style;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier createWithStyle:(UITableViewCellStyle)style createBlock:(void (^)(UITableViewCell *))block;
@end
