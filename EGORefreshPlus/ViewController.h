//
//  ViewController.h
//  EGORefreshPlus
//
//  Created by x on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface ViewController : UIViewController< UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIScrollView *_scrollView;
}


@property (nonatomic, retain) UIScrollView *scrollView;
@end
