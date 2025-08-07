//
//  DBBookCommentPanView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/9.
//

#import <HWPanModal/HWPanModal.h>
#import "DBBookCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBookCommentPanView : HWPanModalContentView
@property (nonatomic, copy) DBBookCommentModel *model;
@end

NS_ASSUME_NONNULL_END
