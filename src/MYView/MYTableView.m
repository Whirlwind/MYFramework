//
//  MYTableView.m
//  Weight
//
//  Created by Whirlwind on 12-11-8.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYTableView.h"

@implementation MYTableView

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier createWithStyle:(UITableViewCellStyle)style {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:identifier] autorelease];
    }
    return cell;
}

@end
