//
//  TBKeyboardTopView.h
//  Tiaooo
//
//  Created by ClaudeLi on 16/10/28.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBKeyboardTopViewDelegate <NSObject>

- (void)touchesBegan;

@end

@interface TBKeyboardTopView : UIView

@property (nonatomic, weak) id<TBKeyboardTopViewDelegate>delegate;

@end
