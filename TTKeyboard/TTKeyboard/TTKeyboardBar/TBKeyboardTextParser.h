//
//  TBKeyboardTextParser.h
//  Tiaooo
//
//  Created by ClaudeLi on 16/10/28.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>

@interface TBKeyboardTextParser : NSObject<YYTextParser>

@property (nonatomic, strong) UIFont  *font;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightTextColor;

@end
