//
//  THPhotoCell.m
//  InstaBoomer
//
//  Created by Dhruv on 08/10/15.
//  Copyright (c) 2015 codeBrew. All rights reserved.
//

#import "THPhotoCell.h"
#import "THPhotoController.h"

@implementation THPhotoCell

-(void)setPhoto:(NSDictionary *)photo{

    _photo = photo;
    
    [THPhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
       
        self.imageView.image = image;
    }];
    
   
}

-(id) initWithFrame:(CGRect)frame{


    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        
        [self.contentView addSubview:self.imageView];
    }
    return  self;
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}


-(void)like{
    
    NSLog(@" Link: %@",self.photo[@"link"]);

    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@",self.photo[@"id"],accessToken];
                           
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@",response);
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikedButton];
            
        });
        
    }];
    [task resume];
    
    }
-(void)showLikedButton{

    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:nil message:@"Liked !" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    });
}

@end
