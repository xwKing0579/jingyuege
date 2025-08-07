//
//  DBFontModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/14.
//

#import "DBFontModel.h"
#import <CoreText/CoreText.h>
#import "DBAppSetting.h"

NSString *const kReaderFontDataList = @"kReaderFontDataList";


@interface DBFontModel ()
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@end

@implementation DBFontModel

+ (void)load{
    NSArray *fontList = DBFontModel.fontDataList;
    BOOL needUpdate = NO;
    for (DBFontModel *fontModel in fontList) {
        if (fontModel.isDowload && ![DBFontModel isFontDownloaded:fontModel.fontName]) {
            NSURL *fontURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
            fontURL = [fontURL URLByAppendingPathComponent:fontModel.enName?:[fontURL lastPathComponent]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fontURL.path]) {
                CFErrorRef error;
                if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontURL, kCTFontManagerScopeProcess, &error)) {
                    needUpdate = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        fontModel.isDowload = NO;
                        if (fontModel.isUsing) {
                            fontModel.isUsing = NO;
                            DBFontModel *model = fontList.firstObject;
                            model.isUsing = YES;
                        }
                    });
                }
            }
        }
    }
    if (needUpdate) [DBFontModel saveFontDataList:fontList];
}

+ (instancetype)manger {
    static DBFontModel *_manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manger = [DBFontModel new];
    });
    return _manger;
}

+ (NSArray *)fontDataList{
    id dataList = [NSUserDefaults takeValueForKey:kReaderFontDataList];
    if (dataList == nil) {
        NSMutableArray *fontList = [NSMutableArray arrayWithArray:@[@{@"name":@"宋体",@"fontName":@"STSong",@"isUsing":@1,@"isDowload":@1,@"isSystem":@0},
                    @{@"name":@"方体",@"fontName":@"PingFangSC-Regular",@"isUsing":@0,@"isDowload":@1,@"isSystem":@1}]];
        NSArray *fontDataList = DBCommonConfig.appConfig.font;
        if (fontDataList.count) {
            for (DBReaderFontModel *fontModel in fontDataList) {
                DBFontModel *model = [[DBFontModel alloc] init];
                model.name = fontModel.font_suffix_name;
                model.enName = fontModel.font_en_name;
                model.fontName = fontModel.fontname;
                model.isUsing = NO;
                model.isDowload = NO;
                model.isSystem = NO;
                model.url = fontModel.url;
                model.image = fontModel.img;
                [fontList addObject:model.yy_modelToJSONObject];
            }
        }
        dataList = fontList;
    }
    return [NSArray yy_modelArrayWithClass:self.class json:dataList];
}

+ (void)resetFontName{
    [NSUserDefaults removeValueForKey:kReaderFontDataList];
}

+ (void)saveFontDataList:(NSArray *)dateList{
    if (dateList.count <= 2) return;
    [NSUserDefaults saveValue:dateList.yy_modelToJSONString forKey:kReaderFontDataList];
}

- (void)downloadFontWithName:(DBFontModel *)fontModel completion:(_Nullable DBFontDownloadCompletionBlock)completion;{
    if ([UIFont fontWithName:DBSafeString(fontModel.fontName) size:12]) {
        if (completion) completion(YES, fontModel.fontName, nil);
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *fontURL = [NSURL URLWithString:fontModel.url];
    if (!fontURL) {
        if (completion) completion(NO, nil, @"下载字体链接错误");
        return;
    }
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:fontURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!location || error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO, nil, error.localizedDescription);
                return;
            });
        }
        
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *destinationURL = [documentsURL URLByAppendingPathComponent:fontModel.enName?:[fontURL lastPathComponent]];
        
        NSError *moveError;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:destinationURL error:&moveError];
        if (moveError){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO, nil, moveError.localizedDescription);
                return;
            });
        }

        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)destinationURL);
        CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
        CFErrorRef errorRef;
        BOOL registered = CTFontManagerRegisterGraphicsFont(fontRef, &errorRef);
        
        NSString *registeredFontName = nil;
        if (registered) {
            registeredFontName = (__bridge NSString *)CGFontCopyPostScriptName(fontRef);
        }
        
        CGDataProviderRelease(fontDataProvider);
        CGFontRelease(fontRef);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(YES, registeredFontName, nil);
        });
    }];
    
    [downloadTask resume];
    self.downloadTask = downloadTask;
}

+ (BOOL)isFontDownloaded:(NSString *)fontName {
    UIFont *font = [UIFont fontWithName:DBSafeString(fontName) size:12];
    return (font != nil);
}

- (void)cancelDownloadTask{
    if (self.downloadTask) {
          [self.downloadTask cancel];
          self.downloadTask = nil;
      }
}

@end
