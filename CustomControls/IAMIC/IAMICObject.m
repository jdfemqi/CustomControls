//
//  IAMICObject.m
//  IAMIC
//
//  Created by jdfemqi on 16/2/26.
//  Copyright © 2016年 jdfemqi. All rights reserved.
//

#import "IAMICObject.h"


#define IMAGEVIEW_COUNT 3


@interface IAMICObject() <UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    UIImageView* _leftImageView;
    UIImageView* _centerImageView;
    UIImageView* _rightImageView;
    UIPageControl* _pageControl;
    UIView *_superView;         // 父视图
    
    CGRect _scrollRect;     // scroll位置
    
    NSString* _plistPath;    // 资源汇总文件路径
    NSString* _resourcePath; // 资源存放路径
    NSMutableDictionary* _imageData;// 图片数据
    int _currentImageIndex; // 当前图片索引
    int _imageCount;        // 图片总数
    
    BOOL _autoScroll;
    NSTimer *_autoScrollTimer;
}

@end

@implementation IAMICObject

-(void)setResourcePath: (NSString*)plistPath : (NSString*)resourcePath{
    // TODO:有效性判断（扩展名）
    
    _plistPath = plistPath;
    _resourcePath = resourcePath;
}

- (void)setConfigure: (UIView *)superView : (CGRect)showRect{
    // Do any additional setup after loading the view.
    
    if (superView == nil) {
        NSLog(@"error ");
        return;
        
    }
    
    _superView = superView;
    _scrollRect = showRect;
    
    // 加载数据
    [self loadImageData];
    
    // 添加滚动控件
    [self addScrollView];
    
    // 添加图片控件
    [self addImageViews];
    
    // 添加分页控件
    [self addPageControl];
    
    // 加载默认图片
    [self setDefaultImage];
}


#pragma mark  加载图片数据
-(void)loadImageData{
    // 读取程序包中的资源文件
    _imageData = [NSMutableDictionary dictionaryWithContentsOfFile:_plistPath];
    _imageCount = (int)_imageData.count;
}

#pragma mark  添加滚动控件
-(void)addScrollView{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:_scrollRect];
    [_superView addSubview:_scrollView];
    
    CGSize scrollSize = _scrollRect.size;
    
    _scrollView.backgroundColor = [UIColor colorWithRed:120/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    
    // 设置contentSize
    _scrollView.contentSize = CGSizeMake(IMAGEVIEW_COUNT* (scrollSize.width), scrollSize.height);
    
    // 设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(scrollSize.width, 0) animated:NO];
    
    // 设置分页
    _scrollView.pagingEnabled = YES;
    
    // 去掉滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置代理
    _scrollView.delegate = self;
    
    _autoScroll = FALSE;
}

#pragma mark  添加图片控件
-(void)addImageViews{
    
    CGSize scrollSize = _scrollRect.size;
    
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollSize.width, scrollSize.height)];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_leftImageView];
    
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollSize.width, 0, scrollSize.width, scrollSize.height)];
    _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_centerImageView];
    
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2*scrollSize.width, 0, scrollSize.width, scrollSize.height)];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_rightImageView];
    
}
#pragma mark  添加分页控件
-(void)addPageControl{
    _pageControl = [[UIPageControl alloc]init];
    
    // scrollView大小
    CGSize scrollSize = _scrollRect.size;
    CGPoint scrollPoint = _scrollRect.origin;
    
    // 注意此方法可以根据页数返回UIPageControl合适的大小
    //CGSize size = [_pageControl sizeForNumberOfPages:_imageCount];
   // _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake((scrollPoint.x + scrollPoint.x + scrollSize.width) / 2, scrollPoint.y + scrollSize.height - 20);
    
    //NSLog(@"pagecenter.x = %f, pagecenter.y = %f", _pageControl.center.x, _pageControl.center.y);
    
    // 设置颜色
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    
    // 设置当前颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    
    // 设置总页数
    _pageControl.numberOfPages = _imageCount;
    
    [_superView addSubview:_pageControl];
}

#pragma mark  加载默认图片
-(void)setDefaultImage{
    
    NSString* strImageName = [_imageData objectForKey:[NSString stringWithFormat:@"%i", _imageCount - 1]];
    NSString* strImagePath;
    
    strImagePath = [NSString stringWithFormat:@"%@/%@", _resourcePath, strImageName];
    _leftImageView.image = [UIImage imageWithContentsOfFile:strImagePath];
    
    strImageName = [_imageData objectForKey:[NSString stringWithFormat:@"%i", 0]];
    strImagePath = [NSString stringWithFormat:@"%@/%@", _resourcePath, strImageName];
    _centerImageView.image = [UIImage imageWithContentsOfFile:strImagePath];
    
    strImageName = [_imageData objectForKey:[NSString stringWithFormat:@"%i", 1]];
    strImagePath = [NSString stringWithFormat:@"%@/%@", _resourcePath, strImageName];
    _rightImageView.image = [UIImage imageWithContentsOfFile:strImagePath];
    
    _currentImageIndex = 0;
    
    // 设置当前页
    _pageControl.currentPage = _currentImageIndex;
}

#pragma mark 滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGSize scrollSize = _scrollRect.size;
    CGPoint offset = [_scrollView contentOffset];
    if (offset.x > scrollSize.width) { //向右滑动
        _currentImageIndex = (_currentImageIndex + 1)%_imageCount;
    }else if(offset.x < scrollSize.width){ // 向左滑动
        _currentImageIndex = (_currentImageIndex + _imageCount - 1)%_imageCount;
    }
    
    // 重新加载图片
    [self reloadImage];
    
    // 移动到中间
    [_scrollView setContentOffset:CGPointMake(scrollSize.width, 0) animated:NO];
    
    // 设置分页
    _pageControl.currentPage = _currentImageIndex;
}

#pragma mark 自动滚动
-(void)shouldAutoShow:(BOOL)shouldStart
{
    _autoScroll = shouldStart;
    if (shouldStart)  //开启自动翻页
    {
        if (!_autoScrollTimer) {
            _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
        }
    }
    else   //关闭自动翻页
    {
        if (_autoScrollTimer.isValid) {
            [_autoScrollTimer invalidate];
            _autoScrollTimer = nil;
        }
    }
}

#pragma mark 展示下一页
-(void)autoShowNextImage
{
    if (_currentImageIndex == _imageCount - 1) {
        _currentImageIndex = 0;
    }else{
        _currentImageIndex ++;
    }
    
    [self reloadImage];
    
    // 移动到中间
    CGSize scrollSize = _scrollRect.size;
    
    // 自动播放动画效果
    [_scrollView setContentOffset:CGPointMake(scrollSize.width, 0) animated:YES];
    
    // 设置分页
    _pageControl.currentPage = _currentImageIndex;
}

#pragma mark 重新加载图片
-(void)reloadImage{
    
    NSString* strImageName = [_imageData objectForKey:[NSString stringWithFormat:@"%i", _currentImageIndex]];
    
    _centerImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@//%@", _resourcePath, strImageName]];
    
    // 重新设置左右图片
    int leftImageIndex = (_currentImageIndex + _imageCount - 1)%_imageCount;
    int rightImageIndex = (_currentImageIndex + 1)%_imageCount;
    strImageName = [_imageData objectForKey:[NSString stringWithFormat:@"%i", leftImageIndex]];
    _leftImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@//%@", _resourcePath, strImageName]];
    
    strImageName = [_imageData objectForKey:[NSString stringWithFormat:@"%i", rightImageIndex]];
    _rightImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@//%@", _resourcePath, strImageName]];
    
    // 自动播放动画关键步骤
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

@end
