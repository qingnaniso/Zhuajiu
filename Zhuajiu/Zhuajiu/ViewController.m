//
//  ViewController.m
//  Zhuajiu
//
//  Created by smartrookie on 16/9/9.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"
#import "DataSource.h"
#import "SettingViewController.h"

@interface ViewController () <iCarouselDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) NSArray *cacheDataSource;

@end

@implementation ViewController

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    _cacheDataSource = (NSArray *)[[DataSource shareDB] objectForKey:@"data"];
    _items = [NSMutableArray array];
    for (int i = 0; i < 9; i++)
    {
        [_cacheDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_items addObject:obj];
        }];
    }
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure carousel
    _carousel.type = iCarouselTypeInvertedWheel;
    _carousel.decelerationRate = 0.99;
    if (_items.count > 0) {
        self.lastIndex = arc4random() % _items.count;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:@"dataUpdate" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (void)dataChange:(NSNotification *)n
{
    _cacheDataSource = (NSArray *)[[DataSource shareDB] objectForKey:@"data"];
    _items = [NSMutableArray array];
    for (int i = 0; i < 9; i++)
    {
        [_cacheDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_items addObject:obj];
        }];
    }
    [self.carousel reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)buttonClicked:(id)sender {
    
    if (_items.count > 0) {
        
        NSInteger t;
        //    do {
        t = arc4random() % _items.count;
        
        //    } while (abs(t - self.lastIndex) %_items.count == 0);
        
        self.lastIndex = t;
        
        [self.carousel scrollToItemAtIndex:t duration:3];
    }

}

- (IBAction)setBtnClicked:(id)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SettingViewController class]]) {
        SettingViewController *vc = segue.destinationViewController;
        vc.dataFromLastPage = self.cacheDataSource;
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        
        NSLog(@"init view");
        view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        view.backgroundColor = [UIColor brownColor];
        
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        //        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        //        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        //        view.contentMode = UIViewContentModeCenter;
        //
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeThatFits:view.bounds.size];
        label.numberOfLines = 0;
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = _items[index];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}


@end
