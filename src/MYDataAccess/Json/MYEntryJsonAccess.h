//
//  MYEntryJsonAccess.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-19.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYEntryDataAccessProtocol.h"
#import "MYJsonAccess.h"

@interface MYEntryJsonAccess : MYJsonAccess <MYEntryDataAccessProtocol>

@property (copy, nonatomic) NSString *modelName;

@end
