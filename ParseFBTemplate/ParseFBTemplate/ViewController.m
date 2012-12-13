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
@synthesize loginButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self resetLoginProcess];
}

-(void) beginLoginProcess {
    // Set up UI so that you have tapped the login button
    loginButton.enabled = NO; // Disable login button
}
-(void) resetLoginProcess {
    // Set up UI so you can login again
    loginButton.enabled = YES;
}

-(IBAction)btnLogin:(id)sender {
    [self beginLoginProcess];
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
                                          // Parse needs an ID
                                          [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error){
                                              if (!error) {
                                                  // Use access token to sign into parse (or create account
                                                  [PFFacebookUtils logInWithFacebookId:[user id] accessToken:[session accessToken] expirationDate:[session expirationDate] block:^(PFUser *puser, NSError *error){
                                                      if (!error) {
                                                          // Successfully log in
                                                          //NSLog(@"User Info: %@", [user debugDescription]);
                                                          appdelegate.loggedInUser = puser;
                                                          [puser setEmail:[user objectForKey:@"email"]];
                                                          [puser setObject:[user objectForKey:@"id"] forKey:@"fbid"];
                                                          [puser saveInBackground];
                                                          [self performSegueWithIdentifier:@"LoginSegue" sender:self];
                                                      } else {
                                                          [self resetLoginProcess];
                                                          UIAlertView *parseError = [[UIAlertView alloc] initWithTitle:@"Server error" message:@"An unexpected error has occured. Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                                          [parseError show];
                                                          // Unspecified error
                                                          NSLog(@"Error: %@", [[error userInfo] debugDescription]);
                                                      }
                                                  }];
                                              } else {
                                                  [self resetLoginProcess];
                                                  // Error because the user removed application
                                                  // TODO: Check for "com.facebook.sdk:HTTPStatusCode" in the userInfo dictionary = 400
                                                  // Alternatively you can make the user restart
                                                  NSLog(@"Error: %@", [[error userInfo] debugDescription]);
                                              }
                                          }];
                                      } else if (status  == FBSessionStateClosedLoginFailed) {
                                          [self resetLoginProcess];
                                          // Error because the user defined the permissions
                                          UIAlertView *errorMsg = [[UIAlertView alloc] initWithTitle:@"Log in Failed" message:@"You have either denied permissions in the past or have application restrictions for Facebook switched on" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                                          [errorMsg show];
                                      }
                                  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
