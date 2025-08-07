//
//  DBSpeechManager.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBSpeechManager : NSObject

- (void)speechSetting;

- (NSArray *)speechVoicesList;

- (void)stopReaderSpeaking;
- (void)pauseReaderSpeaking;
- (void)continueReaderSpeaking;

//阅读
- (void)speakingText:(NSString *)text;

//语速
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) NSInteger voice;
@property (nonatomic, assign) BOOL isAudiobookSpeaking;

@property (nonatomic, copy) void (^speechFinishBlock)(BOOL speech);

@end

NS_ASSUME_NONNULL_END
