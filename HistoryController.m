//
//  HistoryController.m
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import "HistoryController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "HistoryCell.h"
#import "HistorydetailController.h"
#import "SWRevealViewController.h"
#import "StringConstants.h"

@interface HistoryController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    NSString *userid;
    NSMutableArray *listary;
    int pageno;
}

@end

@implementation HistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [menubtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
    userid=[self get_shareddata:@"ID"];
    listary=[[NSMutableArray alloc]init];
    pageno=0;

    [self history];
    if(listary.count>0){
        table.hidden=NO;
        nolbl.hidden=YES;
    }else{
        table.hidden=YES;
        nolbl.hidden=NO;
    }
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        //   [self.sidebarButton setTarget: self.revealViewController];
        //  [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [menubtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
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


-(void)history{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
 
    NSString *path = [NSString stringWithFormat:@"%@order_history?", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&PNO=%d&userid=%@",pageno,userid];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
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
                                                                      NSArray *arry=[userdetails valueForKey:@"orderdetails"];
                                                                      
                                                                      if(arry.count>0){
                                                                      [listary addObjectsFromArray:arry];
                                                                      [table reloadData];
                                                                      if(listary.count>0){
                                                                          table.hidden=NO;
                                                                          nolbl.hidden=YES;
                                                                      }else{
                                                                          table.hidden=YES;
                                                                          nolbl.hidden=NO;
                                                                      }
                                                                      }
                                                                  }else{
                                                              //        [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  }
                                                                  
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
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorColor = [UIColor clearColor];
    
    return [listary count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSString *str=[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderPaymentStatus"];
    if([str isEqualToString:@"Pago"]){
         return 240;
    }else{
        return 270;
    }
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    static NSString *identifier = @"HistoryCell";
    HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *ostr=[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderPaymentStatus"];
    if([ostr isEqualToString:@"Pago"]){
        cell.lbl8.hidden=YES;
    }else{
        cell.lbl8.hidden=NO;
    }
    NSString *dateString = [[listary objectAtIndex:indexPath.row]valueForKey:@"OrderEndDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [dateFormatter stringFromDate:date];
    
    NSString *str=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    NSString *str1=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderID"]];
    
    NSString *feestr1 =[NSString stringWithFormat:@"%@ Nr Encomenda : %@",str,str1] ;
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:feestr1];
    NSRange range = [feestr1 rangeOfString:@"Nr Encomenda"];
    [attString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    cell.lbl1.attributedText = attString1;
    cell.lbl2.text=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderCurrentStatus"]];

    NSString *feestr3 =[NSString stringWithFormat:@"subscrição : %@",[[listary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionName"]] ;
    NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:feestr3];
    NSRange range3 = [feestr3 rangeOfString:@"subscrição"];
    [attString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range3];
    cell.lbl3.attributedText = attString3;
    
    
    NSString *feestr4 =[NSString stringWithFormat:@"Custo da subscrição : %@ €",[[listary objectAtIndex:indexPath.row]valueForKey:@"Ordercost"]] ;
    NSMutableAttributedString *attString4 = [[NSMutableAttributedString alloc] initWithString:feestr4];
    NSRange range4 = [feestr4 rangeOfString:@"Custo da subscrição"];
    [attString4 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range4];
    cell.lbl4.attributedText = attString4;
    
    NSString *feestr5 =[NSString stringWithFormat:@"Nr Entrega :  %@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderNumDelivery"]] ;
    NSMutableAttributedString *attString5 = [[NSMutableAttributedString alloc] initWithString:feestr5];
    NSRange range5 = [feestr5 rangeOfString:@"Nr Entrega"];
    [attString5 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range5];
    cell.lbl5.attributedText = attString5;
    
    
    
    NSString *feestr6 =[NSString stringWithFormat:@"Data de Início : %@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderStartDate"]] ;
    NSMutableAttributedString *attString6 = [[NSMutableAttributedString alloc] initWithString:feestr6];
    NSRange range6 = [feestr6 rangeOfString:@"Data de Início"];
    [attString6 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range6];
    cell.lbl6.attributedText = attString6;
    
    cell.lbl7.text=@"Toque para ver detalhe";
    
    NSString *feestr8 =[NSString stringWithFormat:@"Pageamento Estado : %@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderPaymentStatus"]] ;
    NSMutableAttributedString *attString8 = [[NSMutableAttributedString alloc] initWithString:feestr8];
    NSRange range8 = [feestr8 rangeOfString:@"Pageamento Estado"];
    [attString8 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range8];
    cell.lbl8.attributedText = attString8;
   
    
  
    if (indexPath.row == [listary count]-1) {
        if (pageno<=[listary count]) {
            pageno = pageno + 1;
            
            [self history];
            
        }
    }
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HistorydetailController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HistorydetailController"];
    event.listary=[listary objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:event animated:NO];

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
