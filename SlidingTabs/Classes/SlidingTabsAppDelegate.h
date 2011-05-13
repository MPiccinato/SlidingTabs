//
//  SlidingTabsAppDelegate.h
//  SlidingTabs
//
//  Created by Mathew Piccinato on 5/12/11.
//  Copyright 2011 PHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlidingTabsViewController;

@interface SlidingTabsAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SlidingTabsViewController *viewController;

@end
