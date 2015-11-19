//
//  THPhotoController.h
//  InstaBoomer
//
//  Created by Aseem 1 on 20/10/15.
//  Copyright (c) 2015 codeBrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THPhotoController : NSObject

+(void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size
          completion:(void(^)(UIImage *image))completion;

@end
