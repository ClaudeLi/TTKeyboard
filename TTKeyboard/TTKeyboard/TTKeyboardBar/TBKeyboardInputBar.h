//
//  TBKeyboardInputBar.h
//  Tiaooo
//
//  Created by ClaudeLi on 16/10/28.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBKeyboardInputBar;
@protocol TBKeyboardInputDelegate <NSObject>
@required
- (void)clickKeyboardReturn:(NSString *)text;

@optional

- (void)clickTopViewHideKeyboard:(TBKeyboardInputBar *)inputBar;
- (void)clickOnceBtnOn:(TBKeyboardInputBar *)inputBar;

@end

@interface TBKeyboardInputBar : UIView

// 占位符
@property (nonatomic, copy) NSString *placeholderText;
// 输入的文字
@property (nonatomic, copy) NSString *text;
// 限制输入的文字长度
@property (nonatomic, assign) NSInteger  length;

@property (nonatomic, weak) id<TBKeyboardInputDelegate>delegate;

// 设置点击隐藏键盘view的superView
- (void)setTopViewIn:(UIView *)view;

- (void)becomeFirstResponder;

- (void)cancelKeyboard;

// 横竖屏切换调用
- (void)setInputBarLayout;

@end
