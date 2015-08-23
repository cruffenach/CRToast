//
//  CRToast
//  Copyright (c) 2014-2015 Collin Ruffenach. All rights reserved.
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
// vertically under the status bar. This adjustment is used to correct the frame height when centering
// content under the status bar.

static CGFloat const CRStatusBarViewUnderStatusBarYOffsetAdjustment = -5;

static CGFloat CRImageViewFrameXOffsetForAlignment(CRToastAccessoryViewAlignment alignment, CGFloat preferredPadding, CGSize contentSize) {
    CGFloat imageSize = contentSize.height;
    CGFloat xOffset = 0;

    if (alignment == CRToastAccessoryViewAlignmentLeft) {
        xOffset = preferredPadding;
    } else if (alignment == CRToastAccessoryViewAlignmentCenter) {
        // Calculate mid point of contentSize, then offset for x for full image width
        // that way center of image will be center of content view
        xOffset = (contentSize.width / 2) - (imageSize / 2);
    } else if (alignment == CRToastAccessoryViewAlignmentRight) {
        xOffset = contentSize.width - preferredPadding - imageSize;
    }
    
    return xOffset;
}

static CGFloat CRContentXOffsetForViewAlignmentAndWidth(CRToastAccessoryViewAlignment imageAlignment, CGFloat imageXOffset, CGFloat imageWidth, CGFloat preferredPadding) {
    return ((imageWidth == 0 || imageAlignment != CRToastAccessoryViewAlignmentLeft) ?
    kCRStatusBarViewNoImageLeftContentInset + preferredPadding :
    imageXOffset + imageWidth);
}

static CGFloat CRToastWidthOfViewWithAlignment(CGFloat height, BOOL showing, CRToastAccessoryViewAlignment alignment, CGFloat preferredPadding) {
    return (!showing || alignment == CRToastAccessoryViewAlignmentCenter) ?
    0 :
    preferredPadding + height + preferredPadding;
}

CGFloat CRContentWidthForAccessoryViewsWithAlignments(CGFloat fullContentWidth,
                                                      CGFloat fullContentHeight,
                                                      CGFloat preferredPadding,
                                                      BOOL showingImage,
                                                      CRToastAccessoryViewAlignment imageAlignment,
                                                      BOOL showingActivityIndicator,
                                                      CRToastAccessoryViewAlignment activityIndicatorAlignment)
{
    CGFloat width = fullContentWidth;
    
    if (imageAlignment == activityIndicatorAlignment && showingActivityIndicator && showingImage) {
        return fullContentWidth;
    }
    
    width -= CRToastWidthOfViewWithAlignment(fullContentHeight, showingImage, imageAlignment, preferredPadding);
    width -= CRToastWidthOfViewWithAlignment(fullContentHeight, showingActivityIndicator, activityIndicatorAlignment, preferredPadding);
        
    if (!showingImage && !showingActivityIndicator) {
        width -= (kCRStatusBarViewNoImageLeftContentInset + kCRStatusBarViewNoImageRightContentInset);
        width -= (preferredPadding + preferredPadding);
    }
    
    return width;
}

