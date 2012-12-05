//
//  ViewController.m
//  ParseFBTemplate
//
//  Created by Barry Teoh on 12/6/12.
//  Copyright (c) 2012 perceptionz.net. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize appdelegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(IBAction)btnLogin:(id)sender {
    // Permissions
    NSArray *permissions =
    [NSArray arrayWithObjects:@"email", nil];
 
    // Use iOS 6 login
    // TODO: Let user know about this
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      /* handle success + failure in block */
                                      NSLog(@"Error: %@", [error debugDescription]);
                                      NSLog(@"Session: %@", [session debugDescription]);
                                      if (status == FBSessionStateOpen) {
                                          // Current access token
                                           NSLog(@"Access Token = %@", [[FBSession activeSession] accessToken]);
                                      }
                                  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
