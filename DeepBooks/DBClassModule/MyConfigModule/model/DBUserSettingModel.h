//
//  DBUserSettingModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBUserSettingModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) id avater;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isArrow;

+ (NSArray *)dataSourceList;

@end

NS_ASSUME_NONNULL_END
