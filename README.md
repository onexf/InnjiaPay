## iOS支付SDK使用文档
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


###  新加代理方法，可以更严谨的去控制支付流程

	/** 发起支付 */
	- (void)startPaying;//可以在这里转圈圈，做一些发起支付时的操作
	/** 唤起客户端 */
	- (void)raiseUpPayingAPP;//调起支付app，取消圈圈以及做一些成功发起支付后的操作
	配合支付完成的回调方法 
	- (void)innjiaPayResp:(InnjiaPayResp *)resp;可以控制从开始支付到支付完成的每一步细节


