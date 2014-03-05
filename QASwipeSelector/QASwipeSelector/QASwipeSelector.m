//
//  QASwipeSelector.m
//  KMAssistant
//
//  Created by Quentin Arnault on 25/02/2014.
//  Copyright (c) 2014 Quentin Arnault. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
//  persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.//

#import "QASwipeSelector.h"
#import "QASwipeSelectorDataSource.h"
#import "QASwipeSelectorDelegate.h"

static NSString *const kDataSourceKeyPath = @"dataSource";

static NSUInteger const kPageControlHeight = 8.f;

static NSTimeInterval const kSwipeAnimationDuration = .1f;

@interface QASwipeSelector ()

@property (assign) NSInteger currentIndex;
@property (assign) NSInteger displayedIndex;
@property (nonatomic, strong) UILabel *currentLabel;

@end

#warning TODO should handle a maximum number of dots in page control

@implementation QASwipeSelector

@synthesize pageControl = _pageControl;

#pragma mark -
- (void)reloadData {
    self.pageControl.numberOfPages = [self.dataSource numberOfItemsInSwipeSelector:self];
    
    if (self.displayedIndex != self.currentIndex ) {
        
        CGPoint disappearAnimationCenter;
        CGPoint prepareAnimationCenter;
        CGPoint appearAnimationCenter = self.currentLabel.center;
        
        if (self.currentIndex > self.displayedIndex) {
            disappearAnimationCenter = CGPointMake(-self.currentLabel.center.x
                                                   , self.currentLabel.center.y);
            prepareAnimationCenter = CGPointMake(self.frame.size.width + (self.currentLabel.frame.size.width / 2.f)
                                                 , self.currentLabel.center.y);
        } else {
            disappearAnimationCenter = CGPointMake(self.frame.size.width + (self.currentLabel.frame.size.width / 2.f)
                                                   , self.currentLabel.center.y);
            prepareAnimationCenter = CGPointMake(-self.currentLabel.center.x
                                                 , self.currentLabel.center.y);
        }
        
        
        if (self.currentIndex >= self.pageControl.numberOfPages) {
            self.currentIndex = 0;
        } else if (self.currentIndex < 0) {
            self.currentIndex = self.pageControl.numberOfPages - 1;
        }

        [UIView animateWithDuration:kSwipeAnimationDuration animations:^{
            self.currentLabel.center = disappearAnimationCenter;
        } completion:^(BOOL finished) {
            if (self.currentIndex < self.pageControl.numberOfPages) {
                NSString *currentItemTitle = [self.dataSource swipeSelector:self
                                                           titleAtIndexPath:[NSIndexPath indexPathWithIndex:self.currentIndex]];
                
                self.currentLabel.text = currentItemTitle;
            }
            self.currentLabel.center = prepareAnimationCenter;
            [UIView animateWithDuration:kSwipeAnimationDuration animations:^{
                self.currentLabel.center = appearAnimationCenter;
            } completion:^(BOOL finished) {
                self.displayedIndex = self.currentIndex;
                self.pageControl.currentPage = self.currentIndex;
                
                if ([self.delegate respondsToSelector:@selector(swipeSelector:currentItemIndexDidChange:)]) {
                    [self.delegate swipeSelector:self
                       currentItemIndexDidChange:[NSIndexPath indexPathWithIndex:self.displayedIndex]];
                }
            }];
            
        }];
    } else {
        NSString *currentItemTitle = [self.dataSource swipeSelector:self
                                                   titleAtIndexPath:[NSIndexPath indexPathWithIndex:self.currentIndex]];
        
        self.currentLabel.text = currentItemTitle;
    }
    
}

#pragma mark -

#pragma mark UIView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    if ((!self.window)
        && (newWindow)) {
        [self addObserver:self
               forKeyPath:kDataSourceKeyPath
                  options:NSKeyValueObservingOptionInitial
                  context:nil];
    } else if ((self.window)
               && (!newWindow)) {
        [self removeObserver:self
                  forKeyPath:kDataSourceKeyPath];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.currentLabel.frame = CGRectMake(0.f
                                         , 0.f
                                         , self.frame.size.width
                                         , self.frame.size.height);
    self.pageControl.frame = CGRectMake(0.f
                                        , self.frame.size.height - kPageControlHeight
                                        , self.frame.size.width
                                        , kPageControlHeight);
}

#pragma mark NSObject
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    return self;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self reloadData];
}

#pragma mark -
#pragma mark private
- (void)commonInit {
    self.clipsToBounds = YES;
    
    self.currentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.currentLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.currentLabel];
    
    [self addSubview:self.pageControl];
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeForNextItem:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipeGestureRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeForPreviousItem:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipeGestureRecognizer];
}

#pragma mark action
- (IBAction)didSwipeForNextItem:(id)sender {
    ++self.currentIndex;
    
    [self reloadData];
}

- (IBAction)didSwipeForPreviousItem:(id)sender {
    --self.currentIndex;
    
    [self reloadData];
}

#pragma mark properties
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    }
    
    return _pageControl;
}

@end
