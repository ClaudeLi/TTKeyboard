//
//  TBEmoticonInputView.h
//  Tiaooo
//
//  Created by ClaudeLi on 16/7/6.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_emotionViewHeight 150.0f

@protocol TBEmoticonInputViewDelegate <NSObject>
@optional

- (void)emoticonInputDidTapText:(NSString *)text;   // 选择表情
- (void)emoticonInputDidTapBackspace;               // 删除
- (void)emoticonInputDidSelectedSend;               // 发送

@end

// 表情输入键盘
@interface TBEmoticonInputView : UIView

@property (nonatomic, weak) id<TBEmoticonInputViewDelegate> delegate;

// 显示
- (void)showInView:(UIView *)view;

// 隐藏
- (void)hide;

@end

