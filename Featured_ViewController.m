//
//  Featured_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/15/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "Featured_ViewController.h"
#import "ProductDetail_ViewController.h"
#import "DBManager.h"
#import "SWRevealViewController.h"
#import "ItemCell.h"
#import "MBProgressHUD.h"
#import "AddCart_ViewController.h"
#import "Product_ViewController.h"
#import "ContactUs_ViewController.h"
#import "AboutUs_ViewController.h"
#import "FAQ_ViewController.h"
#import "MyOrder_ViewController.h"
#import "Payment_ViewController.h"
#import "HistoryController.h"
#import "SubscriptionController.h"
#import "MenuCell.h"
#import "Login_ViewController.h"
#import "CreditController.h"
#import "Login_ViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "StringConstants.h"
#import <Firebase/Firebase.h>

@interface Featured_ViewController ()<MBProgressHUDDelegate>{
    NSString *page_str;
    NSMutableArray *proName_array;
    UILabel *lbl2;
    UIButton *btn;
    NSString *ss1;
    int counter;
    NSMutableArray *array;
    NSInteger numberOfTableRow;
    NSString *ss2;
    NSString *ss4;
    NSMutableArray *proId_array;
    NSString *productid_str;
    NSString *proN_str;
    NSString *proId;
    NSString * ssss1;
    UIButton *deleteBtn;
    
    NSMutableArray *newArray;
    NSArray *results;
    MBProgressHUD *HUD;
    
    NSMutableArray *menulist,*menuimg;
}
@property (nonatomic, strong) DBManager *dbManager;
//@property (nonatomic, strong) NSArray *arrPeopleInfo;

@property (strong, nonatomic) FIRDatabaseReference *firedbdis;
@property (strong, nonatomic) FIRDatabaseReference *firedbtoken;


@end

