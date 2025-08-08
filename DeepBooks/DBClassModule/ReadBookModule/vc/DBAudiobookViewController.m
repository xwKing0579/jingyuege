//
//  DBAudiobookViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/10.
//

#import "DBAudiobookViewController.h"
#import "DBReaderPageViewController.h"
#import "DBAdReadSetting.h"
#import "DBSpeechManager.h"
#import "DBReadBookSetting.h"
#import "DBSpeechMenuView.h"
#import "DBSpeechVoicePanView.h"

@interface DBAudiobookViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) DBReaderPageViewController *readerPageVc;

@property (nonatomic, strong) DBSpeechManager *speechManager;

@property (nonatomic, assign) NSInteger audioTime;
@property (nonatomic, strong) NSDate *audioDate;
@property (nonatomic, strong) NSMutableArray <NSTextCheckingResult *> *audioMatches;

@property (nonatomic, strong) DBSpeechMenuView *speechView;

@property (nonatomic, strong) NSAttributedString *currentAudioText;

@end

@implementation DBAudiobookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self addChildViewController:self.readerPageVc];
    [self.view addSubview:self.readerPageVc.view];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)setModel:(DBReaderModel *)model{
    _model = model;
    self.readerPageVc.model = model;
    [self begainPrepareAudiobook];
}

- (void)begainPrepareAudiobook{
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceListenBooks];
    if (DBUnityAdConfig.openAd && posAd.ads.count) {
        DBAdReadSetting *adSetting = DBAdReadSetting.setting;
        if (!adSetting.isFreeListenBook) {
            adSetting.isFreeListenBook = YES;
            adSetting.listenBookCount = posAd.extra.free_count*60;
            [adSetting reloadSetting];
        }
 
        self.audioTime = MAX(0, adSetting.listenBookCount);
        self.audioDate = NSDate.now;
        if (adSetting.listenBookCount <= 0){
            DBWeakSelf
            [DBUnityAdConfig.manager openRewardAdSpaceType:DBAdSpaceListenBooks completion:^(BOOL removed) {
                DBStrongSelfElseReturn
                if (removed) {
                    adSetting.listenBookCount += MAX(1, posAd.extra.limit)*60;
                    [adSetting reloadSetting];
                    self.audioTime = MAX(0, adSetting.listenBookCount);
                    [self performAudiobookAction];
                }
            }];
        }else{
            [self performAudiobookAction];
        }
    }else{
        self.audioTime = -1;
        [self performAudiobookAction];
    }

}

- (void)performAudiobookAction{
    self.currentAudioText = nil;
    if (self.model.currentPage < self.model.contentList.count) {
        self.currentAudioText = self.model.contentList[self.model.currentPage];
    }
   
    NSString *audioText = self.currentAudioText.string;
    if (audioText.length == 0 || [audioText isEqualToString:DBConstantString.ks_chapterLoadFailed.textMultilingual]) {
        [self finishAudiobookAction];
        return;
    }
    
    self.audioMatches = [NSMutableArray arrayWithArray:[self splitTextForAudio:audioText]];
    [self audiobookUpdateText];
}

- (void)audiobookUpdateText{
    if (self.audioMatches.count) {
        [self audiobookTextWithRange:self.audioMatches.firstObject.range];
    }else{
        if (self.model.currentPage < self.model.contentList.count-1){
            self.model.currentPage += 1;
            [self performAudiobookAction];
        }else if (self.model.currentChapter < self.model.chapterCacheList.count-1){
            self.model.currentChapter += 1;
            self.model.currentPage = 0;
            [self performAudiobookAction];
        }else{
            [self finishAudiobookAction];
        }
    }
}

- (void)audiobookTextWithRange:(NSRange)range{
    if (self.audioTime >= 0 && self.audioDate){
        NSTimeInterval start = [self.audioDate timeIntervalSince1970];
        NSTimeInterval end = [NSDate.now timeIntervalSince1970];
        if (end - start > self.audioTime) {
           
            [UIScreen.currentViewController.view showAlertText:DBConstantString.ks_autoReadEnded];
            [self finishAudiobookAction];
            return;
        }
    }
    
    [self.audioMatches removeObjectAtIndex:0];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.currentAudioText];
    NSString *audioText = [attributeString attributedSubstringFromRange:range].string;
    [self.speechManager speakingText:audioText];
    
    [attributeString addAttribute:NSBackgroundColorAttributeName value:DBColorExtension.coralColor range:range];
    self.readerPageVc.audioText = attributeString;
}

- (void)finishAudiobookAction{
    DBAdReadSetting *adSetting = DBAdReadSetting.setting;
    NSInteger listenTime = NSDate.now.timeStampInterval - self.audioDate.timeStampInterval;
    adSetting.listenBookCount -= MIN(adSetting.listenBookCount, listenTime);
    [adSetting reloadSetting];
    
    [self.speechManager stopReaderSpeaking];
    
    if (self.finishAudiobookBlock) self.finishAudiobookBlock();
}

