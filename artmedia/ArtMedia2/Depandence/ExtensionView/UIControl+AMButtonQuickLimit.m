//
//  UIControl+AMButtonQuickLimit.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/18.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "UIControl+AMButtonQuickLimit.h"
#import <objc/runtime.h>

static const char * UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char * UIControl_ignoreEvent = "UIControl_ignoreEvent";

@implementation UIControl (AMButtonQuickLimit)

-(void)setAcceptEventInterval:(double)acceptEventInterval {
	//关联属性对象
	objc_setAssociatedObject(self, UIControl_acceptEventInterval,@(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTimeInterval)acceptEventInterval{
	return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

-(void)setIgnoreEvent:(BOOL)ignoreEvent {
	//关联属性对象
	objc_setAssociatedObject(self, UIControl_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)ignoreEvent{
	return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
}

//所有类即将加入内存的时候都会走load方法，所以我们在这个里面交换方法
+(void)load{
	Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
	Method b = class_getInstanceMethod(self, @selector(swizzing_sendAction:to:forEvent:));
	method_exchangeImplementations(a, b);
}

-(void)swizzing_sendAction:(SEL)action to:(id)tagert forEvent:(UIEvent*)event{
	if (self.ignoreEvent) {
		NSLog(@"你点击的太快了");
		return;
	}
	if (self.acceptEventInterval>0) {
		self.ignoreEvent = YES;
		//之前是写的有点问题，现在改了一下，把下面这段话给注释掉，就会只响应一次点击，前提是：acceptEventInterval 的数据必须大于0，否则会一直走调用的方法
		// [self performSelector:@selector(setIgnoreWithNo) withObject:nil afterDelay:self.acceptEventInterval];
		//如果想要按钮延迟一定的时间去响应事件，就可以打开上面的方法即可
		[self performSelector:@selector(setIgnoreWithNo) withObject:nil afterDelay:self.acceptEventInterval];
	}
	//当前按钮调用该方法
	[self swizzing_sendAction:action to:tagert forEvent:event];
}
-(void)setIgnoreWithNo{
	self.ignoreEvent = NO;
}

@end
