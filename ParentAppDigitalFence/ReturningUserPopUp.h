//
//  PopOverViewControllerAGAN.h
//  Bohemian
//
//  Created by Julien Bankier on 1/18/16.
//  Copyright © 2016 Julien Bankier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"


@interface ReturningUserPopUp : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popUpView;

- (IBAction)exitButton:(id)sender;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (strong, nonatomic) NSString *userName;

@end
