//
//  InZoneViewController.m
//  DigitalLeash
//
//  Created by chutima mungmee on 7/20/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import "InZoneViewController.h"
#import "ParentUserNameViewController.h"

@interface InZoneViewController ()

@end

@implementation InZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0x129AC7);
}

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

- (IBAction)btnWoohooPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