@implementation Featured_ViewController
//@synthesize counter;
- (void)viewDidLoad {
    [super viewDidLoad];
    menuvw.hidden=YES;
    results =[[NSArray alloc]init];
   
    array = [[NSMutableArray alloc] init];
    [addcart addTarget:self action:@selector(addcart:) forControlEvents:UIControlEventTouchUpInside];
 //   [menubtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
    [disbtn addTarget:self action:@selector(disbtn:) forControlEvents:UIControlEventTouchUpInside];
    cartcount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"addquant"]];
    menulist=[[NSMutableArray alloc]initWithObjects:@"Inicio",@"Entregas",@"Produtos",@"Carrinho",@"Histórico",@"Comprar crédito",@"FAQ",@"Contacte-nos",@"Sobre Nós",@"Sair",nil];
    menuimg=[[NSMutableArray alloc]initWithObjects:@"icon_home.png",@"my_order.png",@"icon_product.png",@"icon_cart.png",@"order_history.png",@"ic_wallet.png",@"icon_faq.png",@"icon_contact.png",@"icon_aboutUs.png",@"Logout Rounded Up-48.png", nil];
    
   
    email.text=[self get_shareddata:@"Login"];

    name.text=[self get_shareddata:@"Name"];
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"KRCS1.sqlite"];
   
    page_str=@"0";
     [self show];
    [self loadData];
    if(results.count>0){
        self.tableview.hidden=NO;
    }else{
        self.tableview.hidden=YES;

    }

    searchbtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [searchbtn addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    if([[NSUserDefaults standardUserDefaults] valueForKey:@"ID"]){
        SWRevealViewController *revealViewController = self.revealViewController;
        //
        if ( revealViewController )
        {
            //        [self.sidebarButton setTarget: self.revealViewController];
            //        [self.sidebarButton setAction: @selector( revealToggle: )];
            //
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            //
        }

        [menubtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];

    } else {
        [menubtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.firedbdis = [[FIRDatabase database] referenceWithPath:@"/msg/"];
    self.firedbtoken = [[FIRDatabase database] referenceWithPath:@"/tokens/"];
    [self checkPushEvent];
    [self saveTokenToServer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"ID"]){
          [self wallet];
    }
  
   // [self loadData];
}
-(void)wallet{

  
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];

    NSString *path = [NSString stringWithFormat:@"%@get_wallet",BASE_URL];
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
                                                              //   [self.view makeToast:@"Network error" duration:3.0 position:CSToastPositionBottom];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              //  [self.view makeToast:@"Network error" duration:3.0 position:CSToastPositionBottom];                                                                  //couldn't download
                                                              
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
-(void)addcart:(id)sender{
    
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"ID"]){
    Payment_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Payment_ViewController"];
    [self.navigationController pushViewController:event animated:NO];
    }else{
        Login_ViewController  *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
    }
}
-(void)menubtn:(id)sender{
   Login_ViewController  *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
    [self.navigationController pushViewController:event animated:NO];
   
    
}
-(void)disbtn:(id)sender{
    menuvw.hidden=YES;
}
- (void)setAllElementofArrayToZero
{
    for(int i = 0;i < numberOfTableRow ;i++)
    {
        [array addObject:[NSNumber numberWithInteger:1]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)show{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];

    NSString *path = [NSString stringWithFormat:@"%@get_featured_product",BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&PNO=%@",page_str];
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
                                                                      
                                                                      results = [userdetails valueForKey:@"Productlist"];
                                                                      numberOfTableRow = results.count;
                                                                      [self setAllElementofArrayToZero];
                                                                      [self.tableview reloadData];
                                                                      if(results.count>0){
                                                                          self.tableview.hidden=NO;
                                                                      }else{
                                                                          self.tableview.hidden=YES;
                                                                          
                                                                      }

                                                                  }
//                                                                  else{
//                                                                      [self alertStatus:message :@"" :0];
//
//                                                                  }
                                                                  
                                                                  
                                                                 
                                                                  
                                                                  //   [table reloadData];                                                                             [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
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
                                                              [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
                                                              //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    [dataTask resume];


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(tableView == menu){
        return 50;
        
    }else{
     //   NSString *lbl=[NSString stringWithFormat:@"%@",[[results objectAtIndex:indexPath.row]valueForKey:@"ProductName"]];
        //  CGFloat dataTextHeight = [self getLabelHeightForIndex:lbl];
//        CGSize labelSize = [lbl sizeWithFont:[UIFont fontWithName:@"Oswald-Regular" size:15]
//                           constrainedToSize:CGSizeMake(tableView.frame.size.width - 20, CGFLOAT_MAX) // - 40 For cell padding
//                               lineBreakMode:NSLineBreakByWordWrapping];
//
        return 132;
        
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(tableView == menu){
        return [menulist count];
        
    }else{
    
    return [results count];
 
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == menu){
        
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
        
    }else{
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    static NSString *identifier = @"ItemCell";
    ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.vw.layer.borderWidth=1;
    cell.vw.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.vw.layer.cornerRadius=8;
        
   
    
        NSString *feestr =[NSString stringWithFormat:@"preço : %@€",[[results objectAtIndex:indexPath.row]valueForKey:@"ProductPrice"]] ;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:feestr];
        NSRange range = [feestr rangeOfString:@"preço"];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor  lightGrayColor] range:range];
        cell.price.attributedText = attString;
  //  NSString * ssss2=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductPrice"];
 //   NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
   // cell.price.text=[NSString stringWithFormat:@"preço %@€",ssss2];
    
    
  
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ssss3]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        cell.img.image = [UIImage imageWithData:data];
//    }];
        
        
        
    NSString *ssss3=[NSString stringWithFormat:@"%@",[[results objectAtIndex:indexPath.row]valueForKey:@"ProductImage"]];
    NSLog(@"img %@",ssss3);
        ssss3  = [ssss3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        ssss3= [ssss3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:ssss3] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"bread_images.jpg"]]];
  
    cell.plusbtn.tag=indexPath.row;
    [cell.plusbtn addTarget:self action:@selector(increaseItemCount:) forControlEvents:UIControlEventTouchUpInside];
    
 
    cell.minbtn.tag=indexPath.row;
    [cell.minbtn addTarget:self action:@selector(increaseItemCount1:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.count.text = [NSString stringWithFormat:@"%i",[[array objectAtIndex:indexPath.row] intValue]];

    
  deleteBtn=(UIButton *)[cell viewWithTag:6];
    cell.addcart.tag=indexPath.row;
    [cell.addcart addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    
        

        NSString *str=[NSString stringWithFormat:@"%@",[[results objectAtIndex:indexPath.row] valueForKey:@"ProductName"]];
        ssss1=[NSString stringWithFormat:@"%@",[[results objectAtIndex:indexPath.row] valueForKey:@"ProductName"]];
//
//        CGSize labelSize = [str sizeWithFont:[UIFont fontWithName:@"Oswald-Regular" size:15]
//                           constrainedToSize:CGSizeMake(self.tableview.frame.size.width - 20, CGFLOAT_MAX) // - 40 For cell padding
//                               lineBreakMode:NSLineBreakByWordWrapping];
//        cell.name.text = str;
//        cell.name.frame=CGRectMake(cell.name.frame.origin.x, cell.name.frame.origin.y, cell.name.frame.size.width, labelSize.height);
//        cell.plsvw.frame=CGRectMake(cell.plsvw.frame.origin.x, cell.name.frame.origin.y+cell.name.frame.size.height+10, cell.plsvw.frame.size.width, cell.plsvw.frame.size.height);
//          cell.price.frame=CGRectMake(cell.price.frame.origin.x, cell.plsvw.frame.origin.y+cell.plsvw.frame.size.height+8, cell.price.frame.size.width, cell.price.frame.size.height);
//        cell.addcart.frame=CGRectMake(cell.addcart.frame.origin.x, cell.plsvw.frame.origin.y+cell.plsvw.frame.size.height+8, cell.addcart.frame.size.width, cell.addcart.frame.size.height);
//        cell.vw.frame=CGRectMake(cell.vw.frame.origin.x, cell.vw.frame.origin.y, cell.vw.frame.size.width, cell.addcart.frame.size.height+cell.addcart.frame.origin.y+10);



        cell.name.text=[NSString stringWithFormat:@"%@",ssss1];
//
    return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == menu){
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
            CreditController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreditController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
//        if(indexPath.row== 6){
//            CreditController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreditController"];
//            [self.navigationController pushViewController:event animated:NO];
//
//        }
        if(indexPath.row== 6){
            FAQ_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FAQ_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row== 7){
            ContactUs_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUs_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row== 8){
            AboutUs_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUs_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        if(indexPath.row== 9){
            [self delete];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            Login_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
            [self.navigationController pushViewController:event animated:NO];
            
        }
        
        menuvw.hidden=YES;
    }else{
    
    ProductDetail_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetail_ViewController"];
    
    event.proImage_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductImage"];
    event.proName_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductName"];
       // NSString *str=[NSString stringWithFormat:@"%@",[[results objectAtIndex:indexPath.row]valueForKey:@"ProductDescription"]];
       // if([str isEqualToString:@"<null>"]){
       //     str=@"";
       // }else{
       //     str=[NSString stringWithFormat:@"%@",[[results objectAtIndex:indexPath.row]valueForKey:@"ProductDescription"]];
       // }
        event.proDescrip_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductDescription"];

    event.proPrice_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductPrice"];
    event.proID_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductID"];
        NSLog(@"%@",event.proImage_str);
    [self.navigationController pushViewController:event animated:NO];
    }
}

-(void)delete{
    NSString *query = [NSString stringWithFormat:@"delete from CardManager"];
        [self.dbManager executeQuery:query];
}
-(void)increaseItemCount:(UIButton *)sender
{
   // UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
   // NSIndexPath *path = [self.tableview indexPathForCell:cell];
    NSInteger str=[[array objectAtIndex:sender.tag] intValue];
    
    if(str >=1){

    [array replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:sender.tag] intValue]+1 ]];
    
    
    
    [self.tableview reloadData];
    }
    
}


