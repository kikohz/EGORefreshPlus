//
//  ViewController.m
//  EGORefreshPlus
//
//  Created by x on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)creatScrollView;

@end

@implementation ViewController
@synthesize scrollView = _scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self creatScrollView];
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f-self.scrollView.bounds.size.width, 0.0f, self.scrollView.frame.size.width, self.view.bounds.size.height)];
        //		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.scrollView.bounds.size.height, self.view.frame.size.width, self.scrollView.bounds.size.height)];
		view.delegate = self;
		[self.scrollView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    _reloading = NO;
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    _refreshHeaderView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [_scrollView release];
    _refreshHeaderView = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



- (void)creatScrollView
{
    int pagewide = self.view.bounds.size.width;
    int height = self.view.bounds.size.height;
    
    UIScrollView *ascrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, pagewide, height)];
    [ascrollView setScrollEnabled:YES];
    ascrollView.contentSize = CGSizeMake(pagewide, height);
    [ascrollView setShowsVerticalScrollIndicator:NO];
    [ascrollView setShowsHorizontalScrollIndicator:NO];
    [ascrollView setPagingEnabled:NO];        
    ascrollView.alwaysBounceHorizontal=YES;
    ascrollView.delegate = self;
    self.scrollView = ascrollView;
    [self.view addSubview:ascrollView];
    [ascrollView release];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
    
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];

	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	

	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{

	return [NSDate date]; // should return date data source was last changed
	
}@end
