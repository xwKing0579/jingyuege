//
//  DBPageIGModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/15.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>
#import "DBReaderAdViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBPageIGModel : NSObject<IGListDiffable>
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, assign) BOOL finish;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSAttributedString *content;

@property (nonatomic, assign) DBReaderAdType adType;
@end

NS_ASSUME_NONNULL_END
