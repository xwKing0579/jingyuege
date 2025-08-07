//
//  DBRegisterModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBRegisterModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *msg;
@end

NS_ASSUME_NONNULL_END
