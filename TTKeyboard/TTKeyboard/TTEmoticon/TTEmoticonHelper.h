//
//  TTEmoticonHelper.h
//  TTKeyboard
//
//  Created by ClaudeLi on 16/11/1.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TTEmoticonHelper : NSObject

+ (NSRegularExpression *)regexEmoticon;

// 获取所有表情字典 {/微笑:001, ...}
+ (NSDictionary *)emoticonDic;

// 获取单个表情图片 emoString: [/微笑]
+ (UIImage *)emotuconWith:(NSString *)emoString;

// 获取所有表情key @[@"微笑", @"哈哈"...]
+ (NSArray *)emoticonNameArray;

+ (UIImage *)imageWithName:(NSString *)name;

@end
