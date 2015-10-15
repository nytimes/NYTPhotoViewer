//
//  NYTOperatingSystemCompatibilityUtilityTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <OCMock/OCMock.h>
#import <NYTPhotoViewer/NYTOperatingSystemCompatibilityUtility.h>
#import "NYTTestiOS7TransitionContext.h"
#import "NYTTestiOS8TransitionContext.h"

@interface NYTOperatingSystemCompatibilityUtilityTests : XCTestCase

@end

@implementation NYTOperatingSystemCompatibilityUtilityTests

- (void)testiOS8ToViewMethodCalledOniOS8 {
    id transitionContext = OCMPartialMock([[NYTTestiOS8TransitionContext alloc] init]);
    OCMExpect([transitionContext viewForKey:UITransitionContextToViewKey]);
    [NYTOperatingSystemCompatibilityUtility toViewForTransitionContext:transitionContext];
    
    XCTAssertNoThrow(OCMVerify([transitionContext viewForKey:UITransitionContextToViewKey]));
}

- (void)testiOS8FromViewMethodCalledOniOS8 {
    id transitionContext = OCMPartialMock([[NYTTestiOS8TransitionContext alloc] init]);
    OCMExpect([transitionContext viewForKey:UITransitionContextFromViewKey]);
    [NYTOperatingSystemCompatibilityUtility fromViewForTransitionContext:transitionContext];
    
    XCTAssertNoThrow(OCMVerify([transitionContext viewForKey:UITransitionContextFromViewKey]));
}

- (void)testiOS7ToViewControllerMethodCalledOniOS7 {
    id transitionContext = OCMPartialMock([[NYTTestiOS7TransitionContext alloc] init]);
    OCMExpect([transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]);
    [NYTOperatingSystemCompatibilityUtility toViewForTransitionContext:transitionContext];
    
    XCTAssertNoThrow(OCMVerify([transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]));
}

- (void)testiOS7FromViewControllerMethodCalledOniOS7 {
    id transitionContext = OCMPartialMock([[NYTTestiOS7TransitionContext alloc] init]);
    OCMExpect([transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]);
    [NYTOperatingSystemCompatibilityUtility fromViewForTransitionContext:transitionContext];
    
    XCTAssertNoThrow(OCMVerify([transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]));
}

- (void)testiOS7FinalFrameContainerViewMethodCalledOniOS7 {
    id partialMock = OCMPartialMock([UIDevice currentDevice]);
    OCMStub((NSString *)[(UIDevice *)partialMock systemVersion]).andCall(self, @selector(iOS7String));
    
    id transitionContext = OCMProtocolMock(@protocol(UIViewControllerContextTransitioning));
    OCMExpect([transitionContext containerView]);
    [NYTOperatingSystemCompatibilityUtility finalFrameForToViewControllerWithTransitionContext:transitionContext];
    
    XCTAssertNoThrow(OCMVerify([transitionContext containerView]));
}

- (void)testiOS7FinalFrameForViewControllerViewMethodCalledOniOS8 {
    id partialMock = OCMPartialMock([UIDevice currentDevice]);
    OCMStub((NSString *)[(UIDevice *)partialMock systemVersion]).andCall(self, @selector(iOS8String));
    
    id transitionContext = OCMProtocolMock(@protocol(UIViewControllerContextTransitioning));
    OCMExpect([transitionContext finalFrameForViewController:OCMOCK_ANY]);
    [NYTOperatingSystemCompatibilityUtility finalFrameForToViewControllerWithTransitionContext:transitionContext];
    
    XCTAssertNoThrow(OCMVerify([transitionContext finalFrameForViewController:OCMOCK_ANY]));
}

#pragma mark - Helpers

- (NSString *)iOS7String {
    return @"7.0.0";
}

- (NSString *)iOS8String {
    return @"8.0.0";
}

@end
