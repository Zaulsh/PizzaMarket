//
//  ViewPager_ViewController.m
//  Linkup
//
//  Created by Itgenesys on 10/12/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "ViewPager_ViewController.h"
#import "Featured_ViewController.h"
#import "FixedPlans_ViewController.h"
#import "SWRevealViewController.h"
#import "AddCart_ViewController.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define kDefaultEdgeInsets UIEdgeInsetsMake(5, 93, 5, 10)

@interface ViewPager_ViewController ()<UIScrollViewDelegate>
{
    /**
     *  Reference to array containing button title of top menu
     */
    NSArray *btnArray;
    NSString *cartacount_str;

}

/**
 *  Reference to Container scroll view containing all related controllers
 */
@property (weak) IBOutlet UIScrollView *containerScrollView;

/**
 *  Reference to Scroll View containg all top menu items
 */
@property (weak) IBOutlet UIScrollView *menuScrollView;

/**
 *  Add Menu Buttons in Menu Scroll View
 *
 *  @param buttonArray Array containing all menu button title
 */

-(void) addButtonsInScrollMenu:(NSArray *)buttonArray;


/**
 *  Any Of the Top Menu Button Press Action
 *
 *  @param sender id of the button pressed
 */
-(void) buttonPressed:(id) sender;


/**
 *  Calculating width of button added on top menu
 *
 *  @param title            Title of the Button
 *  @param buttonEdgeInsets Edge Insets for the title
 *
 *  @return Width of button
 */
- (CGFloat)widthForMenuTitle:(NSString *)title buttonEdgeInsets:(UIEdgeInsets)buttonEdgeInsets;


/**
 *  Adding all related controllers in to the container
 *
 *  @param controllersArr Array containing objects of all controllers
 */
-(void) addChildViewControllersOntoContainer:(NSArray *)controllersArr;

@end

@implementation ViewPager_ViewController
@synthesize cart_label,drawer_btn;
- (void)viewDidLoad
{
    [super viewDidLoad];
     cartacount_str=[self get_shareddata:@"noti_count"];
    cart_label.text=cartacount_str;
    NSLog(@"carttt %@",cartacount_str);
self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:(252/255.0) green:(184/255.0) blue:(61/255.0) alpha:1] ;
    UIImage *img = [UIImage imageNamed:@"logo_hdr.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
//    UIImage *image = [UIImage imageNamed: @"NavigationBar.png"];
//    [image drawInRect:CGRectMake(0, 0, 25, 25)];
//    image=[[UIImage alloc]init];
    
  // self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"logo_hdr.png"]];
    //add button in toolbar
        UIButton *settingsBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [settingsBtn setImage:[UIImage imageNamed:@"icon_cart.png"] forState:UIControlStateNormal];
        [settingsBtn addTarget:self action:@selector(cartView:) forControlEvents:UIControlEventTouchUpInside];
        [settingsBtn setFrame:CGRectMake(280, 0, 32, 32)];
        [self.navigationController.navigationBar addSubview:settingsBtn];
    //add label in toolbar
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(270,8,30,30)];
    navLabel.text =cartacount_str;
    NSLog(@"navlabelll %@",navLabel.text);
    navLabel.textColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:navLabel];
    [navLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.navigationController.navigationBar];

    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    [drawer_btn addTarget:self.revealViewController
           action:@selector(revealToggle:)
 forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view, typically from a nib.
    btnArray = @[@"DESTAQUES"];
    [self addButtonsInScrollMenu:btnArray];
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    Featured_ViewController *oneVC = [storyBoard instantiateViewControllerWithIdentifier:@"Featured_ViewController"];
    FixedPlans_ViewController *twoVC = [storyBoard instantiateViewControllerWithIdentifier:@"FixedPlans_ViewController"];
    NSArray *controllerArray = @[oneVC, twoVC];
    [self addChildViewControllersOntoContainer:controllerArray];
}
-(NSString *)get_shareddata:(NSString *)key{
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = key;
    NSString *currentLevel=@"";
    
    if ([preferences objectForKey:currentLevelKey] == nil)
    {
        
        //  Doesn't exist.
        //        Doctor_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Doctor_ViewController"];
        //
        //        //    after_reg1.data=usr1;
        //        [self.navigationController pushViewController:after_reg1 animated:NO];
        
    }
    else
    {
        //  Get current level
        currentLevel = [preferences stringForKey:currentLevelKey];
    }
    return currentLevel;
}

/**
 *  Add Menu Buttons in Menu Scroll View
 *
 *  @param buttonArray Array containing all menu button title
 */

