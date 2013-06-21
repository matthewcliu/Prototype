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
    
    //Add UISearchBar
    twitterSearchBar = [[UISearchBar alloc] init];
    [twitterSearchBar setPlaceholder:@"Enter a search query."];
    [twitterSearchBar setDelegate:self];
    [[self view] addSubview:twitterSearchBar];
    [twitterSearchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[twitterSearchBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(twitterSearchBar)]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[twitterSearchBar]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(twitterSearchBar)]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [twitterSearchBar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [twitterSearchBar setShowsCancelButton:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //Add method for calling Twitter
    
    [searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    [searchBar setText:nil];
    [twitterSearchBar setShowsCancelButton:NO];
    
}

@end
