//
//  WechatManager.m
//  HM503
//
//  Created by 程明 on 2018/11/8.
//  Copyright © 2018 余浩. All rights reserved.
//

#import "WechatManager.h"

@implementation WechatManager
static WechatManager*manager=nil;

+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

-(void)payOrderWithType:(NSString*)type roleType:(NSString *)roleType
{
    NSString*url=[NSString stringWithFormat:@"%@/WxPay/pay",URL_HOST];
    NSMutableDictionary*dic=[NSMutableDictionary dictionaryWithCapacity:0];
    UserInfoManager*mananger=[UserInfoManager shareManager];
    UserInfoModel*model=[mananger readUserInfo];
    [dic setObject:model.id forKey:@"uid"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:@"1" forKey:@"apptype"];
    if (roleType){
        [dic setObject:roleType forKey:@"roletype"];
    }
    [SendRequest postWithURL:url params:dic success:^(id response) {
        NSString*code=response[@"code"];
        NSString*message=response[@"message"];
        if([code intValue]==0)
        {
            NSDictionary*d=[[response objectForKey:@"data"] mj_JSONObject];
            [self wakeUpWechatForPayWithDic:d];
        }else{
            SHOWMSG(message)
        }
        
    } fail:^(NSError *error) {
        SHOWERROR(@"网络异常!")
    }];
}

-(void)payOrderWithType:(NSString*)type withOrderID:(NSString*)order_id
{
    NSString*url=[NSString stringWithFormat:@"%@/WxPay/pay",URL_HOST];
    NSMutableDictionary*dic=[NSMutableDictionary dictionaryWithCapacity:0];
    UserInfoManager*mananger=[UserInfoManager shareManager];
    UserInfoModel*model=[mananger readUserInfo];
    [dic setObject:model.id forKey:@"uid"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:order_id forKey:@"order_id"];
    [dic setObject:@"1" forKey:@"apptype"];
    [SendRequest postWithURL:url params:dic success:^(id response) {
        NSString*code=response[@"code"];
        NSString*message=response[@"message"];
        if([code intValue]==0)
        {
            NSDictionary*d=[[response objectForKey:@"data"] mj_JSONObject];
            [self wakeUpWechatForPayWithDic:d];
        }else{
            SHOWMSG(message)
        }
        
    } fail:^(NSError *error) {
        SHOWERROR(@"网络异常!")
    }];
}

-(void)getStateOfOrderWithResp:(BaseResp *)resp
{
    PayResp*response=(PayResp*)resp;
    switch(response.errCode){
        case WXSuccess:
        {
            if([_delegate respondsToSelector:@selector(wechatPaySuccessful)])
            {
                [_delegate wechatPaySuccessful];
            }
            //NSLog(@"支付成功");
        }
            break;
        default:
        {
            if([_delegate respondsToSelector:@selector(wechatPayFail)])
            {
                [_delegate wechatPayFail];
            }
           // NSLog(@"支付失败，retcode=%d",resp.errCode);
        }
            break;
    }

}

//调微信支付
-(void)wakeUpWechatForPayWithDic:(NSDictionary*)dic
{
    //NSLog(@"dic = %@",dic);
    PayReq *request = [[PayReq alloc] init] ;
    request.openID  = [dic objectForKey:@"appid"];
    request.partnerId = dic[@"partnerid"];
    request.prepayId= dic[@"prepayid"];
    request.package = dic[@"package"];
    request.nonceStr= dic[@"noncestr"];
    request.timeStamp=[dic[@"timestamp"] intValue];
    request.sign= dic[@"sign"];
    [WXApi sendReq:request];
}


@end
