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

- (void)testiOS8toViewMethodCalledOniOS8 {
    id partialMock = OCMPartialMock([UIDevice currentDevice]);
    OCMStub((NSString *)[(UIDevice *)partialMock systemVersion]).andCall(self, @selector(iOS8String));
    
    id transitionContext = OCMProtocolMock(@protocol(UIViewControllerContextTransitioning));
    
    UIView *testView = [[UIView alloc] init];
    OCMStub([transitionContext viewForKey:OCMOCK_ANY]).andReturn(testView);
    
    XCTAssertEqualObjects(testView, [NYTOperatingSystemCompatibilityUtility toViewForTransitionContext:transitionContext]);
}

- (void)testiOS8fromViewMethodCalledOniOS8 {
    id partialMock = OCMPartialMock([UIDevice currentDevice]);
    OCMStub((NSString *)[(UIDevice *)partialMock systemVersion]).andCall(self, @selector(iOS8String));
    
    id transitionContext = OCMProtocolMock(@protocol(UIViewControllerContextTransitioning));
    
    UIView *testView = [[UIView alloc] init];
    OCMStub([transitionContext viewForKey:OCMOCK_ANY]).andReturn(testView);
    
    XCTAssertEqualObjects(testView, [NYTOperatingSystemCompatibilityUtility fromViewForTransitionContext:transitionContext]);
}

- (NSString *)iOS8String {
    return @"8.0.0";
}

@end
