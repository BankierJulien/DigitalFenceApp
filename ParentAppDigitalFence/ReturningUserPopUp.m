//
//  PopOverViewControllerAGAN.m
//  Bohemian
//
//  Created by Julien Bankier on 1/18/16.
//  Copyright © 2016 Julien Bankier. All rights reserved.
//

#import "ReturningUserPopUp.h"
#import "UserHomeVC.H"



// Change so this is only really a view
@interface ReturningUserPopUp ()

//@property (strong, nonatomic) MainViewController *mainView;
//@property (strong, nonatomic) NSString *username;

@end

@implementation ReturningUserPopUp

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:.6];
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popUpView.clipsToBounds = YES;
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.2 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.6 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)exitButton:(id)sender {
    self.userName = self.usernameTextfield.text;
    if (![self.userName  isEqual: @""]){

        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UserHomeVC * home= [storybord instantiateViewControllerWithIdentifier:@"HomeNav"] ;
        home.username= self.userName;
        [self.view.window.rootViewController presentViewController:home animated:YES completion:nil];

    }
    else{
        NSLog(@"Present error");
    }

    [self removeAnimate];
   
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    self.view.center = aView.center;
    [aView addSubview:self.view];
    if (animated) {
        [self showAnimate];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
