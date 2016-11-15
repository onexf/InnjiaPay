//
//  InnjiaBaiduPayAdapter.m
//  InnJia
//
//  Created by pg on 16/9/19.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "InnjiaBaiduPayAdapter.h"
#import "InnjiaAdapterProtocpl.h"
#import "InnjiaPayUtil.h"
#import "BDWalletSDKMainManager.h"
#import "InnjiaPayCache.h"
#import "NSDictionary+Utils.h"

static NSString * const kBaiduOrderInfo = @"orderInfo";

@interface InnjiaBaiduPayAdapter ()<InnjiaAdapterDelegate>

@end

@implementation InnjiaBaiduPayAdapter

- (NSString *)baiduPay:(NSMutableDictionary *)dic {
    InnjiaPayResp *resp = (InnjiaPayResp *)[InnjiaPayCache sharedInstance].innjiaResp;
    resp.resultCode = [dic integerValueForKey:@"result_code" defaultValue:InnjiaErrCodeCommon];
    resp.resultMsg = [dic stringValueForKey:@"result_msg" defaultValue:@"未知错误"];
    resp.errDetail = [dic stringValueForKey:@"err_detail" defaultValue:@"未知错误"];
    NSString *orderInfo = [dic stringValueForKey:kBaiduOrderInfo defaultValue:@""];
    resp.paySource = [NSDictionary dictionaryWithObjectsAndKeys:orderInfo, kBaiduOrderInfo, nil];
    [InnjiaPayCache innjiaPayDoResponse];
    return orderInfo;
}

@end
