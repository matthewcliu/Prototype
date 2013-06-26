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
        UITabBarItem *tabBar = [self tabBarItem];
        [tabBar setTitle:@"Twitter Search"];
        accountStore = [[ACAccountStore alloc] init];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Add UISearchBar
    twitterSearchBar = [[UISearchBar alloc] init];
    [twitterSearchBar setPlaceholder:@"Enter a query"];
    [twitterSearchBar setDelegate:self];
    [[self view] addSubview:twitterSearchBar];
    [twitterSearchBar setTranslatesAutoresizingMaskIntoConstraints:NO];

    //Add Label
    UILabel *introLabel = [[UILabel alloc] init];
    [introLabel setText:@"Search the Twitter Search API"];
    [introLabel setTextAlignment:NSTextAlignmentCenter];
    [[self view] addSubview:introLabel];
    [introLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[twitterSearchBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(twitterSearchBar)]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[introLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(introLabel)]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[twitterSearchBar]-50-[introLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(twitterSearchBar, introLabel)]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Search bar methods
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
    NSString *query = [searchBar text];
    [self searchTwitterAPI:query];
    
    [searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    [searchBar setText:nil];
    [twitterSearchBar setShowsCancelButton:NO];
    
}

//Twitter methods
- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)searchTwitterAPI:(NSString *)query
{
    NSLog(@"%@", query);
    //Step 0: Check that the user has local Twitter accounts
    
    NSLog(@"User has access to Twitter: %c", [self userHasAccessToTwitter]);
    
    if ([self userHasAccessToTwitter]) {
        //Step 1: Obtains access to Twitter accounts
        ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted) {
                
                NSLog(@"Granted: %c", granted);
                
                //Step 2: Create a request
                NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
                
                NSString *queryString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=%@",query];
                
                NSURL *url = [NSURL URLWithString:queryString];
                
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:nil];
                NSLog(@"The request is: %@", request);
                
                //attach an account to the request - this is mandatory - normally this is not a clean way to request the right account but this is fine for the example
                [request setAccount:[twitterAccounts lastObject]];
                NSLog(@"The account used for the account is: %@", [request account]);
                
                //Step 3: Execute the request
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (responseData) {
                        
                        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
                            NSError *jsonError;
                            NSDictionary *searchData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error: &jsonError];
                            
                            if (searchData) {
                                NSLog(@"Twitter Server Response: %@\n", searchData);
                            } else {
                                //Our JSON deserialization went awry
                                NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                            }
                        } else {
                            //The server did not respond successfully... were we rate-limited?
                            NSLog(@"The response status code is %d", [urlResponse statusCode]);
                        }
                    }
                }];
            } else {
                //Access was not granted, or an error occurred
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}

@end