#pragma mark - Add Menu Buttons in Menu Scroll View
-(void) addButtonsInScrollMenu:(NSArray *)buttonArray
{
    CGFloat buttonHeight = self.menuScrollView.frame.size.height;
    CGFloat cWidth = 0.0f;
    
    for (int i = 0 ; i<buttonArray.count; i++)
    {
        NSString *tagTitle = [buttonArray objectAtIndex:i];
        
        CGFloat buttonWidth = [self widthForMenuTitle:tagTitle buttonEdgeInsets:kDefaultEdgeInsets];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(cWidth, 0.0f, buttonWidth, buttonHeight);
        [button setTitle:tagTitle forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        [button setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.menuScrollView addSubview:button];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 4, button.frame.size.width, 5)];
        bottomView.backgroundColor = [UIColor brownColor];
        bottomView.tag = 1001;
        [button addSubview:bottomView];
        if (i == 0)
        {
            button.selected = YES;
            [bottomView setHidden:NO];
        }
        else
        {
            [bottomView setHidden:YES];
        }
        
        if (i==0) {
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake( 35, button.frame.size.height - 48, 20, 17)];
            
            imgView.image = [UIImage imageNamed:@"iconTabs_home.png"];
            [button addSubview:imgView];
        }
        if (i==1) {
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake( 45, button.frame.size.height - 48, 20, 17)];
            
            imgView.image = [UIImage imageNamed:@"iconTabs_comments.png"];
            [button addSubview:imgView];
        }
        if (i==2) {
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake( 45, button.frame.size.height - 48, 20, 17)];
            
            imgView.image = [UIImage imageNamed:@"iconTabs_group.png"];
            [button addSubview:imgView];
        }
        if (i==3) {
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake( 33, button.frame.size.height - 48, 20, 17)];
            
            imgView.image = [UIImage imageNamed:@"iconTabs_mapView.png"];
            [button addSubview:imgView];
        }

        //     NSArray*   bigimage_array=[[NSMutableArray alloc]initWithObjects:@"iconTabs_comments.png",@"iconTabs_comments.png",@"iconTabs_group.png",@"iconTabs_mapView.png",nil];
        //
        //        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake( 5, button.frame.size.height - 40, button.frame.size.width, 15)];
        //        NSIndexPath* indexPath;
        //        imgView.image = [UIImage imageNamed:[bigimage_array objectAtIndex:indexPath.row]];
        //        NSLog(@"image array %@",imgView);
        //        [button addSubview:imgView];
        
        cWidth += buttonWidth;
    }
    
    NSLog(@"scroll menu width->%f",cWidth);
    self.menuScrollView.contentSize = CGSizeMake(cWidth, self.menuScrollView.frame.size.height);
}


/**
 *  Any Of the Top Menu Button Press Action
 *
 *  @param sender id of the button pressed
 */

#pragma mark - Menu Button press action
-(void) buttonPressed:(id) sender
{
    UIButton *senderbtn = (UIButton *) sender;
    float buttonWidth = 0.0f;
    for (UIView *subView in self.menuScrollView.subviews)
    {
        UIButton *btn = (UIButton *) subView;
        UIView *bottomView = [btn viewWithTag:1001];
        
        if (btn.tag == senderbtn.tag)
        {
            btn.selected = YES;
            [bottomView setHidden:NO];
        }
        else
        {
            btn.selected = NO;
            [bottomView setHidden:YES];
        }
    }
    
    [self.containerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * senderbtn.tag, 0) animated:YES];
    
    float xx = SCREEN_WIDTH * (senderbtn.tag) * (buttonWidth / SCREEN_WIDTH) - buttonWidth;
    [self.menuScrollView scrollRectToVisible:CGRectMake(xx, 0, SCREEN_WIDTH, self.menuScrollView.frame.size.height) animated:YES];
}

/**
 *  Calculating width of button added on top menu
 *
 *  @param title            Title of the Button
 *  @param buttonEdgeInsets Edge Insets for the title
 *
 *  @return Width of button
 */

#pragma mark - Calculate width of menu button
- (CGFloat)widthForMenuTitle:(NSString *)title buttonEdgeInsets:(UIEdgeInsets)buttonEdgeInsets
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]};
    
    CGSize size = [title sizeWithAttributes:attributes];
    return CGSizeMake(size.width + buttonEdgeInsets.left + buttonEdgeInsets.right, size.height + buttonEdgeInsets.top + buttonEdgeInsets.bottom).width;
}


/**
 *  Adding all related controllers in to the container
 *
 *  @param controllersArr Array containing objects of all controllers
 */
#pragma mark - Adding all related controllers in to the container
-(void) addChildViewControllersOntoContainer:(NSArray *)controllersArr
{
    for (int i = 0 ; i < controllersArr.count; i++)
    {
        UIViewController *vc = (UIViewController *)[controllersArr objectAtIndex:i];
        CGRect frame = CGRectMake(0, 0, self.containerScrollView.frame.size.width, self.containerScrollView.frame.size.height);
        frame.origin.x = SCREEN_WIDTH * i;
        vc.view.frame = frame;
        
        [self addChildViewController:vc];
        [self.containerScrollView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
    
    self.containerScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * controllersArr.count + 1, self.containerScrollView.frame.size.height);
    self.containerScrollView.pagingEnabled = YES;
    self.containerScrollView.delegate = self;
}


#pragma mark - Scroll view delegate methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x / SCREEN_WIDTH);
    
    UIButton *btn;
    float buttonWidth = 0.0;
    for (UIView *subView in self.menuScrollView.subviews)
    {
        btn = (UIButton *) subView;
        UIView *bottomView = [btn viewWithTag:1001];
        
        if (btn.tag == page)
        {
            btn.selected = YES;
            buttonWidth = btn.frame.size.width;
            [bottomView setHidden:NO];
        }
        else
        {
            btn.selected = NO;
            [bottomView setHidden:YES];
        }
    }
    
    float xx = scrollView.contentOffset.x * (buttonWidth / SCREEN_WIDTH) - buttonWidth;
    [self.menuScrollView scrollRectToVisible:CGRectMake(xx, 0, SCREEN_WIDTH, self.menuScrollView.frame.size.height) animated:YES];
}

#pragma mark - other methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)cartView:(id)sender{
   AddCart_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCart_ViewController"];
    
//    //    after_reg1.data=usr1;
    [self.navigationController pushViewController:after_reg1 animated:NO];
 
}
@end