-(void)increaseItemCount1:(UIButton *)sender
{
//    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
//    NSIndexPath *path = [self.tableview indexPathForCell:cell];
    NSInteger str=[[array objectAtIndex:sender.tag] intValue];
    if(str >1){
    [array replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:sender.tag] intValue]-1]];
    
    [self.tableview reloadData];
    }
    
}

- (void)saveInfo:(UIButton *)sender {
   
    [self loadData1];
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *path = [self.tableview indexPathForCell:cell];
 NSString *s1= [[results objectAtIndex:sender.tag]valueForKey:@"ProductID"];
    NSLog(@"aaaaaaaaaa %@",s1);
    BOOL isTheObjectThere = [newArray containsObject:s1];
    NSLog(@"bool %s", isTheObjectThere ? "true" : "false");

   
    NSString *query;
    if (isTheObjectThere == false) {
        query = [NSString stringWithFormat:@"insert into CardManager values(null, '%@', '%@', '%@', '%@', '%@')", [[results objectAtIndex:sender.tag]valueForKey:@"ProductID"],[[results objectAtIndex:sender.tag]valueForKey:@"ProductName"],[[results objectAtIndex:sender.tag]valueForKey:@"ProductImage"], [NSString stringWithFormat:@"%i",[[array objectAtIndex:sender.tag] intValue]],[[results objectAtIndex:sender.tag]valueForKey:@"ProductPrice"]];
        NSLog(@"qury: %@",query);

    }
    else{
        NSString *count=[NSString stringWithFormat:@"SELECT ProQuantity FROM CardManager WHERE ProductID ='%@'",[[results objectAtIndex:sender.tag]valueForKey:@"ProductID"]];
        [self.dbManager executeQuery:count];
        NSArray   *info = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:count]];
        NSLog(@"%@",info);
        int num=0;
        for (NSDictionary *result in info) {
            NSArray *aa=result;
            NSLog(@"reultttt %@",aa);
            for (int i=0;i<[aa count];i++){
                
                NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                     [aa objectAtIndex:i]] ;
                NSLog(@"temp%@",tmpObject);
                int j=[tmpObject intValue];
                num=num+j;
                tmpObject=nil;
            }
            
        }
        NSString *quan=[NSString stringWithFormat:@"%i",[[array objectAtIndex:sender.tag] intValue]];
        int c=num+[quan intValue];
        
        query = [NSString stringWithFormat:@"update CardManager set ProQuantity='%d' where ProductID='%@'",c,[[results objectAtIndex:sender.tag]valueForKey:@"ProductID"]];
        NSLog(@"%@",query);

     }
    
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    [array replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInteger:1]];
    [self.tableview reloadData];

    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
     //   NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
       
    }
    else{
        NSLog(@"Could not execute the query.");
        
    }
  
     [self loadData];
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

