//
//  DBFontModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DBFontDownloadCompletionBlock)(BOOL success, NSString * _Nullable registeredFontName, NSString * _Nullable message);

@interface DBFontModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *enName;
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, assign) BOOL isUsing; //是否使用
@property (nonatomic, assign) BOOL isDowload; //是否下载
@property (nonatomic, assign) BOOL isSystem; //是否系统字体
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *image;

+ (instancetype)manger;

+ (NSArray *)fontDataList;
+ (void)resetFontName;

+ (void)saveFontDataList:(NSArray *)dateList;

- (void)downloadFontWithName:(DBFontModel *)fontModel completion:(_Nullable DBFontDownloadCompletionBlock)completion;
- (void)cancelDownloadTask;
@end

NS_ASSUME_NONNULL_END
