//
//  TTEmoticonHelper.m
//  TTKeyboard
//
//  Created by ClaudeLi on 16/11/1.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "TTEmoticonHelper.h"
#import <YYKit.h>

@implementation TTEmoticonHelper

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[/[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (UIImage *)emotuconWith:(NSString *)emoString{
    // 获取图片名
    NSString *imageName = [self emoticonDic][emoString];
    if (!imageName)return nil;
    UIImage *image = [self imageWithName:imageName];
    if (!image) return nil;
    return image;
}

+ (NSDictionary *)emoticonDic {
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"];
        dic = [self _emoticonDicFromPath:emoticonBundlePath];
    });
    return dic;
}

+ (NSArray *)emoticonNameArray {
    static NSMutableArray *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"];
        array = [self emoticonArrayFromPath:emoticonBundlePath];
    });
    return [array copy];
}

+ (NSMutableArray *)emoticonArrayFromPath:(NSString *)path {
    NSMutableArray *array = [NSMutableArray new];
    NSString *jsonPath = [path stringByAppendingPathComponent:@"infoEmotion.plist"];
    NSArray *plist = [NSArray arrayWithContentsOfFile:jsonPath];
    for (NSDictionary *subDic in plist) {
        [array addObject:[subDic allKeys][0]];
    }
    return array;
}

+ (NSMutableDictionary *)_emoticonDicFromPath:(NSString *)path {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *jsonPath = [path stringByAppendingPathComponent:@"infoEmotion.plist"];
    NSArray *plist = [NSArray arrayWithContentsOfFile:jsonPath];
    for (NSDictionary *subDic in plist) {
        [dic addEntriesFromDictionary:subDic];
    }
    return dic;
}

+ (UIImage *)imageWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"]];
    NSString *path = [bundle pathForScaledResource:name ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data scale:1];
    image.preloadAllAnimatedImageFrames = YES;
    return image;
}

@end
