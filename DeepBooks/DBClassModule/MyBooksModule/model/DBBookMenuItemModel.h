//
//  DBBookMenuItemModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBookMenuItemModel : NSObject
@property (nonatomic, assign) NSInteger mid;
@property (nonatomic, assign) NSInteger isSwitch;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;

+ (NSArray *)dataSourceList;
@end

NS_ASSUME_NONNULL_END
