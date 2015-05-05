//
//  TDLoginViewController.m
//  TweetDigi
//
//  Created by Nicolas Rizk on 5/5/15.
//  Copyright (c) 2015 Nicolas Rizk. All rights reserved.
//

#import "TDLoginViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface TDLoginViewController ()

@end

@implementation TDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        
    }];
    logInButton.center = self.view.center;
    
    [self.view addSubview:logInButton];
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

@end
