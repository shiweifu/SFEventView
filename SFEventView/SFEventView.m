//
// Created by shiweifu on 5/25/15.
// Copyright (c) 2015 shiweifu. All rights reserved.
//

#import "SFEventView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kBGFadeDuration .2


@interface UIView(FrameHelpers)

- (CGFloat)x;
- (CGFloat)y;

- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setOrigin:(CGPoint)origin;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;

- (CGFloat)width;
- (CGFloat)height;

- (void)setSize:(CGSize)size;

+ (UIView *)lineViewWithColor:(UIColor *)color;

@end

@interface SFEventView()

@property (nonatomic, strong) NSArray  *topItems;
@property (nonatomic, strong) NSArray  *bottomItems;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIView *topSepLine;
@property (nonatomic, strong) UIView *bottomSepLine;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UICollectionView *topView;
@property (nonatomic, strong) UICollectionView *bottomView;

@property (nonatomic, strong) SSArrayDataSource *topDataSource;
@property (nonatomic, strong) SSArrayDataSource *bottomDataSource;

@property (nonatomic, strong) UICollectionViewLayout *topViewLayout;
@property (nonatomic, strong) UICollectionViewLayout *bottomViewLayout;


@property (nonatomic, strong) UIView *transparentView;
@property (nonatomic) BOOL visible;
@end

@implementation SFEventView
{
}

- (instancetype)initWithTitle:(NSString *)title
                     topItems:(NSArray  *)topItems
                  bottomItems:(NSArray  *)bottomItems
                   layoutType:(SFEventViewLayoutType) layoutType
{
  self = [super init];
  if (self)
  {
    _title = title;
    _bottomItems = bottomItems;
    _topItems    = topItems;
    _layoutType = layoutType;

    self.titleLabel.text = _title;
    [self addSubview:self.titleLabel];
    [self.titleLabel sizeToFit];

    _topView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                  collectionViewLayout:self.topViewLayout];
    [_topView setBackgroundColor:[UIColor whiteColor]];

    [_topView registerClass:[SFEventItemCell class]
 forCellWithReuseIdentifier:[SFEventItemCell identifier]];


    _bottomView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) 
                                     collectionViewLayout:self.bottomViewLayout];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];

    [_bottomView registerClass:[SFEventItemCell class]
    forCellWithReuseIdentifier:[SFEventItemCell identifier]];

    _topView.delegate = self;
    _bottomView.delegate = self;

    [self addSubview:self.topSepLine];
    [self addSubview:self.bottomSepLine];

    self.topDataSource.collectionView = _topView;
    self.topDataSource.cellClass = SFEventItemCell.class;
    _topView.dataSource = self.topDataSource;

    self.bottomDataSource.collectionView = _bottomView;
    self.bottomDataSource.cellClass = SFEventItemCell.class;
    _bottomView.dataSource = self.bottomDataSource;

    [self addSubview:_topView];
    [self addSubview:_bottomView];


    // 一行有几个
    CGFloat cols = kScreenWidth / 80;
    NSUInteger rows = (NSUInteger) ((topItems.count / cols) + 1);
    NSUInteger height = rows * 80 + rows * 10;

    [_topView setSize:(CGSize){kScreenWidth, height}];
    [_bottomView setSize:(CGSize){kScreenWidth, 110}];

    [self addSubview:self.cancelBtn];

    CGSize size = self.intrinsicContentSize;
    self.width = size.width;
    self.height = size.height;

    self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    self.transparentView.backgroundColor = [UIColor blackColor];
    self.transparentView.alpha = 0.0f;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelection)];
    tap.numberOfTapsRequired = 1;
    [self.transparentView addGestureRecognizer:tap];
    [self setBackgroundColor:[UIColor whiteColor]];
  }

  return self;
}

- (CGSize)intrinsicContentSize
{
  CGFloat width = kScreenWidth;
  CGFloat height = self.topView.height + self.bottomView.height + self.cancelBtn.height + 52;

  return (CGSize){width, height};
}


