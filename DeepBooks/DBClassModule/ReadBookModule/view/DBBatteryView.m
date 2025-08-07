//
//  DBBatteryView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/6.
//

#import "DBBatteryView.h"

@implementation DBBatteryView
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, _fillColor.CGColor);
    CGRect newR = CGRectMake(0.5, 0.5, rect.size.width - 4, rect.size.height-1);
    CGContextStrokeRect(context, newR);
    
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    newR = CGRectMake(rect.size.width - 4 + 0.5, (rect.size.height - 4) / 2,  4, 4);
    CGContextFillRect(context, newR);
    
    newR = CGRectMake(2, 2, (rect.size.width - 7)*[self getCurrentBatteryLevel], rect.size.height-4);
    CGContextFillRect(context, newR);
}


- (double)getCurrentBatteryLevel {
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double deviceLevel = [UIDevice currentDevice].batteryLevel;

    if (deviceLevel > 0 && deviceLevel <= 1.0 && deviceLevel != -1.0) {
        return deviceLevel;
    }
    return 0;
}

@end
