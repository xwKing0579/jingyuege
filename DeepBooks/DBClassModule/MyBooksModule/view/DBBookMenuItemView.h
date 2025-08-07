//
//  DBBookMenuItemView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import <UIKit/UIKit.h>
#import "DBBookMenuItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBookMenuItemView : UIView
@property (nonatomic, copy) DBBookMenuItemModel *model;
@property (nonatomic, assign) BOOL isSwitch;

@property (nonatomic, copy) void (^switchBlock)(BOOL isOn);
@end

NS_ASSUME_NONNULL_END
