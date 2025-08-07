//
//  DBNetResultModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBDataResultModel;


@interface DBNetResultModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) id data;
@end

@interface DBDataResultModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger ver;

@end
NS_ASSUME_NONNULL_END
