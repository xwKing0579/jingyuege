//
//  DBSpeechManager.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/16.
//

#import "DBSpeechManager.h"
#import <AVFoundation/AVFoundation.h>
#import "DBReadBookSetting.h"
@interface DBSpeechManager ()<AVSpeechSynthesizerDelegate>
@property (strong, nonatomic) AVSpeechSynthesizer *audiobookSynthesizer;
@property (strong, nonatomic) AVSpeechUtterance *speechUtterance;
@property (strong, nonatomic) NSArray *speechVoicesCache;

@end

@implementation DBSpeechManager

- (void)speechSetting{
    self.audiobookSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.audiobookSynthesizer.delegate = self;
    
    NSArray<AVSpeechSynthesisVoice *> *voices = [AVSpeechSynthesisVoice speechVoices];
    NSMutableArray<AVSpeechSynthesisVoice *> *cnVoices = [NSMutableArray array];
    for (AVSpeechSynthesisVoice *voice in voices) {
        if ([voice.language hasPrefix:@"zh-CN"]) {
            [cnVoices addObject:voice];
        }
    }

    NSComparator voiceComparator = ^NSComparisonResult(AVSpeechSynthesisVoice *voice1, AVSpeechSynthesisVoice *voice2) {
        BOOL isYushu1 = [voice1.name containsString:@"语舒"];
        BOOL isYushu2 = [voice2.name containsString:@"语舒"];
        if (isYushu1 && !isYushu2) {
            return NSOrderedAscending;
        } else if (!isYushu1 && isYushu2) {
            return NSOrderedDescending;
        }
        
        BOOL isNameChinese1 = [voice1.name rangeOfString:@"\\p{Han}" options:NSRegularExpressionSearch].location != NSNotFound;
        BOOL isNameChinese2 = [voice2.name rangeOfString:@"\\p{Han}" options:NSRegularExpressionSearch].location != NSNotFound;
        
        if (isNameChinese1 && !isNameChinese2) {
            return NSOrderedAscending;
        } else if (!isNameChinese1 && isNameChinese2) {
            return NSOrderedDescending;
        }
  
        if (isNameChinese1 && isNameChinese2) {
            return [voice1.name localizedStandardCompare:voice2.name];
        } else {
            return [voice1.name localizedCaseInsensitiveCompare:voice2.name];
        }
    };

    NSArray<AVSpeechSynthesisVoice *> *sortedCnVoices = [cnVoices sortedArrayUsingComparator:voiceComparator];
    self.speechVoicesCache = sortedCnVoices;

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleAudioInterruption:)
                                               name:AVAudioSessionInterruptionNotification
                                             object:audioSession];
}

- (void)setupAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;

    [audioSession setCategory:AVAudioSessionCategoryPlayback
                 withOptions:AVAudioSessionCategoryOptionDuckOthers
                       error:&error];
    if (error) {
        NSLog(@"音频会话设置错误: %@", error);
    }
}

- (void)handleAudioInterruption:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    AVAudioSessionInterruptionType type = [userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self pauseReaderSpeaking];
    } else if (type == AVAudioSessionInterruptionTypeEnded) {
        AVAudioSessionInterruptionOptions options = [userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            [self continueReaderSpeaking];
        }
    }
}

- (void)speakingText:(NSString *)text{
    [self setupAudioSession];
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    AVSpeechUtterance *speechUtterance = [AVSpeechUtterance speechUtteranceWithString:text];
    self.speechUtterance = speechUtterance;
    speechUtterance.voice = self.speechVoicesCache[setting.speechSetting.voiceIndex];
    speechUtterance.rate = setting.speechSetting.rate; // 语速（0.0 ~ 1.0）
    speechUtterance.pitchMultiplier = setting.speechSetting.pitch; // 音调（0.5 ~ 2.0）
    speechUtterance.preUtteranceDelay = 0.15;
    speechUtterance.postUtteranceDelay = 0.15;
    speechUtterance.volume = 1.0;
    
    if (!self.audiobookSynthesizer) {
         self.audiobookSynthesizer = [[AVSpeechSynthesizer alloc] init];
         self.audiobookSynthesizer.delegate = self;
     }
    
    [self.audiobookSynthesizer speakUtterance:speechUtterance];
}


- (void)setRate:(CGFloat)rate{
    _rate = rate;

    if (self.speechUtterance){
        NSString *text = self.speechUtterance.speechString;
        [self stopReaderSpeaking];
        [self speechSetting];
        [self speakingText:text];
    }
}

- (void)setVoice:(NSInteger)voice{
    _voice = voice;
    if (self.speechUtterance){
        NSString *text = self.speechUtterance.speechString;
        [self stopReaderSpeaking];
        [self speechSetting];
        [self speakingText:text];
    }
}

- (BOOL)isAudiobookSpeaking{
    return self.audiobookSynthesizer.isSpeaking;
}

- (void)pauseReaderSpeaking {
    if (self.audiobookSynthesizer.isSpeaking && !self.audiobookSynthesizer.isPaused) {
        [self.audiobookSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

- (void)continueReaderSpeaking{
    if (self.audiobookSynthesizer.isPaused) [self.audiobookSynthesizer continueSpeaking];
}

- (void)stopReaderSpeaking {
    if (self.audiobookSynthesizer.isSpeaking) {
        [self.audiobookSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        self.audiobookSynthesizer = nil;
        self.speechUtterance = nil;
    }
}

- (NSArray *)speechVoicesList{
    NSMutableArray *voiceNames = [NSMutableArray array];
    for (AVSpeechSynthesisVoice *voice in self.speechVoicesCache) {
        [voiceNames addObject:voice.name];
    }
    return voiceNames;
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
//    NSString *fullText = utterance.speechString;
//    NSString *currentWord = [fullText substringWithRange:characterRange];
}

// 语音合成结束时的回调
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    if (self.speechFinishBlock) self.speechFinishBlock(YES);
}

// 语音合成取消时的回调
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
    
}


@end
