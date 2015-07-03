//
//  PDFView.m
//  SwiftPDF
//
//  Created by liming on 15/6/9.
//  Copyright (c) 2015年 杜蒙. All rights reserved.
//

#import "PDFView.h"
#import <QuartzCore/QuartzCore.h>

@interface PDFView()<UIGestureRecognizerDelegate>

@end

@implementation PDFView
{
    CGFloat lastScale;
}

- (id)initWithFrame:(CGRect)frame atPage:(NSUInteger)index{
    
    if ((self = [super initWithFrame:frame]))
    {
        // Initialization code
        if(self != nil)
        {
            CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("Swift.pdf"), NULL, NULL);
            pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
            CFRelease(pdfURL);
        }
        
        self.pageNumber = index +1;
        
        self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        
//        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaGesture:)];
//        [pinchRecognizer setDelegate:self];
//        [self addGestureRecognizer:pinchRecognizer];
        
    }
    return self;
}

//- (void)scaGesture:(id)sender
//{
//    [self bringSubviewToFront:[(UIPinchGestureRecognizer *)sender view]];
//    
//    //当手指离开屏幕时,将lastscale设置为1.0
//    
//    if([(UIPinchGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
//        lastScale = 1.0;
//        return;
//    }
//    
//    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer *)sender scale]);
//    
//    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
//    
//    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
//    
//    [[(UIPinchGestureRecognizer*)sender view]setTransform:newTransform];
//    
//    lastScale = [(UIPinchGestureRecognizer*)sender scale];
//  
//}
//
//#pragma mark - 
//#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
//}

-(void)drawInContext:(CGContextRef)context
{
    
    // PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
    // before we start drawing.
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Grab the first PDF page
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, self.pageNumber);
    // We’re about to modify the context CTM to draw the PDF page where we want it, so save the graphics state in case we want to do more drawing
    CGContextSaveGState(context);
    // CGPDFPageGetDrawingTransform provides an easy way to get the transform for a PDF page. It will scale down to fit, including any
    // base rotations necessary to display the PDF page correctly.
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    // And apply the transform.
    CGContextConcatCTM(context, pdfTransform);
    // Finally, we draw the page and restore the graphics state for further manipulations!
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
}






@end
