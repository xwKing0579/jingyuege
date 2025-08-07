//
//  DBEmptyView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBEmptyView : UIView
@property (nonatomic, strong) id imageObj;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *action;

@property (nonatomic, strong) UIButton *reloadButton;

@property (nonatomic, copy, nullable) NSArray *dataList;

@property (nonatomic, copy) void (^reloadBlock)(void);
@end

NS_ASSUME_NONNULL_END
