//
// Created by shiweifu on 5/25/15.
// Copyright (c) 2015 shiweifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SSDataSources/SSDataSources.h>

typedef void (^SFEventItemActionBlock)(id sender);

@interface SFEventItem : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIImage  *image;
@property (copy) SFEventItemActionBlock action;

- (instancetype)initWithText:(NSString *)text
                        type:(NSString *)type
                       image:(UIImage *)image
                      action:(SFEventItemActionBlock)action;

@end

@interface SFEventView : UIView <UICollectionViewDelegate>


- (instancetype)initWithTitle:(NSString *)title
                     topItems:(NSArray *)topItems
                  bottomItems:(NSArray *)bottomItems;

-(void)showInView:(UIView *)view;

@end

@interface SFEventItemCell : SSBaseCollectionCell

@property (nonatomic, strong) UILabel     *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end


