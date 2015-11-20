//
//  THPhotosViewController.m
//  InstaBoomer
//
//  Created by Aseem 1 on 08/10/15.
//  Copyright (c) 2015 codeBrew. All rights reserved.
//

#import "THPhotosViewController.h"
#import "THPhotoCell.h"
#import <SimpleAuth/SimpleAuth.h>
#import "THDetailViewController.h"
#import "THPresentDetailTransition.h"
#import "THDismissDetailTransition.h"


@interface THPhotosViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic) NSString  *accessToken;
@property (nonatomic) NSArray *photos;

@end

@implementation THPhotosViewController

-(instancetype)init{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    
    self = [super initWithCollectionViewLayout:layout];
    return self;
}

-(void)viewDidLoad{

    [self.collectionView registerClass:[THPhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.title = @"Instagram Photos";
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURL *url = [[NSURL alloc] initWithString:@"http://api.geonames.org/countryInfoJSON?username=taran&country=AU"];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSString *text = [[NSString alloc] initWithContentsOfURL:location  encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"%@",text);
//        
//    }];
//    [task resume];chanakyasixnine
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
        
        [SimpleAuth authorize:@"instagram" options:@{@"scope":@[@"likes"]}
               completion:^(NSDictionary *responseObject, NSError *error) {
                   NSLog(@"%@",responseObject);
        
        self.accessToken = responseObject[@"credentials"][@"token"];
        //NSLog(@"%@",self.accessToken);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.accessToken forKey:@"accessToken"];
        [userDefaults synchronize];
        [self refresh];
                   
    }];
    }
    else{
        
             [self refresh];
    
        }
}

-(void)refresh {
    
    
    NSLog(@"SignedIn");
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString =[[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/quotes/media/recent?access_token=%@",self.accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
       // NSLog(@"%@",response);
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
       // NSLog(@"%@",responseDictionary);
        // Key Value Coding
        //            NSArray *photos = [responseDictionary valueForKeyPath:@"data.images.standard_resolution.url"];
        //            NSLog(@"My Photos:\n%@",photos);
      
        self.photos = [responseDictionary valueForKeyPath:@"data"];
      //  NSLog(@"My Photos:\n%@",self.photos);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
        
    }];
    [task resume];
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    THPhotoCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *photo = self.photos[indexPath.row];
    THDetailViewController *viewController = [[THDetailViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    
    viewController.photo = photo;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{

    return [[THPresentDetailTransition alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{

    return [[THDismissDetailTransition alloc] init];
}

@end
