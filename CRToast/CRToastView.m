//
//  CRToastView.m
//  CRToastDemo
//
//  Created by Daniel on 12/19/14.
//  Copyright (c) 2014 Collin Ruffenach. All rights reserved.
//

#import "CRToastView.h"
#import "CRToast.h"
#import "CRToastLayoutHelpers.h"

@interface CRToastView ()
@end

static CGFloat const kCRStatusBarViewNoImageLeftContentInset = 10;
static CGFloat const kCRStatusBarViewNoImageRightContentInset = 10;

// UIApplication's statusBarFrame will return a height for the status bar that includes
// a 5 pixel vertical padding. This frame height is inappropriate to use when centering content
// vertically under the status bar. This adjustment is uesd to correct the frame height when centering
// content under the status bar.

static CGFloat const CRStatusBarViewUnderStatusBarYOffsetAdjustment = -5;

static CGFloat CRImageViewFrameXOffsetForAlignment(CRToastImageAlignment alignment, CGSize contentSize) {
    CGFloat imageSize = contentSize.height;
    CGFloat xOffset = 0;

    if (alignment == CRToastImageAlignmentLeft) {
        xOffset = 0;
    } else if (alignment == CRToastImageAlignmentCenter) {
        // Calculate mid point of contentSize, then offset for x for full image width
        // that way center of image will be center of content view
        xOffset = (contentSize.width / 2) - (imageSize / 2);
    } else if (alignment == CRToastImageAlignmentRight) {
        xOffset = contentSize.width - imageSize;
    }
    
    return xOffset;
}

static CGFloat CRContentXOffsetForImageAlignment(CRToastImageAlignment alignment, CGFloat imageSize) {
    return (imageSize == 0 || alignment != CRToastImageAlignmentLeft) ?
        kCRStatusBarViewNoImageLeftContentInset
        : imageSize + kCRStatusBarViewNoImageLeftContentInset;
}

static CGFloat CRContentWidthForImageWithAlignment(CGFloat fullContentWidth, CGFloat fullContentHeight, CRToastImageAlignment alignment, BOOL showingImage, BOOL showingActivityIndicator) {
    CGFloat width = fullContentWidth; // - (fullContentHeight + kCRStatusBarViewNoImageRightContentInset);
    
    CGFloat leftInset  = kCRStatusBarViewNoImageRightContentInset + ((showingActivityIndicator) ? fullContentHeight : 0);
    CGFloat rightInset = kCRStatusBarViewNoImageRightContentInset + ((showingImage) ? fullContentHeight : 0);
    
    switch (alignment) {
        case CRToastImageAlignmentLeft: {
            if (showingActivityIndicator || showingImage) { width -= leftInset; }
        } break;
        case CRToastImageAlignmentCenter: {
            if (showingActivityIndicator) { width -= leftInset; }
            else { width -= (kCRStatusBarViewNoImageLeftContentInset + kCRStatusBarViewNoImageRightContentInset); }
        } break;
        case CRToastImageAlignmentRight: {
            if (showingActivityIndicator) { width -= leftInset; }
            else { width -= kCRStatusBarViewNoImageLeftContentInset; }
            
            if (showingImage) { width -= rightInset; }
            else { width -= kCRStatusBarViewNoImageRightContentInset; }
        } break;
    }
    
    return width;
}

