//
//  ViewController.h
//  ParseFBTemplate
//
//  Created by Barry Teoh on 12/6/12.
//  Copyright (c) 2012 perceptionz.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) AppDelegate *appdelegate;

-(IBAction)btnLogin:(id)sender;
@end
