//
//  THDismissDetailTransition.m
//  InstaBoomer
//
//  Created by Aseem 1 on 19/11/15.
//  Copyright (c) 2015 codeBrew. All rights reserved.
//

#import "THDismissDetailTransition.h"


@implementation THDismissDetailTransition


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        detail.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [detail.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}


@end
