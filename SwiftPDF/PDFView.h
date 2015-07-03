//
//  PDFView.h
//  SwiftPDF
//
//  Created by liming on 15/6/9.
//  Copyright (c) 2015年 杜蒙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFView : UIView
{
    CGPDFDocumentRef pdf;
}


-(void)drawInContext:(CGContextRef)context;

/**
 *  页数
 */
@property (nonatomic,assign)NSUInteger pageNumber;

- (id)initWithFrame:(CGRect)frame atPage:(NSUInteger)index;

@end
