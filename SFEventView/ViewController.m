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
  [self.view addSubview:self.eventView];
  [self.eventView setFrame:CGRectMake(0, 50, 320, 392)];
  [self.eventView setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SFEventView *)eventView
{
  if(!_eventView)
  {

    NSMutableArray *arr = [@[] mutableCopy];
    NSMutableArray *bottomArray = [@[] mutableCopy];

    for(int i = 0; i < 20; i++)
    {
      SFEventItem *item1 = [[SFEventItem alloc] initWithText:@"QQ"
                                                       image:[UIImage imageNamed:@"icon1"]
                                                      action:nil];
      [arr addObject:item1];
    }

    for(int i = 0; i < 1; i++)
    {
      SFEventItem *item1 = [[SFEventItem alloc] initWithText:@"weixin"
                                                       image:[UIImage imageNamed:@"icon2"]
                                                      action:nil];
      [bottomArray addObject:item1];
    }

    _eventView = [[SFEventView alloc] initWithTitle:@"分享问题"
                                           topItems:arr
                                        bottomItems:bottomArray];
  }
  return _eventView;
}

@end
