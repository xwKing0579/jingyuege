//
//  DBActivityPermissionModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBActivityPermissionModel : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, assign) BOOL can_participate;
@property (nonatomic, copy) NSString *daily_count;
@end

NS_ASSUME_NONNULL_END
