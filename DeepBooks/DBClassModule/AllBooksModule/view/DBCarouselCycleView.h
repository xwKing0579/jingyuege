//
//  DBCarouselCycleView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/2.
//

#import <UIKit/UIKit.h>
#import "DBAllBooksModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBCarouselCycleView : UIView
@property (nonatomic, strong) NSArray *imageGroup;

@property (nonatomic, strong) NSArray <DBBannerModel *>*imageModelGroup;

- (void)startBannerScroll;
- (void)endBannerScroll;
@end

NS_ASSUME_NONNULL_END
