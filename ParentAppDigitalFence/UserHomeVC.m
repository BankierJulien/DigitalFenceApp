//
//  UserHomeVC.m
//  ParentAppDigitalFence
//
//  Created by Julien Bankier on 2/25/16.
//  Copyright © 2016 Julien Bankier. All rights reserved.
//

#import "UserHomeVC.h"
#import <CoreLocation/CoreLocation.h>

@interface UserHomeVC () <CLLocationManagerDelegate>{
    NSMutableData *responseData;
}

// URL Properties
@property (strong, nonatomic) NSMutableURLRequest *myURL;
@property (strong, nonatomic) NSString *temp;
// CLLocation Properties
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) IBOutlet UITextField *latTextField;
@property (strong, nonatomic) IBOutlet UITextField *longTextField;
@property (strong, nonatomic) IBOutlet UITextField *radiusTextField;
@property (strong, nonatomic) IBOutlet UILabel *nameTextLabel;

@property (nonatomic) int bsCounter;

- (IBAction)uploadFencePressed:(id)sender;
- (IBAction)checkLocationPressed:(id)sender;

@end

@implementation UserHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bsCounter = 0;
    NSString *hi= @"Hi ";
    NSString *usernameStr = [hi stringByAppendingString: self.username];
    [self.nameTextLabel setText:usernameStr];
    responseData = [NSMutableData data];
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager =[ [CLLocationManager alloc] init];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        self.locationManager.delegate = self;
        [self setLocationManager:self.locationManager];
        [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];


        NSLog(@"Location IS GOOD");
    }
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = [locations lastObject];
    CLLocationCoordinate2D currentLoc = [self.currentLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLoc, 200, 200);
    [self.mapView setRegion:region animated:NO];
    [self.mapView setShowsUserLocation:YES];

}


#pragma mark - URL Connection Methods

-(void) connection:(NSURLConnection* )connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"RECIEVERD");
    NSLog(@"%@", response.description);
    [responseData setLength:0]; //sets response data to 0
}

-(void) connection:(NSURLConnection* )connection didReceiveData:(NSData *)data {
    NSLog(@"data Recieved");
    [responseData appendData:data]; // appeneds data to response fata
}


-(NSCachedURLResponse *)connection:(NSURLConnection* )connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    NSLog(@"Casched");
    return nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"YOUR IN");
    NSLog(@"data received %lu", (unsigned long)responseData.length);
    if ((self.bsCounter == 1)) {
        NSLog(@"Upload Fence called");
    } else if ((self.bsCounter == 0)){
        [self checkLocationMethod];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createNewFence{
    self.bsCounter = 1;
    self.username = [self.username lowercaseString];
    NSDictionary *userDet =
    @{@"utf8":@"✓",
      @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=",
      @"user":@{
              @"username": self.username,
              @"latitude": self.latTextField.text,
              @"longitude": self.longTextField.text,
              @"radius": self.radiusTextField.text,
              },
      @"commit":@"Create User",
      @"action":@"update",
      @"controller":@"users"
      
      };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://protected-wildwood-8664.herokuapp.com/users"]];
    
    request.HTTPMethod = @"POST";
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDet
                                                       options:0
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"JSON ERROR : %@", [error localizedDescription]);
    }
    else {
        NSString *jsonString = [[NSString alloc]
                                initWithBytes:[jsonData bytes]
                                length:[jsonData length]
                                encoding:NSUTF8StringEncoding];
        NSLog(@"JSON OUTPUT: %@", jsonString);
    }
    
    [request setValue:@"application/json; charset+utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = jsonData;
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    NSLog(@"SHITS DONE");
    
}



- (IBAction)uploadFencePressed:(id)sender {
    if ((self.longTextField.text !=nil) && (self.latTextField.text !=nil) && (self.radiusTextField.text !=nil) ) {
        NSLog(@"HERE");
        [self createNewFence];
    }
}

- (IBAction)checkLocationPressed:(id)sender {
    self.bsCounter = 0;
    NSLog(@"Hit");
    self.username = [self.username lowercaseString];
    NSString *urlString = [NSString stringWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/%@.json",self.username]; // calls it to the usernames thing on herokuapp
    NSURL *requestURL = [NSURL URLWithString:urlString];
    self.myURL = [NSMutableURLRequest requestWithURL:requestURL];
    self.myURL.HTTPMethod=@"GET";
    [self.myURL setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:self.myURL delegate:self];
    [conn start];

}

-(void)checkLocationMethod{
    NSError *myError = nil;
    NSDictionary *responseDataDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"dict : %@", responseDataDict [@"is_in_zone"]);
    NSLog(@"%@", responseDataDict);
    if (responseDataDict[@"is_in_zone"] != [NSNull null]) {
        if ( [responseDataDict[@"is_in_zone"]boolValue ] == YES) {
            NSLog(@"IN ZONE");
            NSLog(@"%@,%@", responseDataDict[@"current_lat"], responseDataDict[@"current_longitude"]);
            double resLat = [responseDataDict[@"current_lat"]doubleValue];
            double resLong = [responseDataDict[@"current_longitude"]doubleValue];
            [self setKidPointOnMap:resLat longitude:resLong];

            
        }
        
        else if ( [responseDataDict[@"is_in_zone"]boolValue] == NO) {
            NSLog(@"NOT IN ZONE");
        }
    } else {
        NSLog(@"response data null");
        
    }
}

-(void)setKidPointOnMap:(double )latitude longitude:(double)longitude{
    CLLocationCoordinate2D kidPoint;
    kidPoint.latitude = latitude;
    kidPoint.longitude = longitude;
    MKPointAnnotation *kidAnnotation = [[MKPointAnnotation alloc] init];
    [kidAnnotation setCoordinate:kidPoint];
    [self.mapView addAnnotation:kidAnnotation];
    MKCoordinateRegion kidRegion = MKCoordinateRegionMakeWithDistance(kidPoint, 350, 350);
//    self.mapView.showsUserLocation = NO;
    [self.mapView setRegion:kidRegion animated:NO];
}
@end
