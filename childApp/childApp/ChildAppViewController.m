//
//  ChildAppViewController.m
//  childApp
//
//  Created by chutima mungmee on 7/20/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import "ChildAppViewController.h"

@import CoreLocation;

@interface ChildAppViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ChildAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0x7FB439);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
//    self.locationManager.distanceFilter = 10; // meters
    
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    CGFloat longitude = location.coordinate.longitude;
    CGFloat latitude = location.coordinate.latitude;
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        
        NSDictionary *childDictionary = @{@"username" : self.txfUsername.text,
                                          @"current_longitude" : @(longitude),
                                          @"current_latitude" : @(latitude) };
        
        
        [self httpPatchRequest:childDictionary];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"push_locationReported" sender:self];
        });
        
        [self.locationManager stopUpdatingLocation];
        
        
    }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error! %@", error.localizedDescription);
}

-(NSData *)convertDictionaryToJsonData:(NSDictionary *)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(! jsonData) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    } else {
        return jsonData;
    }
    
}
-(void)httpPatchRequest:(NSDictionary *)dict {
    NSString *userID = self.txfUsername.text;
    NSString *urlStringWithID = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", userID];
    NSURL *url = [NSURL URLWithString:urlStringWithID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"PATCH"];
    [request setHTTPBody:[self convertDictionaryToJsonData:dict]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
          NSLog(@"done");
          
          // UIAlert if there is no internet
          if (error) {
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No internet connection" preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
              [alert addAction:defaultAction];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self presentViewController:alert animated:YES completion:nil];
              });
              
          }
      }] resume];
}


- (IBAction)btnReportLocationPressed:(id)sender {
    [self startStandardUpdates];
    
}
@end
