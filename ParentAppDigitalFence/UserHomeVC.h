//
//  UserHomeVC.h
//  ParentAppDigitalFence
//
//  Created by Julien Bankier on 2/25/16.
//  Copyright © 2016 Julien Bankier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface UserHomeVC : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *username;

@end