@implementation CRToastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.accessibilityLabel = NSStringFromClass([self class]);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.userInteractionEnabled = NO;
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.userInteractionEnabled = NO;
        [self addSubview:activityIndicator];
        self.activityIndicator = activityIndicator;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.userInteractionEnabled = NO;
        [self addSubview:label];
        self.label = label;
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subtitleLabel.userInteractionEnabled = NO;
        [self addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
        
        self.isAccessibilityElement = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentFrame = self.bounds;
    CGSize imageSize = self.imageView.image.size;
    
    CGFloat statusBarYOffset = self.toast.displayUnderStatusBar ? (CRGetStatusBarHeight()+CRStatusBarViewUnderStatusBarYOffsetAdjustment) : 0;
    contentFrame.size.height = CGRectGetHeight(contentFrame) - statusBarYOffset;
    
    CGFloat imageXOffset = CRImageViewFrameXOffsetForAlignment(self.toast.imageAlignment, contentFrame.size);
    self.imageView.frame = CGRectMake(imageXOffset,
                                      statusBarYOffset,
                                      imageSize.width == 0 ?
                                      0 :
                                      CGRectGetHeight(contentFrame),
                                      imageSize.height == 0 ?
                                      0 :
                                      CGRectGetHeight(contentFrame));
    
    CGFloat imageWidth = imageSize.width == 0 ? kCRStatusBarViewNoImageLeftContentInset : CGRectGetMaxX(_imageView.frame);
    CGFloat x = CRContentXOffsetForImageAlignment(self.toast.imageAlignment, imageWidth);
    
    if (self.toast.showActivityIndicator) {
        self.activityIndicator.center = CGPointMake(CGRectGetHeight(contentFrame) / 2,
                                     CGRectGetMidY(contentFrame) + statusBarYOffset);
        
        [self.activityIndicator startAnimating];
        x = MAX(CGRectGetHeight(contentFrame) + kCRStatusBarViewNoImageLeftContentInset, x);
        [self bringSubviewToFront:self.activityIndicator];
    }
    
    BOOL showingImage = imageSize.width > 0;
    CGFloat width = CRContentWidthForImageWithAlignment(CGRectGetWidth(contentFrame), CGRectGetHeight(contentFrame), self.toast.imageAlignment, showingImage, self.toast.showActivityIndicator);
    
    if (self.toast.subtitleText == nil) {
        self.label.frame = CGRectMake(x,
                                      statusBarYOffset,
                                      width,
                                      CGRectGetHeight(contentFrame));
    } else {
        CGFloat height = MIN([self.toast.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName : self.toast.font}
                                                           context:nil].size.height,
                             CGRectGetHeight(contentFrame));
        CGFloat subtitleHeight = [self.toast.subtitleText boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName : self.toast.subtitleFont }
                                                                       context:nil].size.height;
        if ((CGRectGetHeight(contentFrame) - (height + subtitleHeight)) < 5) {
            subtitleHeight = (CGRectGetHeight(contentFrame) - (height))-10;
        }
        CGFloat offset = (CGRectGetHeight(contentFrame) - (height + subtitleHeight))/2;
        
        self.label.frame = CGRectMake(x,
                                      offset+statusBarYOffset,
                                      CGRectGetWidth(contentFrame)-x-kCRStatusBarViewNoImageRightContentInset,
                                      height);
        
        
        self.subtitleLabel.frame = CGRectMake(x,
                                              height+offset+statusBarYOffset,
                                              CGRectGetWidth(contentFrame)-x-kCRStatusBarViewNoImageRightContentInset,
                                              subtitleHeight);
    }
}

#pragma mark - Overrides

- (void)setToast:(CRToast *)toast {
    _toast = toast;
    _label.text = toast.text;
    _label.font = toast.font;
    _label.textColor = toast.textColor;
    _label.textAlignment = toast.textAlignment;
    _label.numberOfLines = toast.textMaxNumberOfLines;
    _label.shadowOffset = toast.textShadowOffset;
    _label.shadowColor = toast.textShadowColor;
    if (toast.subtitleText != nil) {
        _subtitleLabel.text = toast.subtitleText;
        _subtitleLabel.font = toast.subtitleFont;
        _subtitleLabel.textColor = toast.subtitleTextColor;
        _subtitleLabel.textAlignment = toast.subtitleTextAlignment;
        _subtitleLabel.numberOfLines = toast.subtitleTextMaxNumberOfLines;
        _subtitleLabel.shadowOffset = toast.subtitleTextShadowOffset;
        _subtitleLabel.shadowColor = toast.subtitleTextShadowColor;
    }
    _imageView.image = toast.image;
    _imageView.contentMode = toast.imageContentMode;
    _activityIndicator.activityIndicatorViewStyle = toast.activityIndicatorViewStyle;
    self.backgroundColor = toast.backgroundColor;
}

@end
