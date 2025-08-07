//
//  DBReaderSetting.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBReaderSetting.h"

@implementation DBReaderSetting

static CALayer *_coverLayer;
+ (void)openEyeProtectionMode{
    [self closeEyeProtectionMode];
    
    CALayer *coverLayer = [CALayer layer];
    coverLayer.frame = UIScreen.appWindow.bounds;
    
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    if (setting.isDark){
        UIScreen.appWindow.backgroundColor = DBColorExtension.blackColor;
        UIScreen.appWindow.alpha = 0.55;
    }else{
        UIScreen.appWindow.backgroundColor = DBColorExtension.whiteColor;
        UIScreen.appWindow.alpha = 1;
    }
    
    if (setting.isEyeShaow){
        coverLayer.opacity = 0.2;
        coverLayer.backgroundColor = [DBColorExtension.orangeColor colorWithAlphaComponent:setting.shadowPercent].CGColor;
    }
    
    [UIScreen.appWindow.layer addSublayer:coverLayer];
    _coverLayer = coverLayer;
}

+ (void)closeEyeProtectionMode{
    if (_coverLayer){
        [_coverLayer removeFromSuperlayer];
        _coverLayer = nil;
    }
}

@end
