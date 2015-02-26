//
//  NYTOperatingSystemCompatibilityUtilityTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 Brian Capps. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <OCMock/OCMock.h>
#import <NYTPhotoViewer/NYTOperatingSystemCompatibilityUtility.h>

@interface NYTOperatingSystemCompatibilityUtilityTests : XCTestCase

@end

@implementation NYTOperatingSystemCompatibilityUtilityTests

- (void)testiOS8ToViewMethodCalledOniOS8 {
    id partialMock = OCMPartialMock([UIDevice currentDevice]);
    OCMStub((NSString *)[(UIDevice *)partialMock systemVersion]).andCall(self, @selector(iOS8String));
    
    id transitionContext = OCMProtocolMock(@protocol(UIViewControllerContextTransitioning));
    
    OCMExpect([transitionContext viewForKey:UITransitionContextToViewKey]);
    [NYTOperatingSystemCompatibilityUtility toViewForTransitionContext:transitionContext];
    
    XCTAssertNoThrow(OCMVerifyAll(transitionContext));
}

- (void)testiOS8FromViewMethodCalledOniOS8 {
    id partialMock = OCMPartialMock([UIDevice currentDevice]);
    OCMStub((NSString *)[(UIDevice *)partialMock systemVersion]).andCall(self, @selector(iOS8String));
    
    id transitionContext = OCMProtocolMock(@protocol(UIViewControllerContextTransitioning));
    
    OCMExpect([transitionContext viewForKey:UITransitionContextFromViewKey]);
    [NYTOperatingSystemCompatibilityUtility fromViewForTransitionContext:transitionContext];
    
    XCTAssertNoThrow(OCMVerifyAll(transitionContext));
}

// dispatch_once prevents these tests from working.
//- (void)testiOS7ToViewControllerMethodCalledOniOS7 {
//    id partialMock = OCMPartialMock([UIDevice currentDevice]);
//    OCMStub((NSString *)[(UIDevice *)partialMock systemVersion]).andCall(self, @selector(iOS7String));
//    
//    id transitionContext = OCMProtocolMock(@protocol(UIViewControllerContextTransitioning));
//    
//    OCMExpect([transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]);
//    [NYTOperatingSystemCompatibilityUtility toViewForTransitionContext:transitionContext];
//    
//    XCTAssertNoThrow(OCMVerifyAll(transitionContext));
//}
//
//- (void)testiOS7FromViewControllerMethodCalledOniOS7 {
//    id partialMock = OCMPartialMock([UIDevice currentDevice]);
//    OCMStub((NSString *)[(UIDevice *)partialMock systemVersion]).andCall(self, @selector(iOS7String));
//    
//    id transitionContext = OCMProtocolMock(@protocol(UIViewControllerContextTransitioning));
//    
//    OCMExpect([transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]);
//    [NYTOperatingSystemCompatibilityUtility fromViewForTransitionContext:transitionContext];
//    
//    XCTAssertNoThrow(OCMVerifyAll(transitionContext));
//}
//
//
//- (NSString *)iOS7String {
//    return @"7.0.0";
//}

- (NSString *)iOS8String {
    return @"8.0.0";
}

@end
