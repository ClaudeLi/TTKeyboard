//
//  TBEmotionFlowLayout.h
//  Tiaooo
//
//  Created by ClaudeLi on 16/10/27.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBEmotionFlowLayout : UICollectionViewFlowLayout

// 一行中 cell的个数
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;

@end
