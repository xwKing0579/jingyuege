//
//  DBDomainModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/7.
//

#import <Foundation/Foundation.h>
@class DBQuestionModel,DBAnswerModel;
NS_ASSUME_NONNULL_BEGIN

@interface DBDomainModel : NSObject
@property (nonatomic, assign) BOOL AD;
@property (nonatomic, assign) NSInteger Status;
@property (nonatomic, assign) BOOL RA;
@property (nonatomic, assign) BOOL CD;
@property (nonatomic, strong) DBQuestionModel *Question;
@property (nonatomic, strong) NSArray <DBAnswerModel *> *Answer;
@property (nonatomic, assign) BOOL RD;
@property (nonatomic, assign) BOOL TC;
@end

@interface DBQuestionModel : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *name;
@end

@interface DBAnswerModel : NSObject
@property (nonatomic, copy) NSString *data;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger TTL;
@end

NS_ASSUME_NONNULL_END
