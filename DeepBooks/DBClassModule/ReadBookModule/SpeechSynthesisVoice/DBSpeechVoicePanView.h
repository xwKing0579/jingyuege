//
//  DBSpeechVoicePanView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/18.
//

#import <HWPanModal/HWPanModal.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBSpeechVoicePanView : HWPanModalContentView
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) void (^speechVoiceBlock)(NSInteger index, NSString *name);
@end

NS_ASSUME_NONNULL_END
