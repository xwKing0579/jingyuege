//
//  DBReaderScrollModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/19.
//

#import <Foundation/Foundation.h>
#import "DBReaderAdViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBReaderScrollModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *content;
@property (nonatomic, assign) DBReaderAdType adType;

@property (nonatomic, assign) BOOL finish;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSArray *contentList;
@end

NS_ASSUME_NONNULL_END
