//
//  TBEmotionCell.m
//  Tiaooo
//
//  Created by ClaudeLi on 16/10/27.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "TBEmotionCell.h"

@implementation TBEmotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.emotion.contentMode = UIViewContentModeScaleAspectFit;
    self.emotion.clipsToBounds = YES;
}

@end
