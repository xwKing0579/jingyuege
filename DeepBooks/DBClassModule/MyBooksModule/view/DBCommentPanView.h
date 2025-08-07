//
//  DBCommentPanView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import <HWPanModal/HWPanModal.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBCommentPanView : HWPanModalContentView
@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, assign) BOOL isComic;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, copy) void (^commentCompletedBlock)(BOOL commentCompleted);
@end

NS_ASSUME_NONNULL_END
