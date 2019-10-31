//
//  GLMultiPickerController.m
//  MultiTarget1
//
//  Created by lijinhai on 2019/10/30.
//  Copyright © 2019 gaussli. All rights reserved.
//

#import "GLMultiPickerController.h"
#import "GLMultiPickerCollectionViewCell.h"
#import "GLPhotoModel.h"

#import <Photos/Photos.h>

@interface GLMultiPickerController ()<UICollectionViewDelegate, UICollectionViewDataSource, GLMultiPickerCollectionViewCellDelegate>
@property(strong, nonatomic) UIView *headerBgView;
@property(strong, nonatomic) UIButton *cancelButton;
@property(strong, nonatomic) UIButton *confirmButton;
@property(strong, nonatomic) UICollectionView *multiPickerCollectionView;
@property(assign, nonatomic) CGFloat screenWidth;
@property(assign, nonatomic) CGFloat screenHeght;

@property(strong, nonatomic) PHImageManager *imageManager;
@property(strong, nonatomic) PHImageRequestOptions *options;
@property(assign, nonatomic) CGSize targetSize;

@property(strong, nonatomic) NSMutableArray<GLPhotoModel *> *photoArray;
@property(strong, nonatomic) NSMutableArray<GLPhotoModel *> *selectedArray;
@end

@implementation GLMultiPickerController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1.0];
    
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeght = [UIScreen mainScreen].bounds.size.height;
    [self initialSubView];
    
    self.imageManager = [PHCachingImageManager defaultManager];
    self.options = [[PHImageRequestOptions alloc] init];
    self.options.resizeMode = PHImageRequestOptionsResizeModeFast;
    self.options.synchronous = YES;
    self.targetSize = CGSizeMake(120, 120);
    
    [self getThumbnailImages];
}

#pragma mark - Initial Subviews
- (void)initialSubView {
    [self.view addSubview:self.headerBgView];
    [self.view addSubview:self.multiPickerCollectionView];
}

#pragma mark - Button Action
- (void)cancelButtonAction:(id)sender {
    [self.delegate multiPickerControllerDidCancel:self];
}

- (void)confirmButtonAction:(id)sender {
    [self.delegate mutilPickerController:self didFinishPickingMediaWithInfos:[NSDictionary dictionary]];
}

#pragma mark - UICollectionView Delegate & DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLMultiPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLMultiPickerCollectionViewCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.imageManager requestImageForAsset:self.photoArray[indexPath.item].asset targetSize:self.targetSize contentMode:PHImageContentModeDefault options:strongSelf.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell loadImage:result];
                [cell loadData:self.photoArray[indexPath.item]];
                cell.tag = indexPath.item;
                cell.delegate = self;
            });
        }];
    });
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoArray count];
}

#pragma mark - GLMultiPickerCollectionViewCell Delegate
- (BOOL)multiPickerCollectionViewCellTag:(long)tag isSelected:(BOOL)isSelected {
    if (isSelected) {
        if ([self.selectedArray count] >= 9) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你最多只能选择9张图片" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return NO;
        }
        self.photoArray[tag].selected = YES;
        [self.selectedArray addObject:self.photoArray[tag]];
    }
    else {
        self.photoArray[tag].selected = NO;
        [self.selectedArray removeObject:self.photoArray[tag]];
    }
    [self.confirmButton setTitle:[NSString stringWithFormat:@"确认(%lu)", [self.selectedArray count]] forState:UIControlStateNormal];
    return YES;
}

#pragma mark - Custom Inner Method
- (void) getThumbnailImages {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (PHAsset *asset in assets) {
            GLPhotoModel *model = [[GLPhotoModel alloc] init];
            model.asset = asset;
            model.selected = NO;
            [strongSelf.photoArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.multiPickerCollectionView reloadData];
        });
    });
}

#pragma mark - Lazy loading
- (UIView *)headerBgView {
    if (!_headerBgView) {
        _headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, ((UIWindowScene*)[UIApplication sharedApplication].connectedScenes.allObjects.lastObject).statusBarManager.statusBarFrame.size.height, self.screenWidth, 44)];
        _headerBgView.backgroundColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1.0];

        [_headerBgView addSubview:self.cancelButton];
        [_headerBgView addSubview:self.confirmButton];
    }
    return _headerBgView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth - 100, 0, 100, 44)];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_confirmButton setTitle:@"确认(0)" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithRed:87/255.0 green:189/255.0 blue:106/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UICollectionView *)multiPickerCollectionView {
    if (!_multiPickerCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        CGFloat itemW = (self.screenWidth - 10.0) / 4;
        CGFloat itemH = itemW;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        
        _multiPickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.headerBgView.frame.origin.y +  self.headerBgView.frame.size.height, self.screenWidth, self.screenHeght - self.headerBgView.frame.origin.y - self.headerBgView.frame.size.height) collectionViewLayout:flowLayout];
        _multiPickerCollectionView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        _multiPickerCollectionView.delegate = self;
        _multiPickerCollectionView.dataSource = self;
        [_multiPickerCollectionView registerClass:[GLMultiPickerCollectionViewCell class] forCellWithReuseIdentifier:@"GLMultiPickerCollectionViewCell"
         ];
    }
    return _multiPickerCollectionView;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

@end
