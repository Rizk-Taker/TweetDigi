//
//  TDLoginViewController.m
//  TweetDigi
//
//  Created by Nicolas Rizk on 5/5/15.
//  Copyright (c) 2015 Nicolas Rizk. All rights reserved.
//

#import "TDLoginViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "TimeLineViewController.h"

@interface TDLoginViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *tendigians;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) NSLayoutConstraint *constraintY;
@property (weak, nonatomic) IBOutlet UILabel *tweetDigiLabel;
@end

@implementation TDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tendigians = @[
  @{@"twitter" : @"tendigi", @"name" : @"Tendigi"},
  @{@"twitter" : @"jeffsoto", @"name" : @"Jeff Soto, Founder"},
  @{@"twitter" : @"danchurch", @"name" : @"Dan Church, Operations Manager"},
  @{@"twitter" : @"heartsarts", @"name": @"Megan Kluttz, Designer"},
  @{@"twitter" : @"laurabarbera", @"name": @"Laura Barbera, Designer"}
  ];
    
    
    TWTRLogInButton* logInButton =  [TWTRLogInButton
                                     buttonWithLogInCompletion:
                                     ^(TWTRSession* session, NSError* error) {
                                         if (session) {
                                             NSLog(@"signed in as %@", [session userName]);
                                             [self animateLoginButton];
                                             
                                         } else {
                                             NSLog(@"error: %@", [error localizedDescription]);
                                             
                                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Could not access Twitter at this time. Please try again soon." message:nil preferredStyle:UIAlertControllerStyleAlert];
                                             
                                             UIAlertAction *popVC = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
                                             
                                             [alertController addAction:popVC];
                                             
                                             [self presentViewController:alertController animated:YES completion:nil];
                                         }
                                     }];
   
    [self.view addSubview:logInButton];
    
    [self autoLayoutView:logInButton];
}

- (void)animateLoginButton {

          [UIView animateWithDuration:1.0 animations:^{
              self.constraintY.constant = -400;
              self.tableView.hidden = NO;
              self.logo.hidden = YES;
              self.tweetDigiLabel.hidden = NO;
          }];
    
}

- (void)displayTwitterFeedForUser: (NSString *)twitterHandle
                           andName: (NSString *)name {
    
    TWTRAPIClient *APIClient = [[Twitter sharedInstance] APIClient];
    
    TWTRUserTimelineDataSource *userTimelineDataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:twitterHandle APIClient:APIClient];
    
    TimeLineViewController *timeLine = [[TimeLineViewController alloc] initWithDataSource:userTimelineDataSource];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:timeLine];
    
    nav.navigationBar.topItem.title = name;
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    
    [nav.navigationBar.topItem setLeftBarButtonItem:backButton];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tendigians count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.tendigians[indexPath.row][@"name"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:19];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tendigian = self.tendigians[indexPath.row];
    
    if ([tendigian[@"name"] isEqualToString:@"Dan Church, Operations Manager"]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Could not find Dan's Twitter Account :(" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *popVC = [UIAlertAction actionWithTitle:@"Ugh, fine." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertController addAction:popVC];
    
        [self presentViewController:alertController animated:YES completion:nil];
    
    } else {
   
    [self displayTwitterFeedForUser:tendigian[@"twitter"] andName:tendigian[@"name"]];
    }
    
}


- (void) autoLayoutView: (UIView *)view {
    [view removeConstraints:self.view.constraints];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraintX =
    
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0];
    
    [self.view addConstraint:constraintX];
    
    self.constraintY =
    
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0];
    
    [self.view addConstraint:self.constraintY];
    
}


@end
