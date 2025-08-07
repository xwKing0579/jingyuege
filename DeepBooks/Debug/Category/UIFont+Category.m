//
//  UIFont+Category.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/5.
//



#import "UIFont+Category.h"
#import "NSString+Category.h"
#import <objc/runtime.h>
#import "NSObject+Mediator.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation UIFont (Category)
#pragma clang diagnostic pop


+ (UIFont *)font12{
    return [self fontSize:12];
}
+ (UIFont *)font14{
    return [self fontSize:14];
}

+ (UIFont *)font16{
    return [self fontSize:16];
}

+ (UIFont *)font20{
    return [self fontSize:20];
}

+ (UIFont *)font25{
    return [self fontSize:25];
}


+ (UIFont *)fontBold14{
    return [self fontBoldSize:14];
}
+ (UIFont *)fontBold16{
    return [self fontBoldSize:16];
}


+ (UIFont *)fontSize:(CGFloat)size{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)fontBoldSize:(CGFloat)size{
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

@end
