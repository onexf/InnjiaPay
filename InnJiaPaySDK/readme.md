## iOS支付SDK使用文档

SDK后台错误代码
/*
* 0000 成功
* 0001 该账号无绑定支付账号
* 0002 无效的projectId
* 0003 accessToken 已失效
* 0004 无效的支付渠道
* 0005 订单已经支付
* 0006 唯一订单号格式不正确
* 0007 TOKEN不能为空
*/
1 .在AppDelegate.m中

    #import "InnjiaPayTool.h"
    
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册SDK后台
    [InnjiaPayTool setTokenUrl:SDKTOKENURL payInfoUrl:SDKPAYINFOURL];
    //注册微信
    [InnjiaPayTool initWeChatPay:WXPayAppID];
    }
    
    
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //处理通过URL启动App时传递的数据        
    if (![InnjiaPayTool handleOpenUrl:url]) {
        }
    }
2 .在URL Types中设置支付宝scheme、微信appid
![](http://g.hiphotos.baidu.com/image/pic/item/0824ab18972bd407fb73ede173899e510fb30971.jpg)
3 .在使用支付的地方

	#import "InnjiaPayTool.h"//并遵守InnjiaPayDelegate协议
	
	- (void)viewDidLoad {
	[super viewDidLoad];
	//设置代理
    [InnjiaPayTool setInnjiaDelegate:self];
    }
    
    //发起支付
    - (void)sendReq {
        PayBody *body = [[PayBody alloc] init];
        //金额
        body.totalFee = @"";
        //订单号
        body.billNo = @"";
        //标题
        body.title = @"";
        
    #if 1
        //支付宝
        body.channel = PayChannelAliApp;
        //第二步设置的支付宝scheme
        body.scheme = @"";
    #endif
    
    #if 0      
        //微信
        body.channel = PayChannelWxApp;
    #endif
        [InnjiaPayTool sendInnjiaReq:body];
    }
    
    //实现回调方法
    - (void)innjiaPayResp:(InnjiaPayResp *)resp{
        if (resp.resultCode != InnjiaErrCodeSuccess) {
        //支付失败
        } else {
        //支付成功
        }
    }

