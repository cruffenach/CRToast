//
//  CRToastWindow.m
//  CRToastDemo
//
//  Created by Daniel on 12/19/14.
//  Copyright (c) 2014 Collin Ruffenach. All rights reserved.
//

#import "CRToastWindow.h"

@implementation CRToastWindow

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil) {
            return YES;
        }
    }
    return NO;
}

@end
