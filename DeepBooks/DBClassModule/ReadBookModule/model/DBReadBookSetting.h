//
//  DBReadBookSetting.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/5.
//

#import <Foundation/Foundation.h>
#import "DBChapterModel.h"
NS_ASSUME_NONNULL_BEGIN
@class DBSpeechBookSetting;
@interface DBReadBookSetting : NSObject
@property (nonatomic, copy) NSString *fontFamily; 
@property (nonatomic, copy) NSString *fontName;  //字体名称
@property (nonatomic, assign) CGFloat titleFontSize;  //标题字体大小
@property (nonatomic, assign) CGFloat textFontSize;  //内容字体大小

@property (nonatomic, assign) BOOL isDark; // false
@property (nonatomic, strong) UIColor *backgroundColor; //背景色
@property (nonatomic, strong) UIColor *textColor;  //文字颜色
@property (nonatomic, assign) NSInteger oldColorIndex; 

@property (nonatomic, assign) CGFloat lineSpacing; //10
@property (nonatomic, assign) CGFloat wordSpacing; //5

@property (nonatomic, assign) NSInteger turnStyle; // @"左右",@"拟真",@"上下",@"自动"
@property (nonatomic, assign) BOOL isEyeShaow;
@property (nonatomic, assign) CGFloat shadowPercent;

@property (nonatomic, assign) BOOL isAutoScroll; //自动阅读
@property (nonatomic, assign) CGFloat scrollSpeed; 

@property (nonatomic, assign) NSInteger orderType; //排序 0 阅读/操作时间 1 更新时间
@property (nonatomic, assign) NSInteger readTotalTime; //阅读总时间

@property (nonatomic, assign) CGSize canvasSize;
@property (nonatomic, assign) CGSize canvasAdSize;

@property (nonatomic, strong) DBSpeechBookSetting *speechSetting;

+ (DBReadBookSetting *)setting;
- (void)reloadSetting;

+ (NSArray <UIColor *>*)settingBackgroundColors;
+ (NSArray <UIColor *>*)settingTextColors;

+ (NSArray<NSAttributedString *> *)calculateCanvasesForAttributedString:(NSAttributedString *)attributedString;
+ (CGSize)calculateCanvaseSize;
+ (CGFloat)coreTextHeightForWidth:(CGFloat)width attributedString:(NSAttributedString *)attributedString;
@end

@interface DBSpeechBookSetting : NSObject
@property (nonatomic, assign) CGFloat rate;  //语速
@property (nonatomic, assign) CGFloat pitch; //语音
@property (nonatomic, copy) NSString *name; //语舒
@property (nonatomic, assign) NSInteger voiceIndex;
@end


NS_ASSUME_NONNULL_END
