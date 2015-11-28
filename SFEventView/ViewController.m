//
//  ViewController.m
//  SFEventView
//
//  Created by shiweifu on 5/25/15.
//  Copyright (c) 2015 shiweifu. All rights reserved.
//


#import "ViewController.h"
#import "SFEventView.h"


@interface ViewController ()

@property (nonatomic, strong) SFEventView *eventView;

@end

@implementation ViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
//  [self.view addSubview:self.eventView];


  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setTitle:@"click" forState:UIControlStateNormal];
  [btn setFrame:CGRectMake(100, 300, 80, 50)];
  [btn setTitleColor:[UIColor darkGrayColor]
            forState:UIControlStateNormal];
  [btn addTarget:self
          action:@selector(onClick:)
forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn];


}

- (void)onClick:(id)onClick
{
  [self.eventView showInView:self.view];
}

- (SFEventView *)eventView
{
  if(!_eventView)
  {

    NSMutableArray *arr = [@[] mutableCopy];
    NSMutableArray *bottomArray = [@[] mutableCopy];

    NSArray *titles = @[@"微信好友", @"微信朋友圈", @"印象笔记", @"QQ", @"Pocket", @"复制链接", @"新浪微博", @"有道云笔记"];

    for(int i = 5; i < 15; i++)
    {
      NSString *imgName = [NSString stringWithFormat:@"sns_icon_%d", i+1];
      UIImage *img = [UIImage imageNamed:imgName];
      NSString *title = titles[arc4random_uniform(titles.count)];

      SFEventItemActionBlock action = ^(SFEventItem *item)
      {
        NSLog(@"%@", item.text);
      };

      SFEventItem *item = [[SFEventItem alloc] initWithText:title
                                                       type:@"test"
                                                       image:img
                                                      action:action];



      [arr addObject:item];
    }

    for(int i = 0; i < 1; i++)
    {
      NSString *imgName = [NSString stringWithFormat:@"sns_icon_%d", i+20];
      UIImage *img = [UIImage imageNamed:imgName];

      SFEventItem *item = [[SFEventItem alloc] initWithText:@"weixin"
                                                       type:@"weixin"
                                                       image:img
                                                      action:nil];
      [bottomArray addObject:item];
    }

    _eventView = [[SFEventView alloc] initWithTitle:@"分享问题"
                                           topItems:arr
                                        bottomItems:bottomArray
                                         layoutType:SFEVentViewLayoutTypeHorizontal];
  }
  return _eventView;
}

@end
