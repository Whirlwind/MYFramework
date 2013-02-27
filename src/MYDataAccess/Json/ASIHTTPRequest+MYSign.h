//
//  ASIHTTPRequest+MYSign.h
//  ONEBase
//
//  Created by apple on 12-11-22.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface ASIHTTPRequest (MYSign)

// GET method , addIDParams default YES
- (void)buildSecurityParams:(NSString*)appSecret;
// Post method
- (void)buildSecurityParams:(NSString*)appSecret postData:(NSDictionary*)__postData;
- (void)buildSecurityParams:(NSString*)appSecret postData:(NSDictionary*)__postData addIDParams:(BOOL)__addIDParams;
- (void)mixAdditionParams:(NSDictionary*)__postData;

@end