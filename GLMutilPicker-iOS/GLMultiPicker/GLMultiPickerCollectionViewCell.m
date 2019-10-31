//
//  GLMultiPickerCollectionViewCell.m
//  MultiTarget1
//
//  Created by lijinhai on 2019/10/30.
//  Copyright © 2019 gaussli. All rights reserved.
//

#import "GLMultiPickerCollectionViewCell.h"

@interface GLMultiPickerCollectionViewCell ()
@property(strong, nonatomic) UIImageView *photoImageView;
@property(strong, nonatomic) UIView *maskView;
@property(strong, nonatomic) UIButton *selectButton;
@end

@implementation GLMultiPickerCollectionViewCell
#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.photoImageView];
        [self.contentView addSubview:self.maskView];
        [self.contentView addSubview:self.selectButton];
    }
    return self;
}

#pragma mark - Button Action
- (void)selectButtonAction:(id)sender {

    BOOL currentSelected = self.selectButton.selected;
    BOOL isAllowSelect = [self.delegate multiPickerCollectionViewCellTag:self.tag isSelected:!currentSelected];
    
    if (isAllowSelect) {
        self.selectButton.selected = !self.selectButton.selected;
        self.maskView.hidden = !self.maskView.hidden;
    }
}

#pragma mark - Custom Expose Method
- (void)loadImage:(UIImage *)image {
    self.photoImageView.image = image;
}
- (void)loadData:(GLPhotoModel *)model {
    self.selectButton.selected = model.selected;
    self.maskView.hidden = !model.selected;
}

#pragma mark - Lazy Loading
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
    }
    return _photoImageView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.contentView.frame];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [_maskView setHidden:YES];
    }
    return _maskView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width - 8.0 - 24, 8.0, 24.0, 24.0)];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"choose_selected"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
@end
