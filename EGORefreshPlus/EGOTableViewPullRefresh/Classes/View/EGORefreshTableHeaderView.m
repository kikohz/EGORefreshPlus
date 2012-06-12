//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor {
    if((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        CGRect labelRect;
        if(_pullDirection == EGORefresh_Dropdown)
            labelRect = CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f);
        else 
            labelRect = CGRectMake(frame.size.width-58.0f, 15.0f, 40.f, self.frame.size.height);
        
		UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:9.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
        if(_pullDirection == EGORefresh_Dropdown)
            labelRect = CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f);
        else 
            labelRect = CGRectMake(frame.size.width-68.0f, 0.0f, 60.f, self.frame.size.height);
        
		label = [[UILabel alloc] initWithFrame:labelRect];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:11.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
        CGRect calayerViewRect;
		if(_pullDirection == EGORefresh_Dropdown)
            calayerViewRect = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        else 
            calayerViewRect = CGRectMake(frame.size.width-55.0f, self.frame.size.height/2-45, 30.0f, 55.0f);
            CALayer *layer = [CALayer layer];
            layer.frame = calayerViewRect;
            layer.contentsGravity = kCAGravityResizeAspect;
            layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                layer.contentsScale = [[UIScreen mainScreen] scale];
            }
#endif
            [[self layer] addSublayer:layer];
            _arrowImage=layer;
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        CGRect indicatorViewRect;
        if(_pullDirection == EGORefresh_Dropdown)
            indicatorViewRect = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        else 
            indicatorViewRect = CGRectMake(frame.size.width-48.0f, self.frame.size.height/2-30, 20, 20);
        
		view.frame = indicatorViewRect;
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
    if(frame.origin.y > frame.origin.x)
        _pullDirection = EGORefresh_Rightpull;
    else
        _pullDirection = EGORefresh_Dropdown;
    NSString *imageName;
    if(_pullDirection == EGORefresh_Dropdown)
        imageName = @"blueArrow.png";
    else 
        imageName = @"IconRefreshArrow.png";
  return [self initWithFrame:frame arrowImageName:imageName textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

        NSString *strUpdata;
        if(_pullDirection == EGORefresh_Dropdown)
            strUpdata = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:date]];
        else 
            strUpdata = @"刚刚更新";
		_lastUpdatedLabel.text = strUpdata;
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
                if(_pullDirection == EGORefresh_Dropdown)
                    _statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
                else
                    _statusLabel.text = NSLocalizedString(@"松开可刷新", @"Release to refresh status");
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];

			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling)
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
                if(_pullDirection == EGORefresh_Dropdown)
                    _statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
                else 
                    _statusLabel.text = NSLocalizedString(@"右拉刷新", @"Pull down to refresh status");
			
                [_activityView stopAnimating];

                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
                _arrowImage.hidden = NO;
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];

			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			if(_pullDirection == EGORefresh_Dropdown)
                _statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
            else
                _statusLabel.text = NSLocalizedString(@"正在刷新", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
            if(_arrowImage)
                _arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		if(_pullDirection == EGORefresh_Dropdown){
            CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
            offset = MIN(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        }
        else {
            CGFloat offset = MAX(scrollView.contentOffset.x * -1, 0);
            offset = MIN(offset, 72);
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, offset, 0.0f, 0.0f);
        }
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
        
        int offset;
        if(_pullDirection == EGORefresh_Dropdown)
            offset = scrollView.contentOffset.y;
        if(_pullDirection == EGORefresh_Rightpull)
            offset = scrollView.contentOffset.x;
        
		if (_state == EGOOPullRefreshPulling && offset > -65.0f && offset < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && offset < -72.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
    int offset;
    if(_pullDirection == EGORefresh_Dropdown)
        offset = scrollView.contentOffset.y;
    if(_pullDirection == EGORefresh_Rightpull)
        offset = scrollView.contentOffset.x;
    if (offset <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
