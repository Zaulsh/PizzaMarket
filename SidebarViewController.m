//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "MenuCell.h"
#import "ContactUs_ViewController.h"

#import "AboutUs_ViewController.h"
#import "SWRevealViewController.h"
#import "Featured_ViewController.h"
#import "Product_ViewController.h"
#import "SubscriptionController.h"
#import "Payment_ViewController.h"
#import "HistoryController.h"
#import "FAQ_ViewController.h"
#import "Login_ViewController.h"
#import "MBProgressHUD.h"
#import "DBManager.h"
#import "CreditController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "StringConstants.h"
@interface SidebarViewController ()<MBProgressHUDDelegate>{
    NSString *login_str,*userid;
    NSMutableArray *menulist,*menuimg;
    MBProgressHUD *HUD;

}
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation SidebarViewController {
    NSArray *menuItems;
     NSArray *menuItems1;
 NSString *name;
    NSString *fullname;
}
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
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"KRCS1.sqlite"];

    [disbtn addTarget:self action:@selector(disbtn:) forControlEvents:UIControlEventTouchUpInside];
    
    emailstr.text=[self get_shareddata:@"Login"];
    
    namestr.text=[self get_shareddata:@"Name"];
    menuvw.hidden=YES;
    userid=[self get_shareddata:@"ID"];

    
    
    menulist=[[NSMutableArray alloc]initWithObjects:@"Inicio",@"Entregas",@"Produtos",@"Carrinho",@"Histórico",@"FAQ",@"Contacte-nos",@"Sobre Nós",@"Sair",nil];
    menuimg=[[NSMutableArray alloc]initWithObjects:@"icon_home.png",@"my_order.png",@"icon_product.png",@"icon_cart.png",@"order_history.png",@"icon_faq.png",@"icon_contact.png",@"icon_aboutUs.png",@"Logout Rounded Up-48.png", nil];
    
    
    
    
    name=[self get_shareddata:@"Login"];
    NSLog(@"nameeee %@",name);
    emailstr.text=name;
    
    fullname=[self get_shareddata:@"Name"];
    NSLog(@"nameeee %@",fullname);
    namestr.text=fullname;

    
  
    
    menulist=[[NSMutableArray alloc]initWithObjects:@"Inicio",@"Entregas",@"Produtos",@"Carrinho",@"Histórico",@"Comprar crédito",@"FAQ",@"Contacte-nos",@"Sobre Nós",@"Sair",nil];
    menuimg=[[NSMutableArray alloc]initWithObjects:@"icon_home.png",@"my_order.png",@"icon_product.png",@"icon_cart.png",@"order_history.png",@"ic_wallet.png",@"icon_faq.png",@"icon_contact.png",@"icon_aboutUs.png",@"Logout Rounded Up-48.png", nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    walletstr.text=[NSString stringWithFormat:@"Saldo : %@€",[self get_shareddata:@"wallet"]];

    [self wallet];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
}
// get SHARED PREference

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
        return 50;
        
  
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return [menulist count];
        
   
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        menu.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *identifier = @"MenuCell";
        MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.name.text=[menulist objectAtIndex:indexPath.row];
        cell.img.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[menuimg objectAtIndex:indexPath.row]]];
        
        
        
        return cell;
        
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if(indexPath.row== 0){
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            Featured_ViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Featured_ViewController"];
            SWRevealViewController *revealController = self.revealViewController;
            [revealController setFrontViewController:view];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
        }
        if(indexPath.row == 1){
            
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            SubscriptionController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubscriptionController"];
            SWRevealViewController *revealController = self.revealViewController;
            [revealController setFrontViewController:view];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
          
        }
        if(indexPath.row== 2){
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            Product_ViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Product_ViewController"];
            SWRevealViewController *revealController = self.revealViewController;
            [revealController setFrontViewController:view];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
           
            
        }
        if(indexPath.row== 3){
            
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            Payment_ViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Payment_ViewController"];
            SWRevealViewController *revealController = self.revealViewController;
            [revealController setFrontViewController:view];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
          
        }
        if(indexPath.row== 4){
            
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            HistoryController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HistoryController"];
            SWRevealViewController *revealController = self.revealViewController;
            [revealController setFrontViewController:view];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
          
            
        }
        if(indexPath.row== 5){
            
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            CreditController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CreditController"];
            SWRevealViewController *revealController = self.revealViewController;
            [revealController setFrontViewController:view];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
           
            
        }
        //        if(indexPath.row== 6){
        //            CreditController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreditController"];
        //            [self.navigationController pushViewController:event animated:NO];
        //
        //        }
        if(indexPath.row== 6){
            
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            FAQ_ViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FAQ_ViewController"];
            SWRevealViewController *revealController = self.revealViewController;
            [revealController setFrontViewController:view];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
          
            
        }
        if(indexPath.row== 7){
            
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ContactUs_ViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ContactUs_ViewController"];
            SWRevealViewController *revealController = self.revealViewController;
            [revealController setFrontViewController:view];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
          
            
        }
        if(indexPath.row== 8){
            
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            AboutUs_ViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AboutUs_ViewController"];
            SWRevealViewController *revealController = self.revealViewController;
            [revealController setFrontViewController:view];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
           
            
        }
        if(indexPath.row== 9){
        //    [self.revealViewController performSelector:@selector(revealToggle:) withObject:nil];
            [self delete];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//            Login_ViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login_ViewController"];
//            SWRevealViewController *revealController = self.revealViewController;
//
//            [revealController setFrontViewController:view];
//            [self.revealViewController.navigationController pushViewController:view animated:YES];

            [[AppDelegate sharedAppDelegate]login];

        }
        
        menuvw.hidden=YES;
   
}

-(void)delete{
    NSString *query = [NSString stringWithFormat:@"delete from CardManager"];
    [self.dbManager executeQuery:query];
}

-(void)wallet{
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@get_wallet", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&userid=%@",[self get_shareddata:@"ID"]];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [request setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:request
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                                          [HUD hide:YES];
                                                          
                                                          if (!connectionError || data.length > 0) {
                                                              NSLog(@"going to process");
                                                              NSArray* userdetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  NSLog(@"returnDictionary = %@", userdetails);
                                                                  
                                                                  NSString *successs = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"status"]];
                                                                  NSString *message = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"msg"]];
                                                                  //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      
                                                                      NSString *wall=[NSString stringWithFormat:@"%@",[userdetails valueForKey:@"total"]];
                                                                      [self sharedata:@"wallet" :wall];
                                                                      
                                                                      
                                                                      //    walletstr.text=[NSString stringWithFormat:@"Saldo : %@€",[userdetails valueForKey:@"total"]];
                                                                      
                                                                  }
                                                                  
                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              //   [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              //  [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];                                                                  //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    
    [dataTask resume];
    
}

-(void)sharedata:(NSString*)key :(NSString*)value{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = key;
    
    const NSString *currentLevel = value;
    [preferences setValue:currentLevel forKey:currentLevelKey];
    
    //  Save to disk
    const BOOL didSave = [preferences synchronize];
    NSLog(@"key =====: %@", key);
    NSLog(@"value =====: %@", value);
    if (!didSave)
    {
        value=@"";
        //  Couldn't save (I've never seen this happen in real world testing)
    }
    
}

@end
