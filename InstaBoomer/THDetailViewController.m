//
//  THDetailViewController.m
//  InstaBoomer
//
//  Created by Dhruv on 20/10/15.
//  Copyright (c) 2015 codeBrew. All rights reserved.
//

#import "THDetailViewController.h"
#import "THPhotoController.h"

@interface THDetailViewController ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIDynamicAnimator *animator;

@end

@implementation THDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, -320.0, 320.0f, 320.0f)];
    [self.view addSubview:self.imageView];
    
//    NSLog(@"bounds.origin.x: %f", self.imageView.bounds.origin.x);
//    NSLog(@"bounds.origin.y: %f", self.imageView.bounds.origin.y);
//    NSLog(@"bounds.size.width: %f", self.imageView.bounds.size.width);
//    NSLog(@"bounds.size.height: %f", self.imageView.bounds.size.height);
//    
//    NSLog(@"frame.origin.x: %f", self.imageView.frame.origin.x);
//    NSLog(@"frame.origin.y: %f", self.imageView.frame.origin.y);
//    NSLog(@"frame.size.width: %f", self.imageView.frame.size.width);
//    NSLog(@"frame.size.height: %f\n\n", self.imageView.frame.size.height);
    
    [THPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
   
}

-(void)close{
    
    [self.animator removeAllBehaviors];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds)+180.0f)];
    [self.animator addBehavior:snap];

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:self.view.center];
    [self.animator addBehavior:snap];
}

//-(void)viewDidLayoutSubviews{
//
//    [super viewDidLayoutSubviews];
//    CGSize size = self.view.bounds.size;
//    CGSize imageSize = CGSizeMake(size.width, size.width);
//    self.imageView.frame = CGRectMake(0.0, ((size.height - imageSize.height)/2.0), imageSize.width, imageSize.height);
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
