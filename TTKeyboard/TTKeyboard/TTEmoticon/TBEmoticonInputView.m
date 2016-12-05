//
//  TBEmoticonInputView.m
//  Tiaooo
//
//  Created by ClaudeLi on 16/7/6.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "TBEmoticonInputView.h"
#import "TBEmotionCell.h"
#import "TBEmotionFlowLayout.h"
#import "TTKeyboard.h"

static CGFloat lineCount = 3.0f;
static NSString *itemIdentifier = @"emoticonItemIdentifier";
@interface TBEmoticonInputView () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{
    CGFloat   _listCount;
    NSInteger _pageCount;
    NSInteger _numOfSection;
    NSInteger maxCount;
    NSInteger emotionCount;
}
@property (nonatomic, strong) NSArray   *emoArray;
@property (nonatomic, strong) UIView    *emoticonView;
@property (nonatomic, strong) UIButton  *sendBtn;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic, strong) UICollectionView  *collectionView;

@end

@implementation TBEmoticonInputView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _listCount = 8.0f;
        _pageCount = 7;
        if (TTScreenWidth < 375.0) {
            _listCount = 7.0f;
            _pageCount = 8;
        }
        _numOfSection = lineCount * _listCount;
        maxCount = _numOfSection * _pageCount;
        [self setUpEmoticonView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_collectionView reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat _width = self.frame.size.width;
    _emoticonView.frame = CGRectMake(0, 5, _width, k_emotionViewHeight);
    _collectionView.frame = _emoticonView.bounds;
    _collectionView.contentSize = CGSizeMake(_width * _pageCount, k_emotionViewHeight);
    _pageControl.frame = CGRectMake(60, CGRectGetMaxY(_emoticonView.frame), _width - 120, 20);
    _sendBtn.frame = CGRectMake(_width - 60, TTEmotionViewHeight - 30, 60, 30);
}

- (void)getEmotionData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *array = [[TTEmoticonHelper emoticonNameArray] mutableCopy];
        self.emoArray = [array copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            emotionCount = self.emoArray.count;
            [self.collectionView reloadData];
        });
    });
}

# pragma mark FaceEmoticon
//表情视图
- (void)setUpEmoticonView{
    self.emoticonView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_emoticonView];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    [self addSubview:self.sendBtn];
    _pageControl.numberOfPages = _pageCount;
    [self getEmotionData];
}

- (void)nextPage{
    [_collectionView setContentOffset:CGPointMake(TTScreenWidth * _pageControl.currentPage, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)showInView:(UIView *)view{
    [self setFrame:CGRectMake(0, TTScreenHeight, TTScreenWidth, TTEmotionViewHeight)];
    _pageControl.currentPage = 0;
    [_collectionView setContentOffset:CGPointMake(0, 0)];
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        [self setFrame:CGRectMake(0, TTScreenHeight-TTEmotionViewHeight, TTScreenWidth, TTEmotionViewHeight)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:CGRectMake(0, TTScreenHeight, TTScreenWidth, TTEmotionViewHeight)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark -- 懒加载 --
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [_pageControl addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        TBEmotionFlowLayout *layout = [[TBEmotionFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemCountPerRow = (NSInteger)_listCount;
        layout.rowCount = (NSInteger)lineCount;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerNib:[UINib nibWithNibName:@"TBEmotionCell" bundle:nil] forCellWithReuseIdentifier:itemIdentifier];
    }
    return _collectionView;
}

#pragma mark -
#pragma mark -- UICollectionViewDataSource & UICollectionViewDelegate --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return maxCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TBEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    NSInteger i = indexPath.row;
    if (i < maxCount) {
        NSInteger remain = (i+1) % (_numOfSection);
        if (remain) {
            NSInteger num = floor((CGFloat)(i/_numOfSection));
            i = i - num;
            if (i < self.emoArray.count) {
                UIImage *image = [TTEmoticonHelper emotuconWith:self.emoArray[i]];
                cell.emotion.image = image;
            }else{
                cell.emotion.image = nil;
            }
        }else{
            UIImage *image = [UIImage imageNamed:@"TTIcon_deleteEmoticon"];
            cell.emotion.image = image;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger i = indexPath.row;
    if (i < maxCount) {
        NSInteger remain = (i+1) % (_numOfSection);
        if (remain) {
            NSInteger num = floor((CGFloat)(i/_numOfSection));
            i = i - num;
            if (i < self.emoArray.count) {
                [self lookBtnWith:i];
            }
        }else{
            [self lookdelete_mv];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.emoticonView.frame.size.width/_listCount, k_emotionViewHeight/lineCount);
}

#pragma mark -
#pragma mark -- self.delegate --
//删除
-(void)lookdelete_mv{
    if ([self.delegate respondsToSelector:@selector(emoticonInputDidTapBackspace)]) {
        [self.delegate emoticonInputDidTapBackspace];
    }
}

-(void)lookBtnWith:(NSInteger)row{
    if ([self.delegate respondsToSelector:@selector(emoticonInputDidTapText:)]) {
        NSString *text = [NSString stringWithFormat:@"[%@]", self.emoArray[row]];
        [self.delegate emoticonInputDidTapText:text];
    }
}

// 发送
- (void)sendBtnAction{
    if ([self.delegate respondsToSelector:@selector(emoticonInputDidSelectedSend)]) {
        [self.delegate emoticonInputDidSelectedSend];
    }
}


@end
