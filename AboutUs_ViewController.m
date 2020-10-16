//
//  AboutUs_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/25/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "AboutUs_ViewController.h"
#import "SWRevealViewController.h"
#import "Featured_ViewController.h"
#import "Product_ViewController.h"
#import "SubscriptionController.h"
#import "Payment_ViewController.h"
#import "HistoryController.h"
#import "FAQ_ViewController.h"
#import "ContactUs_ViewController.h"
#import "Login_ViewController.h"
#import "MBProgressHUD.h"
#import "MenuCell.h"
#import "DBManager.h"
#import "StringConstants.h"

@interface AboutUs_ViewController ()<MBProgressHUDDelegate>{
    NSString *detail_str;
    MBProgressHUD *HUD;
    NSMutableArray *menulist,*menuimg;

}
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation AboutUs_ViewController
@synthesize detail_label,indicator,indi_view;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    email.text=[self get_shareddata:@"Login"];
    
    name.text=[self get_shareddata:@"Name"];
    menuvw.hidden=YES;

    
    menulist=[[NSMutableArray alloc]initWithObjects:@"Inicio",@"Entregas",@"Produtos",@"Carrinho",@"Histórico",@"FAQ",@"Contacte-nos",@"Sobre Nós",@"Sair",nil];
    menuimg=[[NSMutableArray alloc]initWithObjects:@"icon_home.png",@"my_order.png",@"icon_product.png",@"icon_cart.png",@"order_history.png",@"icon_faq.png",@"icon_contact.png",@"icon_aboutUs.png",@"Logout Rounded Up-48.png", nil];
    
    
    indi_view.hidden=YES;
    indicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
    indicator.startAnimating;

  //  [menubtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
    [disbtn addTarget:self action:@selector(disbtn:) forControlEvents:UIControlEventTouchUpInside];
//
    SWRevealViewController *revealViewController = self.revealViewController;

    if ( revealViewController )
    {
     //   [self.sidebarButton setTarget: self.revealViewController];
      //  [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [menubtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self show];
    [self wallet];

    // Do any additional setup after loading the view.
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
-(NSString *)get_shareddata:(NSString *)key{
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = key;
    NSString *currentLevel=@"";
    
    if ([preferences objectForKey:currentLevelKey] == nil)
    {
        
    }
    else
    {
        //  Get current level
        currentLevel = [preferences stringForKey:currentLevelKey];
    }
    return currentLevel;
}

-(void)menubtn:(id)sender{
  //  menuvw.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)disbtn:(id)sender{
    menuvw.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"view did appear");
}
-(void)show{
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@get_pages", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
      NSString *value = [NSString stringWithFormat:@"&pagename=%@",@"about_us"];
      NSLog(@"value:%@",value);
     value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
      value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
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
                                                                      NSDictionary *results = [userdetails valueForKey:@"pagedetail"];
                                                                      detail_str = [results objectForKey:@"PageDescription"];
                                                                    //  detail_str = [detail_str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

                                                                      NSString *htmlString = detail_str;
                                                                     htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                                      
                                                                      htmlString = [htmlString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];                                                                      //htmlString = [htmlString stringByAppendingString:@"<style>body{font-family:'system'; font-size:'17';}</style>"];
                                                                      
                                                                    
                                                                      /*Example:
                                                                       
                                                                       htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",_myLabel.font.fontName,_myLabel.font.pointSize]];
                                                                       */
                                                                      NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                                                                              initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                                              options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                                                              documentAttributes: nil
                                                                                                              error: nil
                                                                                                              ];
                                                                      detail_label.attributedText = attributedString;
                                                                      [detail_label sizeToFit];

//                                                                      NSScanner *myScanner;
//                                                                      NSString *text = nil;
//                                                                      myScanner = [NSScanner scannerWithString:detail_str];
//
//
//
//                                                                      while ([myScanner isAtEnd] == NO) {
//
//                                                                          [myScanner scanUpToString:@"<" intoString:NULL] ;
//
//                                                                          [myScanner scanUpToString:@">" intoString:&text] ;
//
//                                                                          detail_str = [detail_str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
//                                                                      }
//                                                                      //
//                                                                      detail_str = [detail_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                                                                      NSLog(@"html %@",detail_str);
//
//
//                                                                      if(detail_str==(id) [NSNull null] || [detail_str length]==0 || [detail_str isEqualToString:@""]){
//                                                                          detail_label.text=@"";
//                                                                      }else{
//                                                                          detail_label.text=detail_str;
//                                                                          NSLog(@"labelll %@",detail_label.text);
//                                                                          NSLog(@"labelll %@",detail_str);
//                                                                          [detail_label sizeToFit];
//                                                                          indi_view.hidden=YES;
//                                                                      }
                                                                      
                                                                      
                                                                  }
                                                                  
                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              [self alertStatus:@"Verifique a conexão com a Internetr" :@"" :0];
                                                              //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    [dataTask resume];
    
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        alertView.tag = tag;
        [alertView show];
        
    });
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
            Featured_ViewController  *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Featured_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row == 1){
            SubscriptionController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SubscriptionController"];
            [self.navigationController pushViewController:event animated:NO];
        }
        if(indexPath.row== 2){
            Product_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Product_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row== 3){
            Payment_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Payment_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row== 4){
            HistoryController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HistoryController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row== 5){
            FAQ_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FAQ_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row== 6){
            ContactUs_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUs_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row== 7){
            AboutUs_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUs_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row== 8){
            [self delete];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            Login_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        
        menuvw.hidden=YES;
    }
-(void)delete{
    NSString *query = [NSString stringWithFormat:@"delete from CardManager"];
    [self.dbManager executeQuery:query];
}

@end
