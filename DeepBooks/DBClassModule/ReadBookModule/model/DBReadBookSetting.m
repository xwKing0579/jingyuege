//
//  DBReadBookSetting.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/5.
//

#import "DBReadBookSetting.h"
#import <CoreText/CoreText.h>
#import "DBFontModel.h"
NSString *const kDBReaderBookSetting = @"kDBReaderBookSetting";

@interface DBReadBookSetting ()
@property (nonatomic, copy) NSString *textColorString;
@property (nonatomic, copy) NSString *bgColorString;
@property (nonatomic, copy) NSString *canvasString;
@end

@implementation DBReadBookSetting

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"speechSetting" : DBSpeechBookSetting.class,
    };
}

- (instancetype)init{
    if (self == [super init]){
        self.fontName = @"STSong";
        self.fontFamily = @"宋体";
        self.titleFontSize = 30.0;
        self.textFontSize = 21.0;
        self.textColor = DBColorExtension.onyxColor;
        self.backgroundColor = DBColorExtension.backgroundGrayColor;
        self.lineSpacing = 10;
        self.wordSpacing = 1;
        self.turnStyle = 1;
        self.isEyeShaow = NO;
        self.shadowPercent = 0.35;
        self.isAutoScroll = NO;
        self.scrollSpeed = 0.001;
        self.canvasSize = CGSizeMake(UIScreen.screenWidth-32, (NSInteger)(UIScreen.screenHeight-UIScreen.navbarSafeHeight-UIScreen.tabbarSafeHeight-40));
        self.canvasAdSize = CGSizeMake(UIScreen.screenWidth,(NSInteger)(UIScreen.screenWidth*50.0/320.0));
        self.speechSetting = DBSpeechBookSetting.new;
    }
    return self;
}

+ (DBReadBookSetting *)setting{
    NSString *result = [NSUserDefaults takeValueForKey:kDBReaderBookSetting];
    if (result) {
        DBReadBookSetting *model = [DBReadBookSetting yy_modelWithJSON:result];
        return model;
    }
    return DBReadBookSetting.new;
}

- (void)reloadSetting{
    [NSUserDefaults saveValue:self.yy_modelToJSONString forKey:kDBReaderBookSetting];
}

+ (NSArray <UIColor *>*)settingBackgroundColors{
    return @[DBColorExtension.backgroundGrayColor,DBColorExtension.linenColor,DBColorExtension.paleGreenColor,DBColorExtension.mistyRoseColor,DBColorExtension.sandColor,DBColorExtension.wheatColor,DBColorExtension.ravenColor];
}

+ (NSArray <UIColor *>*)settingTextColors{
    return @[DBColorExtension.onyxColor,DBColorExtension.darkOliveColor,DBColorExtension.forestColor,DBColorExtension.mahoganyColor,DBColorExtension.darkOliveColor,DBColorExtension.darkOliveColor,DBColorExtension.darkGrayColor];
}

+ (NSArray<NSAttributedString *> *)calculateCanvasesForAttributedString:(NSAttributedString *)attributedString{
    if (attributedString.length == 0) return @[];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger currentOffset = 0;
    NSUInteger length = attributedString.length;
    
    while (currentOffset < length) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGSize size = [self calculateCanvaseSize];
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));

        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(currentOffset, 0), path, NULL);
        CGPathRelease(path);

        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        currentOffset += frameRange.length;

        NSRange range = NSMakeRange(frameRange.location, frameRange.length);
        NSAttributedString *content = [attributedString attributedSubstringFromRange:range];
        [result addObject:content];
        CFRelease(frame);
    }

    CFRelease(framesetter);
    return result.copy;
}

+ (CGFloat)coreTextHeightForWidth:(CGFloat)width attributedString:(NSAttributedString *)attributedString {
    if (attributedString.length == 0) return 0;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CGSize constraints = CGSizeMake(width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, constraints, NULL);
    CFRelease(framesetter);
    return ceil(coreTextSize.height);
}

+ (CGSize)calculateCanvaseSize {
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderBottom];
    if (DBUnityAdConfig.openAd && posAd.ads.count){
        return CGSizeMake(setting.canvasSize.width, setting.canvasSize.height-setting.canvasAdSize.height-20);
    }
    return setting.canvasSize;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"textColor": @"textColorString",
              @"backgroundColor": @"bgColorString",
              @"canvasSize": @"canvasString"};
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _bgColorString = backgroundColor.toColorHexString;
}

- (UIColor *)backgroundColor{
    return [UIColor rgbString:self.bgColorString];
}

- (void)setTextColor:(UIColor *)textColor{
    _textColorString = textColor.toColorHexString;
}

- (UIColor *)textColor{
    return [UIColor rgbString:self.textColorString];
}

- (void)setCanvasSize:(CGSize)canvasSize{
    _canvasString = NSStringFromCGSize(canvasSize);
}

- (CGSize)canvasSize{
    return CGSizeFromString(self.canvasString);
}

@end


@implementation DBSpeechBookSetting

- (instancetype)init{
    if (self == [super init]){
        self.rate = 0.50;
        self.pitch = 1.08;
        self.name = @"语舒";
        self.voiceIndex = 0;
    }
    return self;
}

@end

