//
//  DBDomainModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/7.
//

#import "DBDomainModel.h"

@implementation DBDomainModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"Question" : DBQuestionModel.class,
        @"Answer" : DBAnswerModel.class,
    };
}
@end

@implementation DBQuestionModel

@end


@implementation DBAnswerModel
@end
