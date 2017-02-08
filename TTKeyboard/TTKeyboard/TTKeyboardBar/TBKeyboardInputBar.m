//
//  TBKeyboardInputBar.m
//  Tiaooo
//
//  Created by ClaudeLi on 16/10/28.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "TBKeyboardInputBar.h"
#import "TBKeyboardTextParser.h"
#import "TBKeyboardTopView.h"
#import "TTKeyboard.h"
#import <Masonry.h>

@interface TBKeyboardInputBar ()<YYTextViewDelegate, TBEmoticonInputViewDelegate, TBKeyboardTopViewDelegate>{
    CGFloat _height;
    CGFloat _width;
}

@property (nonatomic, strong) YYTextView *inputView;
@property (nonatomic, strong) UIView     *lineView;
@property (nonatomic, strong) UIView     *otherView;
@property (nonatomic, strong) UIButton   *emoBtn;
@property (nonatomic, strong) UIButton   *onceBtn;

@property (nonatomic, strong) TBEmoticonInputView *emoticonView;

// 在InputBar上方的一个透明视图, Used to 点击隐藏键盘
@property (nonatomic, strong) TBKeyboardTopView *topView;

@end

@implementation TBKeyboardInputBar

- (void)setTopViewIn:(UIView *)view{
    [view addSubview:self.topView];
}

- (void)setPlaceholderText:(NSString *)placeholderText{
    _placeholderText = placeholderText;
    _inputView.placeholderText = _placeholderText;
}

- (NSString *)text{
    return _inputView.text;
}

- (void)setText:(NSString *)text{
    _inputView.text = text;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _height = TTKeyboardBarHeight;
        self.backgroundColor = [UIColor brownColor];
        self.frame =  CGRectMake(0, TTScreenHeight - _height, TTScreenWidth, _height);
        [self setUpUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.inputView];
    [self addSubview:self.lineView];
    [self addSubview:self.emoBtn];
    [self addSubview:self.otherView];
    [_otherView addSubview:self.onceBtn];
    self.emoticonView = [[TBEmoticonInputView alloc] init];
    _emoticonView.delegate = self;
    WS(ws)
    [_otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws);
        make.right.equalTo(ws);
        make.bottom.equalTo(ws);
        make.width.mas_equalTo(65);
    }];
    [_onceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.otherView);
    }];
    
    [_emoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws);
        make.right.equalTo(ws.otherView.mas_left);
        make.bottom.equalTo(ws);
        make.width.mas_equalTo(30);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).with.offset(5);
        make.left.equalTo(ws).with.offset(18);
        make.bottom.equalTo(ws).with.offset(-8);
        make.right.equalTo(ws.emoBtn.mas_left);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.inputView.mas_bottom).with.offset(1);
        make.left.equalTo(ws.inputView.mas_left);
        make.right.equalTo(ws.otherView.mas_left);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark -
#pragma mark -- 收到通知、监控键盘 --
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (_emoBtn.selected) {
        [self hideEmoView];
    }
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         CGRect newInputViewFrame = self.frame;
                         newInputViewFrame.origin.y = TTScreenHeight - CGRectGetHeight(self.frame)-kbSize.height;
                         self.frame = newInputViewFrame;
                         _topView.frame = CGRectMake(0, 0, TTScreenWidth, newInputViewFrame.origin.y);
                     }
                     completion:nil];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    if (_emoBtn.selected) {
        [self setWhenEmotionShowFrame];
    }else{
        NSDictionary* info = [notification userInfo];
        [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0
                            options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                         animations:^{
                             self.center = CGPointMake(self.centerX, TTScreenHeight-CGRectGetHeight(self.frame)/2.0);
                             _topView.frame = CGRectZero;
                         }
                         completion:nil];
    }
}

#pragma mark -
#pragma mark -- YYTextViewDelegate --
- (void)textViewDidChange:(YYTextView *)textView {
    NSLog(@"%@", textView.text);
    if (self.length) {
        if (textView.text.length > self.length) {
            textView.text = [textView.text substringToIndex:self.length];
        }
    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self clickReturnAction];
        return NO;
    }
    return YES;
}

- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect {
    NSLog(@"tap text range:%@", highlight.userInfo);
}
- (void)textView:(YYTextView *)textView didLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect {
    NSLog(@"long press text range:%@", highlight.userInfo);
}

#pragma mark -
#pragma mark -- 表情键盘协议 --
- (void)emoticonInputDidTapBackspace{
    [_inputView deleteBackward];
}

