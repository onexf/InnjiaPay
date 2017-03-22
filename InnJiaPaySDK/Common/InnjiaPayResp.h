//
//  InnjiaPayResp.h
//  InnJia_2.0
//
//  Created by pg on 16/5/24.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayBody.h"
typedef NS_ENUM(NSInteger, InnjiaErrCode) {
    InnjiaErrCodeSuccess    = 0,    /**< 成功    */
    InnjiaErrCodeCommon     = -1,   /**< 参数错误类型    */
    InnjiaErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    InnjiaErrCodeSentFail   = -3,   /**< 发送失败    */
    InnjiaErrCodeUnsupport  = -4,   /**< BeeCloud不支持 */
};
@interface InnjiaPayResp : NSObject
/**
 *  支付结果, 默认为common
 */
@property (nonatomic, assign) InnjiaErrCode resultCode;
/**
 *  响应提示字符串，默认为@""
 */
@property (nonatomic, copy) NSString *resultMsg;
/**
 *  支付体,只要用来在回调时判断支付渠道
 */
@property (nonatomic, strong) PayBody *payBody;

- (instancetype)initWithReq:(PayBody *)request;

@end