- (void)showInView:(UIView *)theView {

  [theView addSubview:self];
  [theView insertSubview:self.transparentView belowSubview:self];

  CGRect theScreenRect = [UIScreen mainScreen].bounds;

  float height;
  float x;

  if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
    height = CGRectGetHeight(theScreenRect);
    x = CGRectGetWidth(theView.frame) / 2.0;
    self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetWidth(theScreenRect), CGRectGetHeight(theScreenRect));
  } else {
    height = CGRectGetWidth(theScreenRect);
    x = CGRectGetHeight(theView.frame) / 2.0;
    self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetHeight(theScreenRect), CGRectGetWidth(theScreenRect));
  }

  self.center = CGPointMake(x, height + CGRectGetHeight(self.frame) / 2.0);
  self.transparentView.center = CGPointMake(x, height / 2.0);


  [UIView animateWithDuration:0.3f
                        delay:0
       usingSpringWithDamping:0.85f
        initialSpringVelocity:1.0f
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     self.transparentView.alpha = 0.4f;
                     self.center = CGPointMake(x, height - CGRectGetHeight(self.frame) / 2.0);

                   } completion:^(BOOL finished) {
            self.visible = YES;
          }];
}

- (void) cancelSelection {
  [self removeFromView];
}

- (void)removeFromView {
    [UIView animateWithDuration:0.3f
                          delay:0
         usingSpringWithDamping:0.85f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                       self.transparentView.alpha = 0.0f;
                       self.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.frame) / 2.0);

                     } completion:^(BOOL finished) {
              [self.transparentView removeFromSuperview];
              [self removeFromSuperview];
              self.visible = NO;
            }];
}

- (void)  collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  SFEventItem *item = nil;
  if(collectionView == self.topView)
  {
    item = self.topItems[(NSUInteger) indexPath.row];
  }
  else
  {
    item = self.bottomItems[(NSUInteger) indexPath.row];
  }

  if(item.action)
  {
    item.action(item);
  }

  [self cancelSelection];
}


#pragma mark - Property

- (UIButton *)cancelBtn
{
  if(!_cancelBtn)
  {
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消"
                forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor grayColor]
                     forState:UIControlStateNormal];

    [_cancelBtn setWidth:kScreenWidth];
    [_cancelBtn setHeight:50];
    [_cancelBtn addTarget:self
                   action:@selector(cancelSelection)
         forControlEvents:UIControlEventTouchUpInside];
  }
  return _cancelBtn;
}

- (UIView *)topSepLine
{
  if(!_topSepLine)
  {
    _topSepLine = [UIView lineViewWithColor:[UIColor lightGrayColor]];
  }
  return _topSepLine;
}

- (UIView *)bottomSepLine
{
  if(!_bottomSepLine)
  {
    _bottomSepLine = [UIView lineViewWithColor:[UIColor lightGrayColor]];
  }
  return _bottomSepLine;
}

-(SSArrayDataSource *)topDataSource
{
  if(!_topDataSource)
  {
    _topDataSource = [[SSArrayDataSource alloc] initWithItems:self.topItems];
    [_topDataSource setCellConfigureBlock:^(SFEventItemCell *cell, SFEventItem *object, id parentView, NSIndexPath *indexPath)
    {
      [cell.imageView setImage:object.image];
      cell.textLabel.text = object.text;
    }];
  }
  return _topDataSource;
}

-(SSArrayDataSource *)bottomDataSource
{
  if(!_bottomDataSource)
  {
    _bottomDataSource = [[SSArrayDataSource alloc] initWithItems:self.topItems];
    [_bottomDataSource setCellConfigureBlock:^(SFEventItemCell *cell, SFEventItem *object, id parentView, NSIndexPath *indexPath)
    {
      [cell.imageView setImage:object.image];
      cell.textLabel.text = object.text;
    }];

  }
  return _bottomDataSource;
}

