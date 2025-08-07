//
//  DBPageIGModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/15.
//

#import "DBPageIGModel.h"

@implementation DBPageIGModel
- (id<NSObject>)diffIdentifier {
    return self.sectionId;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (self == object) return YES;
    if (![(NSObject *)object isKindOfClass:[DBPageIGModel class]]) return NO;
    DBPageIGModel *other = (DBPageIGModel *)object;
    return [self.sectionId isEqualToString:other.sectionId] && self.finish == other.finish;
}

@end
