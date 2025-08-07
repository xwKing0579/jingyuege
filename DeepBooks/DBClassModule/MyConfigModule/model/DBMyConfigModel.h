//
//  DBMyConfigModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBMyConfigModel : NSObject

+ (NSArray *)dataSourceList;
+ (NSArray *)myConfigContent;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *unreadCount;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL needLogin;
@property (nonatomic, copy) NSString *vc;
@end

NS_ASSUME_NONNULL_END
