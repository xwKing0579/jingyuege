//
//  DBAdBannerView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/8.
//

#import <UIKit/UIKit.h>
#import <MSaas/MSaas.h>
NS_ASSUME_NONNULL_BEGIN

@interface DBAdBannerView : UIView<SFNativeAdRenderProtocol>
@property (nonatomic, strong) SFFeedAdData *adData;
@property (nonatomic, strong) SFNativeManager *splashAdConfig;

@property (nonatomic, copy) void (^adViewCloseAction)(UIView *adContainerView);
@end

NS_ASSUME_NONNULL_END
