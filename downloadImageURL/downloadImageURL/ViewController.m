//
//  ViewController.m
//  downloadImageURL
//
//  Created by chutima mungmee on 7/21/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self downloadImageURL];

}

-(void)downloadImageURL {
    NSString *urlString = @"http://i.imgur.com/P67JW.png";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        
        self.image.image = downloadedImage;
        
    }];
    
    [downloadPhotoTask resume];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
