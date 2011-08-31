//
//  SlidingTabsControl.m
//  SlidingTabs
//
//  Created by Mathew Piccinato on 5/12/11.
//  Copyright 2011 Constructt. All rights reserved.
//

#import "SlidingTabsControl.h"
#import <QuartzCore/QuartzCore.h>

@implementation SlidingTabsControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (id) initWithTabCount:(NSUInteger)tabCount
                   delegate:(NSObject <SlidingTabsControlDelegate>*)slidingTabsControlDelegate 
{
    if ((self = [super init]))
    {
        // Set the delegate
        _delegate = slidingTabsControlDelegate;
        
        // Set our frame
        self.frame = CGRectMake(0, 0, 320, 40);
        self.backgroundColor = [UIColor darkGrayColor];
        
        // Initalize the array we use to store our buttons
        _buttons = [[NSMutableArray alloc] initWithCapacity:tabCount];
        
        // horizontalOffset tracks the proper x value as we add buttons as subviews
        CGFloat horizontalOffset = 0;
        CGFloat buttonWidth = (320.0 / tabCount);
        CGFloat buttonHeight = 40;
        
        // Draw our tab!
        _tab = [[SlidingTabsTab alloc] initWithFrame:CGRectMake(-5, 0, buttonWidth+10.0, buttonHeight)];
        [self addSubview:_tab];
        
        // Iterate through each segment
        for (NSUInteger i = 0 ; i < tabCount ; i++)
        {
            // Get the label for the segment
            UILabel *label = [_delegate labelFor:self atIndex:i];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
            label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
            label.shadowOffset = CGSizeMake(0, -1.0);
            label.textColor = [UIColor whiteColor];
            label.textAlignment = UITextAlignmentCenter;
            label.frame = CGRectMake((int)horizontalOffset, 0, buttonWidth, buttonHeight);
            [self addSubview:label];
            
            // Create a button
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(horizontalOffset, 0.0, buttonWidth, buttonHeight)];
            
            // Register for touch events
            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
            
            // Add the button to our buttons array
            [_buttons addObject:button];
            
            // Set the button's x offset
            button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);
            
            // Add the button as our subview
            [self addSubview:button];
            
            // Add the divider unless we are at the last segment
            if (i != tabCount - 1)
            {
                //UIImageView* divider = [[[UIImageView alloc] initWithImage:dividerImage] autorelease];
                //divider.frame = CGRectMake(horizontalOffset + segmentsize.width, 0.0, dividerImage.size.width, dividerImage.size.height);
                //[self addSubview:divider];
            }
            
            // Advance the horizontal offset
            horizontalOffset = horizontalOffset + buttonWidth;
            
           
        }
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Set background gradient
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 80.0/255.0f, 80.0/255.0f, 80.0/255.0f, 1.0,  // Start color
                              40.0/255.0f, 40.0/255.0f, 40.0/255.0f, 1.0 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    // Draw Button dividers
    for (int i = 0; i < [_buttons count]; i++) {
        CGFloat buttonWidth = (320.0 / [_buttons count]);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);;
        CGContextSetShadow(context, CGSizeMake (0, 0), 0.0);
        
        CGContextSaveGState(context);
        
        CGContextMoveToPoint(context, buttonWidth * i, 0);
        CGContextAddLineToPoint(context, buttonWidth * i, 40.0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextRestoreGState(context);
    }
    
    // Add a shadow to top
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0].CGColor);
    CGContextSetShadow(context, CGSizeMake (0, 0), 5.0);
    
    CGContextSaveGState(context);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
}

- (void)touchDownAction:(UIButton*)button
{
    if ([_delegate respondsToSelector:@selector(touchDownAtTabIndex:)])
        [_delegate touchDownAtTabIndex:[_buttons indexOfObject:button]];
}

- (void)touchUpInsideAction:(UIButton*)button
{
    // Determine where tab should go
    CGFloat segmentCount = [_buttons count];
    CGFloat buttonWidth = (320.0 / segmentCount);
    CGFloat buttonIndex = [_buttons indexOfObject:button];
    CGFloat newPosition = (buttonWidth * buttonIndex) - 5.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [_tab setFrame:CGRectMake(newPosition, 0, _tab.frame.size.width, _tab.frame.size.height)];
    [UIView commitAnimations];
    
    if ([_delegate respondsToSelector:@selector(touchUpInsideTabIndex:)])
        [_delegate touchUpInsideTabIndex:[_buttons indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button
{

}

- (void)dealloc
{
    [super dealloc];
    [_buttons release];
}

@end
