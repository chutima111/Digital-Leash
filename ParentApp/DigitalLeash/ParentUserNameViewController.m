//
//  ParentUserNameViewController.m
//  DigitalLeash
//
//  Created by chutima mungmee on 7/20/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import "ParentUserNameViewController.h"

@import CoreLocation;

@interface ParentUserNameViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ParentUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Test test
    
    self.view.backgroundColor = UIColorFromRGB(0x129AC7);
    self.btnCreate.backgroundColor = UIColorFromRGB(0x5ED29A);
    self.btnUpdate.backgroundColor = UIColorFromRGB(0x5ED29A);
    self.btnStatus.backgroundColor = UIColorFromRGB(0x5ED29A);
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self startStandardUpdates];

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txfRadius) {
        NSLog(@"Radius is equal to %@", self.txfRadius.text);
    }
    if (textField == self.txfUserName) {
        NSLog(@"User name is %@", self.txfUserName.text);
    }
            return YES;
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
    NSLog(@"latitude %+.6f, longitude %+.6f\n", latitude, longitude);
    self.txfLatitude.text = [NSString stringWithFormat:@"%f", latitude];
    self.txfLongitude.text = [NSString stringWithFormat:@"%f", longitude];
    [self.locationManager stopUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error! %@", error.localizedDescription);
}


-(void)addToDictionary {
    
    self.mydictionary = [[NSMutableDictionary alloc]init];
    [self.mydictionary setObject:self.txfUserName.text forKey:@"username"];
    [self.mydictionary setObject:self.txfRadius.text forKey:@"radius"];
    [self.mydictionary setObject:self.txfLongitude.text forKey:@"longitude"];
    [self.mydictionary setObject:self.txfLatitude.text forKey:@"latitude"];

}

-(NSString *)convertDictionaryToJsonString:(NSDictionary *)dictionary {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error:%@", error.localizedDescription);
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        
        return jsonString;
        
    };
    
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

-(NSDictionary *)convertJsonToDictionary: (NSString *)jsonString {
    NSError *error;
    NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    if (! jsonDict) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    } else {
        return jsonDict;
    }
    
}
-(NSDictionary *)convertJsonDataToDictionary:(NSData *)jsonData {
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (! jsonDict) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    } else {
        return jsonDict;
        
    }
}

-(void)httpPutRequest {
    NSString *userID = self.txfUserName.text;
    NSString *urlStringWithID = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", userID];
    NSURL *url = [NSURL URLWithString:urlStringWithID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[self convertDictionaryToJsonData:_mydictionary]];
    

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

-(void)httpGetRequest {
    NSString *userID = self.txfUserName.text;
    NSString *urlStringWithID = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", userID];
    NSURL *url = [NSURL URLWithString:urlStringWithID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];

    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
          NSLog(@"done");
          
          NSDictionary *childDict = [self convertJsonDataToDictionary:data];
          
          if (childDict[@"current_longitude"] == nil || childDict[@"current_latitude"] == nil) {
              
              //error message popup
              
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"The location is unknown" preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
              
              [alert addAction:defaultAction];
              dispatch_async(dispatch_get_main_queue(), ^{
              [self presentViewController:alert animated:YES completion:nil];
              });
              
          } else {
              double baseLongitude = [childDict[@"longitude"] doubleValue];
              double baseLatitude = [childDict[@"latitude"] doubleValue];
              
              double childLongitude = [childDict[@"current_longitude"] doubleValue];
              double childLatitude = [childDict[@"current_latitude"] doubleValue];
              double radius = [childDict[@"radius"]doubleValue];
              
              CLLocation *childLocation = [[CLLocation alloc] initWithLatitude:childLatitude longitude:childLongitude];
              CLLocation *baseLocation = [[CLLocation alloc]initWithLatitude:baseLatitude longitude:baseLongitude];
              
              double distance = [childLocation distanceFromLocation:baseLocation];
              
              if (distance <= radius) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                  [self performSegueWithIdentifier:@"push_childInZone" sender:self];
                  });
              }
              else {
                  dispatch_async(dispatch_get_main_queue(), ^{
                  [self performSegueWithIdentifier:@"push_childNotInZone" sender:self];
                  });
              }
          }
          
          
      }] resume];
    
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

- (IBAction)createButtonPressed:(id)sender {
    [self addToDictionary];
    [self httpPutRequest];
   
}

- (IBAction)updateButtonPressed:(id)sender {
    [self addToDictionary];
    [self httpPutRequest];
   
}

- (IBAction)statusButtonPressed:(id)sender {
    [self httpGetRequest];
}

@end
