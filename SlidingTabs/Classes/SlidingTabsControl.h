//
//  SlidingTabsControl.h
//  SlidingTabs
//
//  Created by Mathew Piccinato on 5/12/11.
//  Copyright 2011 Constructt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingTabsTab.h"

@class SlidingTabsControl;
@protocol SlidingTabsControlDelegate;

@interface SlidingTabsControl : UIView {
    SlidingTabsTab* _tab;
    NSMutableArray* _buttons;
    NSObject <SlidingTabsControlDelegate> *_delegate;
}

/**
 * Setup the tabs
 */
- (id) initWithTabCount:(NSUInteger)tabCount
                   delegate:(NSObject <SlidingTabsControlDelegate>*)slidingTabsControlDelegate;


@end

@protocol SlidingTabsControlDelegate

- (UILabel*) labelFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex;

@optional
- (void) touchUpInsideTabIndex:(NSUInteger)tabIndex;
- (void) touchDownAtTabIndex:(NSUInteger)tabIndex;
@end