static CGFloat CRCenterXForActivityIndicatorWithAlignment(CRToastAccessoryViewAlignment alignment, CGFloat viewWidth, CGFloat contentWidth, CGFloat preferredPadding) {
    CGFloat center = 0;
    CGFloat offset = viewWidth / 2 + preferredPadding;
    
    switch (alignment) {
        case CRToastAccessoryViewAlignmentLeft:
            center = offset; break;
        case CRToastAccessoryViewAlignmentCenter:
            center = (contentWidth / 2); break;
        case CRToastAccessoryViewAlignmentRight:
            center = contentWidth - offset; break;
    }
    
    return center;
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
    CGFloat preferredPadding = self.toast.preferredPadding;
    
    CGFloat statusBarYOffset = self.toast.displayUnderStatusBar ? (CRGetStatusBarHeight()+CRStatusBarViewUnderStatusBarYOffsetAdjustment) : 0;
    contentFrame.size.height = CGRectGetHeight(contentFrame) - statusBarYOffset;
    
    self.backgroundView.frame = self.bounds;
    
    CGFloat imageXOffset = CRImageViewFrameXOffsetForAlignment(self.toast.imageAlignment, preferredPadding, contentFrame.size);
    self.imageView.frame = CGRectMake(imageXOffset,
                                      statusBarYOffset,
                                      imageSize.width == 0 ?
                                      0 :
                                      CGRectGetHeight(contentFrame),
                                      imageSize.height == 0 ?
                                      0 :
                                      CGRectGetHeight(contentFrame));
    
    CGFloat imageWidth = imageSize.width == 0 ? 0 : CGRectGetMaxX(_imageView.frame);
    CGFloat x = CRContentXOffsetForViewAlignmentAndWidth(self.toast.imageAlignment, imageXOffset, imageWidth, preferredPadding);
    
    if (self.toast.showActivityIndicator) {
        CGFloat centerX = CRCenterXForActivityIndicatorWithAlignment(self.toast.activityViewAlignment, CGRectGetHeight(contentFrame), CGRectGetWidth(contentFrame), preferredPadding);
        self.activityIndicator.center = CGPointMake(centerX,
                                     CGRectGetMidY(contentFrame) + statusBarYOffset);
        
        [self.activityIndicator startAnimating];
        x = MAX(CRContentXOffsetForViewAlignmentAndWidth(self.toast.activityViewAlignment, imageXOffset, CGRectGetHeight(contentFrame), preferredPadding), x);

        [self bringSubviewToFront:self.activityIndicator];
    }
    
    BOOL showingImage = imageSize.width > 0;
    
    CGFloat width = CRContentWidthForAccessoryViewsWithAlignments(CGRectGetWidth(contentFrame),
                                                                  CGRectGetHeight(contentFrame),
                                                                  preferredPadding,
                                                                  showingImage,
                                                                  self.toast.imageAlignment,
                                                                  self.toast.showActivityIndicator,
                                                                  self.toast.activityViewAlignment);
    
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
    
    // Account for center alignment of text and an accessory view
    if ((showingImage || self.toast.showActivityIndicator)
        && (self.toast.activityViewAlignment == CRToastAccessoryViewAlignmentCenter
            || self.toast.imageAlignment == CRToastAccessoryViewAlignmentCenter)
        && self.toast.textAlignment == NSTextAlignmentCenter
        ) {
        CGFloat labelHeight = CGRectGetHeight(self.label.frame); // Store labelHeight for resetting after calling sizeToFit
        [self.label sizeToFit]; // By default our size is rather large so lets fix that for further calculations
        
        CGFloat subTitleLabelHeight = CGRectGetHeight(self.label.frame); // Store labelHeight for resetting after calling sizeToFit
        [self.subtitleLabel sizeToFit]; // Again, default size is too large so we need to shrink it down
        
        // Center the label in the view since we're center aligned text
        self.label.center = (CGPoint) {
            .x = CGRectGetMidX(self.frame),
            .y = self.label.center.y
        };
        // After calling sizeToFit we need to reset our frames so they look correct
        self.label.frame = CGRectMake(CGRectGetMinX(self.label.frame),
                                      CGRectGetMinY(self.label.frame),
                                      CGRectGetWidth(self.label.frame),
                                      labelHeight);
        
        // Same thing as for Label
        self.subtitleLabel.center = (CGPoint) {
            .x = CGRectGetMidX(self.frame),
            .y = self.subtitleLabel.center.y
        };
        self.subtitleLabel.frame = CGRectMake(CGRectGetMinX(self.subtitleLabel.frame),
                                              CGRectGetMinY(self.subtitleLabel.frame),
                                              CGRectGetWidth(self.subtitleLabel.frame),
                                              subTitleLabelHeight);
        
        // Get the smallest X value so our image/activity indicator doesn't cover any thing
        CGFloat smallestXView = MIN(CGRectGetMinX(self.label.frame), CGRectGetMinX(self.subtitleLabel.frame));
        
        // If both our labels have 0 width (empty text) don't change the centers of our
        // image or activity indicator and just move along
        if (CGRectGetWidth(self.label.frame) == 0.0
            && CGRectGetWidth(self.subtitleLabel.frame) == 0.0) {
            return;
        }
        // Move our image if that is what we're showing
        if (showingImage && self.toast.imageAlignment == CRToastAccessoryViewAlignmentCenter) {
            self.imageView.frame = (CGRect) {
                .origin.x = smallestXView - CGRectGetWidth(self.imageView.frame) - preferredPadding,
                .origin.y = self.imageView.frame.origin.y,
                .size = self.imageView.frame.size,
            };
        }
        // Move our activity indicator over.
        if ((self.toast.showActivityIndicator && self.toast.activityViewAlignment == CRToastAccessoryViewAlignmentCenter)) {
            self.activityIndicator.frame = (CGRect) {
                .origin.x = smallestXView - CGRectGetWidth(self.activityIndicator.frame) - preferredPadding,
                .origin.y = self.activityIndicator.frame.origin.y,
                .size = self.activityIndicator.frame.size,
            };
        }
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
    if (toast.imageTint) {
        _imageView.image = [toast.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _imageView.tintColor = toast.imageTint;
    } else {
        _imageView.image = toast.image;
    }
    _imageView.contentMode = toast.imageContentMode;
    _activityIndicator.activityIndicatorViewStyle = toast.activityIndicatorViewStyle;
    self.backgroundColor = toast.backgroundColor;
    
    if (toast.backgroundView) {
        _backgroundView = toast.backgroundView;
        if (!_backgroundView.superview) {
            [self insertSubview:_backgroundView atIndex:0];
        }
    }
}

@end
