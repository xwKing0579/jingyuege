//
//  DBImagePicker.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/10.
//

#import "DBImagePicker.h"
#import <TZImagePickerController.h>
@implementation DBImagePicker

+ (void)showYPImagePickerWithRatio:(CGFloat)ratio completion:(void (^ _Nullable)(UIImage *image))completion{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] init];
    DBWeakSelf
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        DBStrongSelfElseReturn
        UIImage *image = photos.firstObject;
        if (image) completion(image);
    }];
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.allowPickingGif = YES;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [UIScreen.currentViewController presentViewController:imagePickerVc animated:YES completion:nil];
}

@end
