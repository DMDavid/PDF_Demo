//
//  ViewController.m
//  SwiftPDF
//
//  Created by liming on 15/6/9.
//  Copyright (c) 2015年 杜蒙. All rights reserved.
//

/**
 *  保存用户初始化加载最大的页数
 */
#define loadMaxPage 50


#import <Foundation/Foundation.h>
#import "ViewController.h"

#import "MoreViewController.h"
#import "PDFView.h"

@interface ViewController ()<UIPageViewControllerDataSource>

@property (nonatomic,strong)UIPageViewController *pageController;

@property (nonatomic,strong)NSMutableArray *pageContent;

/**
 *  加载的次数
 */
@property (nonatomic,assign)NSUInteger loadTimes;

/**
 *  保存当前的页数
 */
@property (nonatomic,assign)NSUInteger nowPageNumber;


@end

@implementation ViewController


-  (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    [self setPageView];
    
}

- (void)setPageView
{
    [self createContentPages];// 初始化所有数据
    
    // 设置UIPageViewController的配置项
    
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    
    // 实例化UIPageViewController对象，根据给定的属性
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal   options: options];
    
    // 设置UIPageViewController对象的代理
    
    _pageController.dataSource = self;
    
    // 定义“这本书”的尺寸
    
    [[_pageController view] setFrame:[[self view] bounds]];
    
    // 让UIPageViewController对象，显示相应的页数据。
    
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    
    MoreViewController *initialViewController =[self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    
    [_pageController setViewControllers:viewControllers
                               direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                               completion:nil];
    
    // 在页面上，显示UIPageViewController对象的View
    
    [self addChildViewController:_pageController];
    
    [[self view] addSubview:[_pageController view]];
}

// 初始化所有数据

- (void) createContentPages {
    
    self.loadTimes = 1;
    
   self.pageContent = [NSMutableArray array];
    for (int i = 0; i<loadMaxPage; i++) {
        PDFView *paf =[[PDFView alloc]initWithFrame:self.view.frame atPage:i];
        
        [self.pageContent addObject:paf];
    }
}

//CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("Swift.pdf"), NULL, NULL);
//CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
//CFRelease(pdfURL);
//
//CGContextRef context = UIGraphicsGetCurrentContext();
//CGContextTranslateCTM(context, 0.0, self.view.frame.size.height);
//CGContextScaleCTM(context, 1.0, -1.0);
//
//CGPDFPageRef page = CGPDFDocumentGetPage(pdf, i);
//CGContextSaveGState(context);
//
//CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.view.bounds, 0, true);
//
//CGContextConcatCTM(context, pdfTransform);
//fasdfdsaf
//CGContextDrawPDFPage(context, page);
//CGContextRestoreGState(context);


                           

// 得到相应的VC对象

 - (MoreViewController *)viewControllerAtIndex:(NSUInteger)index {
                                       
   if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
       
       return nil;
       
   }
   
   // 创建一个新的控制器类，并且分配给相应的数据
   
   MoreViewController *dataViewController =[[MoreViewController alloc] init];
   
     dataViewController.pdfView = [self.pageContent objectAtIndex:index];
     
     [dataViewController.view addSubview:dataViewController.pdfView];
   return dataViewController;
   
}


// 根据数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(MoreViewController *)viewController {
   
    
   return [self.pageContent indexOfObject:viewController.pdfView];
   
}


#pragma mark- UIPageViewControllerDataSource


// 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
   
   NSUInteger index = [self indexOfViewController:(MoreViewController *)viewController];
   
   if ((index == 0) || (index == NSNotFound)) {
       
       return nil;
       
   }
   
   index--;
   
   // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
   
   // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
   
   // 不用我们去操心每个ViewController的顺序问题。
   
   return [self viewControllerAtIndex:index];
   
   
   
}


// 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
   
    
   
   NSUInteger index = [self indexOfViewController:(MoreViewController *)viewController];
   
   if (index == NSNotFound) {
       
       return nil;
       
   }
    
    
   index++;
    
    /**
     *  如果原来加载的数据加载完毕了，就加载更多数据
     */
    if (index == loadMaxPage * self.loadTimes) {
       
         [self loadMoreData];
    }

    
   if (index == [self.pageContent count]) {
       
       return nil;
       
   }
   
   return [self viewControllerAtIndex:index];
   
   
}



/**
 *  加载更多数据
 */
- (void)loadMoreData
{
    /**
     *  loadMaxPage
     *
     *  保存用户初始化加载最大的页数
     */
    int nowPage = loadMaxPage * self.loadTimes ;
    int loadPage = loadMaxPage+1;
    for (int i = 0; i<loadPage; i++) {
        PDFView *paf =[[PDFView alloc]initWithFrame:self.view.frame atPage:nowPage + i];
        [self.pageContent addObject:paf];
    }
    
    (self.loadTimes ++);
    
}

@end
