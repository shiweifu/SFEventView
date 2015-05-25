//
// Created by shiweifu on 5/25/15.
// Copyright (c) 2015 shiweifu. All rights reserved.
//

#import "SFEventView.h"
#import "SSArrayDataSource.h"

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


@end

@implementation SFEventView
{
}

- (instancetype)initWithTitle:(NSString *)title
                     topItems:(NSArray  *)topItems
                  bottomItems:(NSArray  *)bottomItems
{
  self = [super init];
  if (self)
  {
    _title = title;
    _bottomItems = bottomItems;
    _topItems    = topItems;

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

    [_topView setSize:(CGSize){320, 200}];
    [_bottomView setSize:(CGSize){320, 100}];

    [self addSubview:self.cancelBtn];
  }

  return self;
}

-(void)showInView:(UIView *)view;
{

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
  }
  return _cancelBtn;

}

- (UIView *)topSepLine
{
  if(!_topSepLine)
  {
    _topSepLine = [UIView lineViewWithColor:[UIColor grayColor]];
  }
  return _topSepLine;
}

- (UIView *)bottomSepLine
{
  if(!_bottomSepLine)
  {
    _bottomSepLine = [UIView lineViewWithColor:[UIColor grayColor]];
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
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.sectionInset = UIEdgeInsetsMake( 0, 0, 0, 0) ;
    layout.itemSize = (CGSize){80, 100};
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
    layout.sectionInset = UIEdgeInsetsMake( 0, 0, 0, 0) ;
    layout.itemSize = (CGSize){80, 100};
    _bottomViewLayout = layout;
  }
  return _bottomViewLayout;
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  self.titleLabel.x = self.titleLabel.superview.width / 2 - self.titleLabel.width / 2 ;
  self.titleLabel.y = 0;

  [self.topView setY:self.titleLabel.height + 15];
  [self.topSepLine setY:self.topView.height + self.topView.y];

  [self.bottomView setY:self.topSepLine.height + self.topSepLine.y + 10];
  [self.bottomSepLine setY:self.bottomView.height + self.bottomView.y];

  [self.cancelBtn setY:self.bottomSepLine.y + self.bottomSepLine.height];
  [self.cancelBtn setWidth:320];
  [self.cancelBtn setHeight:50];
}

@end

@implementation SFEventItem

- (instancetype)initWithText:(NSString *)text
                       image:(UIImage *)image
                      action:(SFEventItemActionBlock)action
{
  self = [super init];
  if (self)
  {
    _text = text;
    _image = image;
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

  [self.imageView setX:10];
  [self.imageView setY:0];
  [self.textLabel setX:0];
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
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
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
  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
  lineView.backgroundColor = color;
  return lineView;
}

@end
