//
//  TBKeyboardTextParser.m
//  Tiaooo
//
//  Created by ClaudeLi on 16/10/28.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "TBKeyboardTextParser.h"
#import "TTKeyboard.h"

@implementation TBKeyboardTextParser

- (instancetype)init {
    self = [super init];
    _lineSpacing = 2.0f;
    _font = [UIFont systemFontOfSize:TTInputTextFontSize];
    _textColor = [UIColor colorWithWhite:1 alpha:1];
    _highlightTextColor = [UIColor colorWithWhite:1 alpha:1];
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange {
    text.color = _textColor;
    {
        NSArray<NSTextCheckingResult *> *emoticonResults = [[TTEmoticonHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
        NSUInteger clipLength = 0;
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= clipLength;
            if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            NSString *emoString = [text.string substringWithRange:range];
            NSString *imageKey = [emoString substringWithRange:NSMakeRange(1, emoString.length - 2)];
            if (!imageKey) continue;
            UIImage *image = [TTEmoticonHelper emotuconWith:imageKey];
            if (!image) continue;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            YYTextBackedString *backed = [YYTextBackedString stringWithString:emoString];
            NSMutableAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:(TTInputTextFontSize - 2)].mutableCopy;
            // original text, used for text copy
            [emoText setTextBackedString:backed range:NSMakeRange(0, emoText.length)];
            [emoText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:NSMakeRange(0, emoText.length)];
            
            [text replaceCharactersInRange:range withAttributedString:emoText];
            
            if (selectedRange) {
                *selectedRange = [self _replaceTextInRange:range withLength:emoText.length selectedRange:*selectedRange];
            }
            clipLength += range.length - emoText.length;
        }
    }
    text.font = _font;
    text.maximumLineHeight = (TTInputTextFontSize + 4);
    text.lineSpacing = _lineSpacing;
    return YES;
}


// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}

@end
