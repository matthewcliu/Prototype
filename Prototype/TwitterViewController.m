//
//  TwitterViewController.m
//  Prototype
//
//  Created by Matthew Liu on 6/20/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import "TwitterViewController.h"

@interface TwitterViewController ()

@end

@implementation TwitterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Add UITextField
    twitterSearchField = [[UITextField alloc] init];
    [twitterSearchField setPlaceholder:@"Enter a search query."];
    [twitterSearchField setBorderStyle:UITextBorderStyleRoundedRect];
    [[self view] addSubview:twitterSearchField];
    [twitterSearchField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Add UIButton
    queryButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [queryButton addTarget: self action:@selector(queryTwitterSearchAPI:) forControlEvents:UIControlEventTouchUpInside];
    [queryButton setTitle:@"Search" forState:UIControlStateNormal];
    [[self view] addSubview:queryButton];
    [queryButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[twitterSearchField]-10-[queryButton]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(twitterSearchField, queryButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[twitterSearchField]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(twitterSearchField)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[queryButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(queryButton)]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)queryTwitterSearchAPI:(id)sender
{
    
}
@end
