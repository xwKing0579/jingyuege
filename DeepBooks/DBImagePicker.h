//
//  DBImagePicker.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBImagePicker : NSObject

+ (void)showYPImagePickerWithRatio:(CGFloat)ratio completion:(void (^ _Nullable)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
