//
//  QASwipeSelector.h
//  KMAssistant
//
//  Created by Quentin Arnault on 25/02/2014.
//  Copyright (c) 2014 Quentin Arnault. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QASwipeSelectorDataSource;
@protocol QASwipeSelectorDelegate;

@interface QASwipeSelector : UIView

@property (nonatomic, weak) IBOutlet id<QASwipeSelectorDataSource>dataSource;
@property (nonatomic, weak) IBOutlet id<QASwipeSelectorDelegate>delegate;

- (void)reloadData;

@end
