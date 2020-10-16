//
//  SubscriptionController.m
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import "SubscriptionController.h"
#import "SubdetailController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "ItemCell.h"
#import "HistoryCell.h"
#import "SWRevealViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "StringConstants.h"

@interface SubscriptionController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    NSMutableArray *listary,*products;
}

@end

@implementation SubscriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
 //   [menubtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
    [nextbtn addTarget:self action:@selector(nextbtn:) forControlEvents:UIControlEventTouchUpInside];
    [sback addTarget:self action:@selector(sback:) forControlEvents:UIControlEventTouchUpInside];

    svw.hidden=YES;
    listary=[[NSMutableArray alloc]init];
    products=[[NSMutableArray alloc]init];
//    if(listary.count>0){
//        table.hidden=NO;
//        nolbl.hidden=YES;
//    }else{
        table.hidden=YES;
        nolbl.hidden=YES;
  //  }
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        //   [self.sidebarButton setTarget: self.revealViewController];
        //  [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [menubtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
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


-(void)sback:(id)sender{
    svw.hidden=YES;
}
-(void)menubtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextbtn:(id)sender{
    SubdetailController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SubdetailController"];
    [self.navigationController pushViewController:event animated:NO];
}
-(void)show{
    NSString *userid=[self get_shareddata:@"ID"];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
   
    NSString *path = [NSString stringWithFormat:@"%@myorder?", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&PNO=%@&userid=%@",@"0",userid];
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
                                                                      
                                                                      listary=[userdetails valueForKey:@"orderdetails"];
                                                                     
                                                                      
                                                                  }else{
                                                                    
                                                                //      [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  }
                                                                  
                                                                  if(listary.count>0){
                                                                      table.hidden=NO;
                                                                      nolbl.hidden=YES;
                                                                  }else{
                                                                      table.hidden=YES;
                                                                      nolbl.hidden=NO;
                                                                  }
                                                                  [table reloadData];

                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];
                                                              
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];
                                                              
                                                              //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    [dataTask resume];
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorColor = [UIColor clearColor];
    if(tableView == subtable){
        return [products count];
        
    }else{
        return [listary count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(tableView == subtable){
        return 100;
    }
   else{
        return 120;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == subtable){
        subtable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        static NSString *identifier = @"ItemCell";
        ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //  cell.vw.layer.borderWidth=1;
        // cell.vw.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        cell.name.text=[NSString stringWithFormat:@"%@",[[products objectAtIndex:indexPath.row]valueForKey:@"ProductName"]];
        cell.price.text=[NSString stringWithFormat:@"%@€",[[products objectAtIndex:indexPath.row]valueForKey:@"ProductPrice"]];
        cell.count.text=[NSString stringWithFormat:@"%@",[[products objectAtIndex:indexPath.row]valueForKey:@"Productqty"]];

//        NSString *ssss3=[[products objectAtIndex:indexPath.row]valueForKey:@"ProductImage"];
//        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ssss3]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//            cell.img.image = [UIImage imageWithData:data];
//        }];
        
        
        
        NSString *ssss3=[NSString stringWithFormat:@"%@", [[products objectAtIndex:indexPath.row]valueForKey:@"ProductImage"]];
        NSLog(@"img %@",ssss3);
        ssss3  = [ssss3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        ssss3= [ssss3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:ssss3] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"bread_images.jpg"]]];
        
        return cell;
        
    }else{
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        static NSString *identifier = @"HistoryCell";
        HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //  cell.vw.layer.borderWidth=1;
        // cell.vw.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        cell.vw.layer.cornerRadius = 5;
        cell.vw.clipsToBounds = YES;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(0, 1);
        cell.layer.shadowRadius = 1.0;
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOpacity = 0.5;
        
        NSString *dateString = [[listary objectAtIndex:indexPath.row]valueForKey:@"OrderStartDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        
        
        cell.lbl1.text=[NSString stringWithFormat:@"%d .",indexPath.row+1];
        cell.lbl2.text=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderID"]];
        cell.lbl3.text=[NSString stringWithFormat:@"pendente Entrega : %@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderNumDelivery"]];
        cell.lbl4.text=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionName"]];
        cell.lbl5.text=[NSString stringWithFormat:@"%@",newDateString];
        cell.lbl6.text=@"Toque";
       // cell.btn.tag=indexPath.row;
      //  [cell.btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == subtable){
        
    }else{
        products=[[listary objectAtIndex:indexPath.row] valueForKey:@"product"];
        if(products.count>0){
            svw.hidden=NO;
            subtable.frame=CGRectMake(subtable.frame.origin.x, subtable.frame.origin.y, subtable.frame.size.width, 100*products.count);
            [subtable reloadData];
        }
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
