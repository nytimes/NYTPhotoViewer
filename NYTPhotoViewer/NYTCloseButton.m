//
//  NYTCloseButton.m
//  NYTPhotoViewer
//
//  Created by Daniel Rhodes on 8/30/16.
//  Copyright © 2016 NYTimes. All rights reserved.
//

#import "NYTCloseButton.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation NYTCloseButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  
  [super drawRect: rect];
  
  CGRect insetRect = CGRectInset(rect, 2.0, 2.0);
  
  CGPoint lineOneStartPoint = CGPointMake(insetRect.origin.x, insetRect.origin.y);
  CGPoint lineOneEndPointPoint = CGPointMake(CGRectGetMaxX(insetRect), CGRectGetMaxY(insetRect));
  CGPoint lineTwoStartPoint = CGPointMake(CGRectGetMaxX(insetRect), CGRectGetMinY(insetRect));
  CGPoint lineTwoEndPoint = CGPointMake(CGRectGetMinX(insetRect), CGRectGetMaxY(insetRect));
  
  [self drawLineFromStartPoint: lineOneStartPoint toEndPoint: lineOneEndPointPoint withColor: self.tintColor.CGColor andLineWidth: 2.0 andLineCap: kCGLineCapSquare];
  
  [self drawLineFromStartPoint: lineTwoStartPoint toEndPoint: lineTwoEndPoint withColor: self.tintColor.CGColor andLineWidth: 2.0 andLineCap: kCGLineCapSquare];
}

- (void) drawLineFromStartPoint: (CGPoint) startPoint toEndPoint: (CGPoint) endPoint withColor: (CGColorRef) color andLineWidth: (CGFloat) lineWidth andLineCap: (CGLineCap) lineCap {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextSetLineCap(context, lineCap);
  CGContextSetStrokeColorWithColor(context, color);
  CGContextSetLineWidth(context, lineWidth);
  CGContextMoveToPoint(context, startPoint.x, startPoint.y);
  CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded: touches withEvent: event];
  self.alpha = 1.0;
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled: touches withEvent: event];
  self.alpha = 1.0;
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesMoved: touches withEvent: event];
  
  for (UITouch *touch in touches) {
    CGPoint touchPoint = [touch locationInView: self];
    CGRect touchRect = CGRectMake(0.0, 0.0, self.bounds.size.width + 50.0, self.bounds.size.height + 50.0);
    if (!CGRectContainsPoint(touchRect, touchPoint)) {
      self.alpha = 1.0;
    } else {
      self.alpha = 0.3;
    }
  }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesBegan: touches withEvent: event];
  self.alpha = 0.3;
}

@end