- (UILabel *)titleLabel
{
  if(!_titleLabel)
  {
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_titleLabel setTextColor:[UIColor grayColor]];
  }
  return _titleLabel;
}

- (UICollectionViewLayout *)topViewLayout
{
  if(!_topViewLayout)
  {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    if(self.layoutType == SFEVentViewLayoutTypeVertical)
    {
      layout.scrollDirection = UICollectionViewScrollDirectionVertical;
      layout.minimumLineSpacing = 10.0f;
    }
    else
    {
      layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }

    layout.minimumInteritemSpacing = 0.0f;
    layout.sectionInset = UIEdgeInsetsMake( 5, 0, 5, 0) ;
    layout.itemSize = (CGSize){80, 80};
    _topViewLayout = layout;
  }
  return _topViewLayout;
}

- (UICollectionViewLayout *)bottomViewLayout
{
  if(!_bottomViewLayout)
  {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.sectionInset = UIEdgeInsetsMake( 5, 0, 10, 0) ;
    layout.itemSize = (CGSize){80, 80};
    _bottomViewLayout = layout;
  }
  return _bottomViewLayout;
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  self.titleLabel.x = kScreenWidth / 2 - self.titleLabel.width / 2 ;
  self.titleLabel.y = 15;

  [self.topView setY:self.titleLabel.y + self.titleLabel.height + 15];
  [self.topSepLine setY:self.topView.height + self.topView.y];

  [self.bottomView setY:self.topSepLine.height + self.topSepLine.y + 10];
  [self.bottomSepLine setY:self.bottomView.height + self.bottomView.y];

  [self.cancelBtn setY:self.bottomSepLine.y + self.bottomSepLine.height];
  [self.cancelBtn setWidth:kScreenWidth];
  [self.cancelBtn setHeight:44];
}

@end

@implementation SFEventItem

- (instancetype)initWithText:(NSString *)text
                        type:(NSString *)type
                       image:(UIImage *)image
                      action:(SFEventItemActionBlock)action
{
  self = [super init];
  if (self)
  {
    _text = text;
    _image = image;
    _type = type;
    _action = [action copy];
  }

  return self;
}

@end

@implementation SFEventItemCell

- (void)configureCell
{
  [self.contentView addSubview:self.textLabel];
  [self.contentView addSubview:self.imageView];
  self.imageView.x = self.contentView.width / 2 - self.imageView.width / 2;
//  [self.imageView setX:10];
  [self.imageView setY:0];

  self.textLabel.x = self.imageView.center.x - self.textLabel.width / 2;
  [self.textLabel setY:self.imageView.height + 10];
}

- (UILabel *)textLabel
{
  if(!_textLabel)
  {
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 10)];
    [_textLabel setFont:[UIFont systemFontOfSize:12]];
    [_textLabel setTextColor:[UIColor grayColor]];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
  }
  return _textLabel;
}

- (UIImageView *)imageView
{
  if(!_imageView)
  {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    CALayer *lay  = _imageView.layer;
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:25.0];
  }
  return _imageView;
}

@end

#pragma mark Private Utils

@implementation UIView (FrameHelpers)

- (CGFloat)x
{
  return self.frame.origin.x;
}

- (CGFloat)y
{
  return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (void)setX:(CGFloat)x{
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin{
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}

- (void)setHeight:(CGFloat)height{
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

- (void)setWidth:(CGFloat)width{
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)width
{
  return self.frame.size.width;
}

- (CGFloat)height
{
  return self.frame.size.height;
}

- (void)setSize:(CGSize)size{
  CGRect frame = self.frame;
  frame.size.width = size.width;
  frame.size.height = size.height;
  self.frame = frame;
}

+ (UIView *)lineViewWithColor:(UIColor *)color
{
  CGFloat screenWidth = kScreenWidth;
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
  lineView.backgroundColor = color;
  return lineView;
}

@end
