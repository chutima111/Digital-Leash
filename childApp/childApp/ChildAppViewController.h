//
//  ChildAppViewController.h
//  childApp
//
//  Created by chutima mungmee on 7/20/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ChildAppViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblParentName;
@property (weak, nonatomic) IBOutlet UITextField *txfUsername;
@property (weak, nonatomic) IBOutlet UITextField *txfparentName;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;


- (IBAction)btnReportLocationPressed:(id)sender;
        

@end
