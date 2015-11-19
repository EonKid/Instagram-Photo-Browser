//
//  THPhotoController.m
//  InstaBoomer
//
//  Created by Aseem 1 on 20/10/15.
//  Copyright (c) 2015 codeBrew. All rights reserved.
//

#import "THPhotoController.h"
#import "THPhotoCell.h"
#import <SAMCache/SAMCache.h>

@implementation THPhotoController

+(void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size
          completion:(void(^)(UIImage *image))completion{
    
    if (photo == nil || size == nil || completion == nil) {
        return;
    }

    
    NSString *key = [[NSString alloc] initWithFormat:@"%@-%@", photo[@"id"],size];
    UIImage *image = [[SAMCache sharedCache] imageForKey:key];
    if (image) {
        completion(image);
        return;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:photo[@"images"][size][@"url"] ];

    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSLog(@"%@",data);
        UIImage *image = [[UIImage alloc] initWithData:data];
        [[SAMCache sharedCache] setImage:image forKey:key];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(image);
        });
        
    }];
    
    [task resume];

}

@end
