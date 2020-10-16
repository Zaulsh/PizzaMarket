//
//  CredithistoryController.m
//  Homem De Pao
//
//  Created by BGMacMIni2 on 01/06/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import "CredithistoryController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "HistoryCell.h"
#import "StringConstants.h"

@interface CredithistoryController ()<MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource>{
    MBProgressHUD *HUD;
    NSMutableArray *listary;
    NSString *userid;
    int page;
}

@end

@implementation CredithistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    userid=[self get_shareddata:@"ID"];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    table.hidden=YES;
    nolbl.hidden=YES;
    topvw.hidden=YES;
    cartlbl.hidden=YES;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    listary=[[NSMutableArray alloc]init];
    page=0;

    [self show];
   
    
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
  
    NSString *path = [NSString stringWithFormat:@"%@get_wallet_history", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&userid=%@&page=%d",userid,page];
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
                                                                    NSArray  *listary1=[userdetails valueForKey:@"data"];
                                                                      if(listary1.count>0){
                                                                      [listary addObjectsFromArray:listary1];
                                                                      [table reloadData];
                                                                      NSLog(@"ary %@",listary);
                                                                      }
                                                                      
                                                                  }else{
                                                                //      [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  }
                                                                  
                                                                  if(listary.count>0){
                                                                      table.hidden=NO;
                                                                      nolbl.hidden=YES;
                                                                      topvw.hidden=NO;
                                                                  }else{
                                                                      table.hidden=YES;
                                                                      nolbl.hidden=NO;
                                                                      topvw.hidden=YES;

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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorColor = [UIColor clearColor];
    
    return [listary count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
        return 70;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    static NSString *identifier = @"HistoryCell";
    HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   // cell.vw.layer.borderWidth=0.5;
   // cell.vw.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.vw.layer.cornerRadius=8;
    cell.lbl1.text=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"wallet_reason"]];

    NSString *dateString=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"added_date"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [dateFormatter stringFromDate:date];

    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString1 = [dateFormatter stringFromDate:date];
    
    
    
    NSString *dateString2=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"deducted_date"]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter2 setLocale:locale1];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2 = [dateFormatter2 dateFromString:dateString2];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString2 = [dateFormatter2 stringFromDate:date2];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    NSString *newDateString3 = [dateFormatter2 stringFromDate:date2];
    
    if(![dateString isEqualToString:@"0000-00-00 00:00:00"]){
        cell.lbl2.text=newDateString;
        cell.lbl3.text=newDateString1;
        
    }else{
        cell.lbl2.text=newDateString2;
        cell.lbl3.text=newDateString3;
    }
    
    
    NSString *amt=[NSString stringWithFormat:@"%@ €",[[listary objectAtIndex:indexPath.row]valueForKey:@"added_amt"]];
    NSString *amt1=[NSString stringWithFormat:@"%@ €",[[listary objectAtIndex:indexPath.row]valueForKey:@"deducted_amt"]];
    
    

    if(![amt isEqualToString:@"0.00 €"]){
        cell.lbl4.text=amt;

    }else{
        cell.lbl4.text=amt1;

    }
   
    
    if (indexPath.row == [listary count]-1) {
        if (page<=[listary count]) {
            page = page + 1;
            
            [self show];
            
        }
    }

    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  ss1=[answer_array objectAtIndex:indexPath.row];
    // NSLog(@"++++++++++++image++++++++++++%@",ss1);
    // self.answer_label.text=ss1;
  
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
