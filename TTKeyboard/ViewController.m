//
//  ViewController.m
//  TTKeyboard
//
//  Created by ClaudeLi on 16/11/1.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "ViewController.h"
#import "TTKeyboard.h"

@interface ViewController ()<TBKeyboardInputDelegate>

@property (nonatomic, strong) TBKeyboardInputBar *inputBar;

@end

@implementation ViewController

- (TBKeyboardInputBar *)inputBar{
    if (!_inputBar) {
        _inputBar = [[TBKeyboardInputBar alloc] init];
        [_inputBar setTopViewIn:self.view];
        _inputBar.placeholderText = @"hello world~";
        _inputBar.delegate = self;
    }
    return _inputBar;
}

#pragma mark -
#pragma mark -- TBKeyboardInputDelegate --
- (void)clickKeyboardReturn:(NSString *)text{
    NSLog(@"sendText = %@", text);
}

- (void)clickTopViewHideKeyboard:(TBKeyboardInputBar *)inputBar{
    NSLog(@"%s", __func__);
}

- (void)clickOnceBtnOn:(TBKeyboardInputBar *)inputBar{
    NSLog(@"%s", __func__);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.inputBar];
}

#pragma mark -
#pragma mark -- 键盘横屏处理 --
// IOS >=8
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator: coordinator];
    [coordinator animateAlongsideTransition: ^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [_inputBar setInputBarLayout];
     } completion: ^(id<UIViewControllerTransitionCoordinatorContext> context) {
     }];
}
// IOS 7
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [_inputBar setInputBarLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
