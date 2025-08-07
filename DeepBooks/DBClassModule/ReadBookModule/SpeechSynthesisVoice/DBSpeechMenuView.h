//
//  DBSpeechMenuView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBSpeechMenuView : UIView
@property (nonatomic, copy) void (^speechBlock)(NSInteger index); //0 暂停，1 重启，2退出 3修改声音
@property (nonatomic, copy) void (^speechRateBlock)(CGFloat rate);

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat audioRate;


- (void)showAudiobookMenuView;

@end

NS_ASSUME_NONNULL_END