-(void)loadData1{
    // Form the query.
    NSArray *arrPeopleInfo=[[NSArray alloc]init];

    newArray=[[NSMutableArray alloc]init];
    NSString *query = @"select ProductID from CardManager";
    
    // Get the results.
    if (arrPeopleInfo != nil) {
        // self.arrPeopleInfo = nil;
    }
    arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"ooooo %@",arrPeopleInfo);
    for (NSDictionary *result in arrPeopleInfo) {
        NSArray *aa=result;
        NSLog(@"reultttt %@",aa);
        for (int i=0;i<[aa count];i++){
            
            NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                 [aa objectAtIndex:i]];
            NSLog(@"temp%@",tmpObject);
            [newArray addObject: tmpObject];
            tmpObject=nil;
        }
        NSLog(@"newww %lu",(unsigned long)newArray.count);
        
    }
    
    
    // Reload the table view.
}
-(void)loadData{
    // Form the query.
    NSArray *arrPeopleInfo=[[NSArray alloc]init];

    int count = 0;
  NSMutableArray   *newArray1=[[NSMutableArray alloc]init];
    NSString *query = @"select ProQuantity from CardManager";
    
    // Get the results.
    if (arrPeopleInfo != nil) {
        // self.arrPeopleInfo = nil;
    }
    arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"ooooo %@",arrPeopleInfo);
    for (NSDictionary *result in arrPeopleInfo) {
        NSArray *aa=result;
        NSLog(@"reultttt %@",aa);
        for (int i=0;i<[aa count];i++){

            NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                 [aa objectAtIndex:i]];
            NSLog(@"temp%@",tmpObject);
            int j=[tmpObject intValue];
            count=count+j;
            tmpObject=nil;
        }
        NSLog(@"newww %lu",(unsigned long)newArray1.count);
       
    }
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"addquant"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    cartcount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"addquant"]];

    // Reload the table view.
   }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) checkPushEvent{
    NSString *userid = [self get_shareddata:@"ID"];
    FIRDatabaseQuery *messagesForUser = [[self.firedbdis queryOrderedByChild:@"customerID"] queryEqualToValue:userid];
    __block BOOL didAlertUserForBatch = NO;
    NSLock *didAlertUserLock = [[NSLock alloc] init];
    [messagesForUser observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            NSString *comment = nil;
            NSString *customerID = nil;
            NSString *deliveryName = nil;
            NSString *orderID = nil;
            NSString *status = nil;

            for (FIRDataSnapshot *child in snapshot.children) {
                if ([child.key isEqualToString:@"comment"]) {
                    comment = child.value;
                } else if ([child.key isEqualToString:@"customerID"]) {
                    customerID = child.value;
                } else if ([child.key isEqualToString:@"deliveryName"]) {
                    deliveryName = child.value;
                }else if ([child.key isEqualToString:@"orderID"]) {
                    orderID = child.value;
                }else if ([child.key isEqualToString:@"status"]) {
                    status = child.value;
                    NSLog(@"status: %@", status);
                }
            }

            NSDictionary *d = @{
                                @"comment" : comment,
                                @"customerID": customerID,
                                @"deliveryName": deliveryName,
                                @"orderID":orderID,
                                @"status": @"1"
                                };

            NSLog(@"Firebase msg get: %@", d);

            NSString *msg = [NSString stringWithFormat:@"A sua entrega do dia foi efetuada!"];

            if ([didAlertUserLock tryLock]) {
                if([status isEqualToString:@"0"]){
                    //show alert if user has not recieved any alerts from this batch
                    if (!didAlertUserForBatch) {
                        didAlertUserForBatch = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // code here
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Homem Do Pão"
                                                                                message:msg
                                                                               delegate:self
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles:nil, nil];
                            alertView.tag = 0;
                            [alertView show];
                        });
                    }

                    [[self.firedbdis child:[snapshot key]] setValue:d];
                }

                [didAlertUserLock unlock];
            }
        }
    }];
}

- (void) saveTokenToServer{

    NSString *userid = [self get_shareddata:@"ID"];
    if(userid != nil && ![userid isEqualToString:@""]){
       
        //Send FCM token to server
        NSString *token = [self get_shareddata:@"fcmtoken"];
        NSString *key = [NSString stringWithFormat:@"%@_ios", userid];
        if(token != NULL){
            [[self.firedbtoken child:key] setValue:token];
            
        }
    }
}

- (void)searchButtonPressed:(id)sender {
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    Product_ViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Product_ViewController"];

    view.shouldInitiallyFocusSearchField = YES;

    SWRevealViewController *revealController = self.revealViewController;
    [revealController setFrontViewController:view];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}
@end
