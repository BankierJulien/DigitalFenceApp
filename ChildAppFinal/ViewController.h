//
//  ViewController.h
//  ChildAppFinal
//
//  Created by Julien Bankier on 4/6/15.
//  Copyright (c) 2015 Julien Bankier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, NSURLConnectionDelegate, UITextFieldDelegate> {
    
    NSString *user;
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;

- (IBAction)activateButtoon:(id)sender;


@end

