//
//  QASwipeSelectorDataSource.h
//  KMAssistant
//
//  Created by Quentin Arnault on 25/02/2014.
//  Copyright (c) 2014 Quentin Arnault. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QASwipeSelector;

@protocol QASwipeSelectorDataSource <NSObject>

@required
- (NSUInteger)numberOfItemsInSwipeSelector:(QASwipeSelector *)swipeSelector;
- (NSString *)swipeSelector:(QASwipeSelector *)swipeSelector titleAtIndexPath:(NSIndexPath *)indexPath;

@end