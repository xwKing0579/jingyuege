//
//  DBFeedbackModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBFeedbackModel : NSObject
@property (nonatomic, copy) NSString *contact_info;
@property (nonatomic, copy) NSString *accepted_at;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *reply;
@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END
