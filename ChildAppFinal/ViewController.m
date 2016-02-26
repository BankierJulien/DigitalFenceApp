//
//  ViewController.m
//  ChildAppFinal
//
//  Created by Julien Bankier on 4/6/15.
//  Copyright (c) 2015 Julien Bankier. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    NSLog(@"Started To Update");
    [self.username setDelegate:self];
    
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:touch];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *myLoc = [locations lastObject];
    
    self.latitude = [[NSNumber numberWithFloat:myLoc.coordinate.latitude] stringValue];
    self.longitude = [[NSNumber numberWithFloat:myLoc.coordinate.longitude] stringValue];
    NSLog(@"fef");
    user = [self.username.text lowercaseString];
    NSString *userURL = [NSString stringWithFormat:@"http:/protected-wildwood-8664.herokuapp.com/users/%@", user];
    NSLog(@"user URl: %@", userURL);

    [self patchWork: userURL];
     NSLog(@"USER LOCAITON MANAGER: %@", user);
    NSLog(@"lat: %@", self.latitude);
    NSLog(@"Long: %@", self.longitude);
}



- (IBAction)activateButtoon:(id)sender {
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    NSLog(@"WE STILL ok");
}

-(void)patchWork:(NSString *)urlstring {

    NSDictionary *childDict = @{
                                @"utf8":@"✓",
                                @"authenticity token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=",
                                @"user":@{
                                        @"username": self.username.text,
                                        @"current_lat": self.latitude,
                                        @"current_longitude":self.longitude
                                        },
                                @"commit":@"Create User",
                                @"action":@"update",
                                @"controller":@"users"
                                };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
    
    request.HTTPMethod = @"PATCH";
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:childDict
                                                      options:0
                                                        error:&error];
    
    if (!jsonData) {
        NSLog(@"Json error: %@", error);
    }
    else {
        NSString *jsonString = [[NSString alloc]
                                initWithBytes:[jsonData bytes]
                                length:[jsonData length]
                                encoding:NSUTF8StringEncoding];
        NSLog(@"JSON OUTPUT : %@", jsonString);
        
    }
    
    [request setValue:@"application/json; charset+utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = jsonData;
    NSLog(@"%@", request.URL);
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    NSLog(@"YOU ARE DONE");
    
}



-(void) connection:(NSURLConnection* )connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@", [response description]);
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return nil;
}

- (void)connectionDidFinishLoading: (NSURLConnection *)connection {
    NSLog(@"FINISHED CONNECT");
}

-(void)connection: (NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error did fail : %@", [error localizedDescription]);
}
 
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.username resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard{
    [self.username resignFirstResponder];
}


@end
