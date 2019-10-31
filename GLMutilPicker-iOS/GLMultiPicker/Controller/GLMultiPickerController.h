//
//  GLMultiPickerController.h
//  MultiTarget1
//
//  Created by lijinhai on 2019/10/30.
//  Copyright © 2019 gaussli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GLMultiPickerControllerDelegate;

typedef NSString * GLMultiPickerControllerInfoKey NS_TYPED_ENUM;
UIKIT_EXTERN GLMultiPickerControllerInfoKey const GLMultiPickerControllerMediaMetadata;
UIKIT_EXTERN GLMultiPickerControllerInfoKey const GLMultiPickerControllerLivePhoto;
UIKIT_EXTERN GLMultiPickerControllerInfoKey const GLMultiPickerControllerPHAsset;
UIKIT_EXTERN GLMultiPickerControllerInfoKey const GLMultiPickerControllerImageURL;

@interface GLMultiPickerController : UIViewController
@property(weak, nonatomic) id<GLMultiPickerControllerDelegate> delegate;
@end

@protocol GLMultiPickerControllerDelegate<NSObject>
- (void)mutilPickerController:(GLMultiPickerController *)picker didFinishPickingMediaWithInfos:(NSDictionary<GLMultiPickerControllerInfoKey, id> *)infos;
- (void)multiPickerControllerDidCancel:(GLMultiPickerController *)picker;
@end

NS_ASSUME_NONNULL_END
