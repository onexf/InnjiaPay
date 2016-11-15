//
//  InnjiaPayTool+Utils.h
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "InnjiaPayTool.h"
@interface InnjiaPayTool (Utils)

/**
 *  微信、支付宝
 *
 *  @param body 支付参数
 */
- (void)reqPay:(PayBody *)body;


@end
