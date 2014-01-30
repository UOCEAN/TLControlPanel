//
//  AboutViewController.h
//  TLControlPanel
//
//  Created by Chentou TONG on 16/1/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)close:(UIButton *)sender;


@end
