//
//  BillModel.h
//  InnJia_2.0
//
//  Created by pg on 16/5/24.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  支付渠道(WX,Ali,Union)
 */
typedef NS_ENUM(NSInteger, PayChannel) {
    PayChannelNone = 0,
    
//    PayChannelWx = 10, //微信
    PayChannelWxApp,//微信APP
    
//    PayChannelAli = 20,//支付宝
    PayChannelAliApp,//支付宝APP
    
//    PayChannelBaidu = 50,//百度
    PayChannelBaiduApp,//百度钱包

//    PayChannelInnjiaWallet = 998,//钱包
};
@interface PayBody : NSObject
/** 支付渠道 */
@property (nonatomic, assign) PayChannel channel;
/**
 *  订单描述,32个字节内,最长16个汉字。必填
 */
@property (nonatomic, copy, nonnull) NSString *title;
/**
 *  支付金额,以分为单位,必须为正整数,必填（微信和支付宝不一样，微信100表示1元。）
 */
@property (nonatomic, copy, nonnull) NSString *totalFee;
/**
 *  商户系统内部的订单号,8~32位数字和/或字母组合,确保在商户系统中唯一。必填
 */
@property (nonatomic, copy, nonnull) NSString *billNo;
/**
 *  调用支付的app注册在info.plist中的scheme,支付宝支付必填
 */
@property (nonatomic, retain, nullable) NSString *scheme;
/**
 *  扩展参数,可以传入任意数量的key/value对来补充对业务逻辑的需求;此参数会在webhook回调中返回;
 */
@property (nonatomic, retain, nullable) NSMutableDictionary *optional;



/**
 *  发起支付，签名暂时在本地
 */
- (void)payReq;

@end

