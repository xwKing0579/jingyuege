//
//  DBReadBookSettingView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBReadBookSettingView : UIView

@property (nonatomic, copy) void (^clickMenuAction)( UIButton * _Nullable sender,NSInteger index);
@property (nonatomic, copy) void (^scrollSliderAction)(CGFloat value, BOOL finish);

@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *listenBookButton;
@property (nonatomic, copy) UIColor *bookgroundColor;

@property (nonatomic, assign) CGFloat sliderValue;

//章节信息
@property (nonatomic, copy) NSString *chapterName;
@property (nonatomic, copy) NSString *rateValue;

//缓存文案
@property (nonatomic, copy, nullable) NSString *cacheText;

- (void)showPanelViewAnimation;
- (void)hiddenPanelViewAnimation;

@end

NS_ASSUME_NONNULL_END
