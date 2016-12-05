//
//  TBKeyboardTopView.m
//  Tiaooo
//
//  Created by ClaudeLi on 16/10/28.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "TBKeyboardTopView.h"

@implementation TBKeyboardTopView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(touchesBegan)]) {
        [self.delegate touchesBegan];
    }
}

@end
