//
//  GLMultiPickerCollectionViewCell.h
//  MultiTarget1
//
//  Created by lijinhai on 2019/10/30.
//  Copyright © 2019 gaussli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GLMultiPickerCollectionViewCellDelegate<NSObject>
- (BOOL)multiPickerCollectionViewCellTag:(long)tag isSelected:(BOOL)isSelected;
@end

@interface GLMultiPickerCollectionViewCell : UICollectionViewCell
@property(weak, nonatomic) id<GLMultiPickerCollectionViewCellDelegate> delegate;

- (void)loadImage:(UIImage *)image;
- (void)loadData:(GLPhotoModel *)data;
@end

NS_ASSUME_NONNULL_END
