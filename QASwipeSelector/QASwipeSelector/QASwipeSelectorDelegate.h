//
//  QASwipeSelectorDelegate.h
//  KMAssistant
//
//  Created by Quentin Arnault on 25/02/2014.
//  Copyright (c) 2014 Quentin Arnault. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QASwipeSelectorDelegate <NSObject>

@optional
- (void)swipeSelector:(QASwipeSelector *)swipeSelector currentItemIndexDidChange:(NSIndexPath *)indexPath;

@end