- (NSArray<NSTextCheckingResult *> *)splitTextForAudio:(NSString *)text {
    if (text.length == 0) return @[];
    
    NSString *pattern = @"[^。！？…….【】@&%\n\\s]+";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    NSMutableArray<NSTextCheckingResult *> *cleanedMatches = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString *matchedText = [text substringWithRange:match.range];
        NSCharacterSet *trimSet = [NSCharacterSet characterSetWithCharactersInString:@" \n\t\"“”‘’"];
        NSString *cleanedText = [matchedText stringByTrimmingCharactersInSet:trimSet];
        
        if (cleanedText.length > 0) {
            NSRange cleanedRange = [text rangeOfString:cleanedText options:NSLiteralSearch range:match.range];
            if (cleanedRange.location != NSNotFound) {
                NSTextCheckingResult *cleanedResult = [NSTextCheckingResult regularExpressionCheckingResultWithRanges:&cleanedRange count:1 regularExpression:regex];
                [cleanedMatches addObject:cleanedResult];
            }
        }
    }
    return [cleanedMatches copy];
}

//- (NSArray <NSTextCheckingResult *>*)splitTextForAudio:(NSString *)text{
//    if (text.whitespace.length == 0) return @[];
//    
//    NSString *pattern = @"[^。！？\n\\s]+";
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
//    NSArray <NSTextCheckingResult *> *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
//    return matches;
//}

- (void)handleTap:(UITapGestureRecognizer *)gesture{
    DBSpeechMenuView *speechView = [[DBSpeechMenuView alloc] init];
    speechView.audioRate = DBReadBookSetting.setting.speechSetting.rate;
    [UIScreen.appWindow addSubview:speechView];
    [speechView showAudiobookMenuView];
    self.speechView = speechView;
    
    DBWeakSelf
    speechView.speechBlock = ^(NSInteger index) {
        DBStrongSelfElseReturn
        
        DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceAddToBookshelf];
        NSInteger minutes = MAXINTERP;
        if (DBUnityAdConfig.openAd && posAd.extra.limit) minutes = 60*posAd.extra.limit;
        switch (index) {
            case 0:
                [self.speechManager pauseReaderSpeaking];
                break;
            case 1:
                [self.speechManager continueReaderSpeaking];
                break;
            case 3:
                [self changeAudiobookSoundVoice];
                break;
            case 10:
                [self changeSpeechTimeInMinutes:MIN(60, minutes)];
                break;
            case 11:
                [self changeSpeechTimeInMinutes:MIN(60*15, minutes)];
                break;
            case 12:
                [self changeSpeechTimeInMinutes:MIN(60*30, minutes)];
                break;
            case 13:
                [self changeSpeechTimeInMinutes:MIN(60*60, minutes)];
                break;
          
            default:
                [self finishAudiobookAction];
                break;
        }
    };
    
    speechView.speechRateBlock = ^(CGFloat rate) {
        DBStrongSelfElseReturn
        DBReadBookSetting *setting = DBReadBookSetting.setting;
        setting.speechSetting.rate = rate;
        [setting reloadSetting];
        
        self.speechManager.rate = rate;
    };
}

- (void)changeSpeechTimeInMinutes:(NSInteger)minutes{
    self.audioTime = minutes;
    self.audioDate = NSDate.date;
}

- (void)changeAudiobookSoundVoice{
    DBSpeechVoicePanView *speechVoiceView = [[DBSpeechVoicePanView alloc] init];
    speechVoiceView.selectIndex = DBReadBookSetting.setting.speechSetting.voiceIndex;
    speechVoiceView.dataList = self.speechManager.speechVoicesList;
    [speechVoiceView presentInView:UIScreen.appWindow];
    
    DBWeakSelf
    speechVoiceView.speechVoiceBlock = ^(NSInteger index, NSString *name) {
        DBStrongSelfElseReturn
        DBReadBookSetting *setting = DBReadBookSetting.setting;
        setting.speechSetting.voiceIndex = index;
        setting.speechSetting.name = name;
        [setting reloadSetting];
        self.speechManager.voice = index;
        self.speechView.name = name;
    };
}

- (void)audiobookPausePlayback{
    [self.speechManager pauseReaderSpeaking];
}

- (void)audiobookContinuePlayback{
    [self.speechManager continueReaderSpeaking];
}

- (DBReaderPageViewController *)readerPageVc{
    if (!_readerPageVc){
        _readerPageVc = [[DBReaderPageViewController alloc] init];
        _readerPageVc.view.frame = self.view.bounds;
    }
    return _readerPageVc;
}

- (DBSpeechManager *)speechManager{
    if (!_speechManager){
        _speechManager = [[DBSpeechManager alloc] init];
        [_speechManager speechSetting];
        
        DBWeakSelf
        _speechManager.speechFinishBlock = ^(BOOL speech) {
            DBStrongSelfElseReturn
            [self audiobookUpdateText];
        };
    }
    return _speechManager;
}

- (void)dealloc{
    [self.speechManager stopReaderSpeaking];
}

@end