- (void)emoticonInputDidTapText:(NSString *)text{
    [_inputView replaceRange:_inputView.selectedTextRange withText:text];
}

- (void)emoticonInputDidSelectedSend{
    [self clickReturnAction];
}

#pragma mark -
#pragma mark -- Action --
// 点击表情
- (void)clickEmoBtnAction{
    if (_emoBtn.selected) {
        [_inputView becomeFirstResponder];
    }else{
        _emoBtn.selected = YES;
        [_inputView resignFirstResponder];
        [self.emoticonView showInView:self.superview];
        [UIView animateWithDuration:0.25 animations:^{
            [self setWhenEmotionShowFrame];
        }];
    }
}

- (void)setWhenEmotionShowFrame{
    self.center = CGPointMake(self.centerX, TTScreenHeight-TTEmotionViewHeight-CGRectGetHeight(self.frame)/2.0);
    _topView.frame = CGRectMake(0, 0, TTScreenWidth, self.origin.y);
}

- (void)hideEmoView{
    _emoBtn.selected = NO;
    [_emoticonView hide];
}

#pragma mark -
#pragma mark -- TBKeyboardTopViewDelegate --
- (void)touchesBegan{
    [self cancelKeyboard];
    if ([self.delegate respondsToSelector:@selector(clickTopViewHideKeyboard:)]) {
        [self.delegate clickTopViewHideKeyboard:self];
    }
}

- (void)becomeFirstResponder{
    [_inputView becomeFirstResponder];
}

// 取消键盘
- (void)cancelKeyboard{
    _topView.frame = CGRectZero;
    if (_emoBtn.selected) {
        [self hideEmoView];
        [UIView animateWithDuration:0.2 animations:^{
            self.center = CGPointMake(self.centerX, TTScreenHeight - CGRectGetHeight(self.frame)/2.0);
        }];
    }else{
        [_inputView resignFirstResponder];
    }
}

- (void)dealloc{
    [self removeAllNotification];
}

- (void)removeAllNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 
#pragma mark -- 懒加载 --
- (YYTextView *)inputView{
    if (!_inputView) {
        _inputView = [YYTextView new];
        _inputView.textParser = [TBKeyboardTextParser new];
        _inputView.textContainerInset = UIEdgeInsetsMake(11, 0, 0, 0);
        _inputView.font = [UIFont systemFontOfSize:TTInputTextFontSize];
        _inputView.placeholderFont = [UIFont systemFontOfSize:TTInputTextFontSize];;
        _inputView.placeholderTextColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        _inputView.delegate = self;
        _inputView.inputAccessoryView = [UIView new];
        _inputView.returnKeyType = UIReturnKeySend;
    }
    return _inputView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    return _lineView;
}

- (UIButton *)emoBtn{
    if (!_emoBtn) {
        _emoBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_emoBtn setImage:[UIImage imageNamed:@"TTIcon_expression"] forState:UIControlStateNormal];
        [_emoBtn setImage:[UIImage imageNamed:@"TTIcon_keyboard"] forState:UIControlStateSelected];
        [_emoBtn addTarget:self action:@selector(clickEmoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emoBtn;
}

- (UIView *)otherView{
    if (!_otherView) {
        _otherView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _otherView;
}

-(UIButton *)onceBtn{
    if (!_onceBtn) {
        _onceBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_onceBtn setImage:[UIImage imageNamed:@"TTIcon_share"] forState:UIControlStateNormal];
        [_onceBtn addTarget:self action:@selector(clickOnceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onceBtn;
}


- (TBKeyboardTopView *)topView{
    if (!_topView) {
        _topView = [[TBKeyboardTopView alloc] initWithFrame:CGRectZero];
        _topView.delegate = self;
    }
    return _topView;
}

#pragma mark -
#pragma mark -- self.delegate --
- (void)clickOnceBtnAction{
    if ([self.delegate respondsToSelector:@selector(clickOnceBtnOn:)]) {
        [self cancelKeyboard];
        [self.delegate clickOnceBtnOn:self];
    }
}

- (void)clickReturnAction{
    NSString *str = [_inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self.delegate respondsToSelector:@selector(clickKeyboardReturn:)]) {
        [self.delegate clickKeyboardReturn:str];
    }
}

- (void)setInputBarLayout{
    self.frame =  CGRectMake(0, TTScreenHeight - _height, TTScreenWidth, _height);
    [self cancelKeyboard];
}

@end
