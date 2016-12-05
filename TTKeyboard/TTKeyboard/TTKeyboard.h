//
//  TTKeyboard.h
//  TTKeyboard
//
//  Created by ClaudeLi on 2016/12/5.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#ifndef TTKeyboard_h
#define TTKeyboard_h

// 屏幕尺寸
#define TTBounds         [UIScreen mainScreen].bounds
#define TTScreenWidth    [UIScreen mainScreen].bounds.size.width
#define TTScreenHeight   [UIScreen mainScreen].bounds.size.height

// 输入框高度
#define TTKeyboardBarHeight     49.0f
// 表情键盘高度
#define TTEmotionViewHeight     185.0f
// 输入文字大小
#define TTInputTextFontSize     14.0f

// weakSelf
#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self;

#import "TBKeyboardInputBar.h"
#import "TBEmoticonInputView.h"
#import "TTEmoticonHelper.h"

#endif /* TTKeyboard_h */
