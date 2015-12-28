//
//  ViewController.m
//  图片轮播再学习
//
//  Created by 123 on 15/12/14.
//  Copyright © 2015年 GJY. All rights reserved.
//
//UIScrollView是一个能够滚动的视图控件,可以用来展⽰示大量的内容,并且可以通过滚动查看所有的内容

//（1）将需要展⽰的内容添加到UIScrollView中
//（2）设置UIScrollView的contentSize属性,告诉UIScrollView所有内容的尺寸,也就是告诉 它滚动的范围(能滚多远,滚到哪⾥是尽头)
#define  imageCount 5
#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //1.添加5张图片到scrollView中
    //设置图片frame,尺寸与scrollView一样高
    CGFloat imageW=self.scrollView.frame.size.width;
    CGFloat imageH=self.scrollView.frame.size.height;
    //图片的具体位置需要动态计算
    CGFloat imageY=0;
    for (int i=0; i<imageCount; i++)
    {
        UIImageView *imageView=[[UIImageView alloc]init];
        CGFloat imageX=i*imageW;
        imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
        
        //设置图片
        NSString *name=[NSString stringWithFormat:@"img_0%d",i+1];
        imageView.image=[UIImage imageNamed:name];
        
        [self.scrollView addSubview:imageView];
    }
    
    //2.设置滚动内容的尺寸
    CGFloat contentW=5*imageW;
    self.scrollView.contentSize=CGSizeMake(contentW, 0);
    
    //3.隐藏水平的滚动条
    self.scrollView.showsHorizontalScrollIndicator=NO;
    
    //4.分页
    self.pageControl.enabled=YES;
    
    //5.设置代理
    self.scrollView.delegate=self;
    
    //6.设置pageControl的总页数
    self.pageControl.numberOfPages=imageCount;
    
    //7.添加定时器
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)nextImage
{
    int page=0;
    if(self.pageControl.currentPage==imageCount-1)
    {
        //如果滚动到最后一页了，那下一页就是第一页
        page=0;
    }
    else
    {
        //否则就是下一页
        page=(int)self.pageControl.currentPage+1;
    }
    
    //2.计算scrollView滚动的位置
    CGFloat offsetX=page*self.scrollView.frame.size.width;
    CGPoint offset=CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

//开始拖拽的时候调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止定时器
    [self.timer invalidate];
    self.timer=nil;
}

//停止拖拽的时候调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //再次开启定时器
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
//当scrollView正在滚动就会调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //根据scrollView的滚动位置决定pageControl显示第几页
    int page=(scrollView.contentOffset.x+self.scrollView.frame.size.width*0.5)/scrollView.frame.size.width;
    self.pageControl.currentPage=page;
}
@end
