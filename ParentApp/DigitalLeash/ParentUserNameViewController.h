//
//  ParentUserNameViewController.h
//  DigitalLeash
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

@interface ParentUserNameViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblMain;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblRadius;
@property (weak, nonatomic) IBOutlet UITextField *txfLongitude;
@property (weak, nonatomic) IBOutlet UITextField *txfLatitude;
@property (weak, nonatomic) IBOutlet UITextField *txfUserName;
@property (weak, nonatomic) IBOutlet UITextField *txfRadius;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgvwDownload;

@property (nonatomic) NSMutableDictionary *mydictionary;

- (IBAction)createButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;
- (IBAction)statusButtonPressed:(id)sender;


@end
