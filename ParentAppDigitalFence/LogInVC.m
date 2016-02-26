//
//  ViewController.m
//  ParentAppDigitalFence
//
//  Created by Julien Bankier on 2/25/16.
//  Copyright © 2016 Julien Bankier. All rights reserved.
//

#import "LogInVC.h"
#import "ReturningUserPopUp.h"

@interface LogInVC ()


@property (strong, nonatomic) ReturningUserPopUp *popUpTest;


- (IBAction)testButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *loginView;

@end


@implementation LogInVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.popUpTest = [[ReturningUserPopUp alloc] init];

}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"HI");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)testButtonPressed:(id)sender {
    [self.popUpTest showInView:self.view animated:YES];
}
@end
