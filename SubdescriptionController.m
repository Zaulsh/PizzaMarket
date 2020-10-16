//
//  SubdescriptionController.m
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import "SubdescriptionController.h"
#import "HistoryCell.h"
#import "ItemCell.h"
#import "SBPickerSelector.h"
#import "FilterCell.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "StringConstants.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SubdescriptionController ()<SBPickerSelectorDelegate,MBProgressHUDDelegate>{
    NSMutableArray *products;
    NSString *productid;
    NSString *sDid;
    NSMutableArray *timeary;
    CLLocation *location;
    MBProgressHUD *HUD;
    int cpage;
    
    NSString *dLong, *dLat;
}

@end

@implementation SubdescriptionController
@synthesize  listary;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",listary);
    
    if(listary.count>0){
        table.hidden=NO;
        nolbl.hidden=YES;
    }else{
        table.hidden=YES;
        nolbl.hidden=NO;
    }
    svw.hidden=YES;
    dvw.hidden=YES;
    timevw.hidden=YES;
    [datetxt setTitle:@"definir data" forState:UIControlStateNormal];
    [timetxt setTitle:@"definir hora" forState:UIControlStateNormal];
    timeary=[[NSMutableArray alloc]initWithObjects:@"7:00",@"7:30",@"8:00",@"8:30",@"9:00",@"9:30",@"10:00", nil];
    toplbl.text=[NSString stringWithFormat:@"Dia %@ Entregas",self.count];
    [datetxt addTarget:self action:@selector(datetxt:) forControlEvents:UIControlEventTouchUpInside];
    [timetxt addTarget:self action:@selector(timetxt:) forControlEvents:UIControlEventTouchUpInside];

    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [sbck addTarget:self action:@selector(sbck:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn addTarget:self action:@selector(cancelbtn:) forControlEvents:UIControlEventTouchUpInside];
    [subbtn addTarget:self action:@selector(subbtn:) forControlEvents:UIControlEventTouchUpInside];
    [timecancel addTarget:self action:@selector(timecancel:) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
    [self findLocation];
}
-(void)timecancel:(id)sender{
    
    timevw.hidden=YES;
}
-(void)sbck:(id)sender{

    svw.hidden=YES;
}
-(void)subbtn:(id)sender{
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", dateString);
    if(([timetxt.titleLabel.text isEqualToString:@"definir hora"])||([datetxt.titleLabel.text isEqualToString:@"definir data"])){
       [self.view makeToast:@" Campo Vazio, Por favor preencha" duration:3.0 position:CSToastPositionBottom];
       
    }else if([datetxt.titleLabel.text isEqualToString:dateString]){
        [self.view makeToast:@"Não é possível agendar a entrega na data e hora pretendida." duration:3.0 position:CSToastPositionBottom];
        [datetxt setTitle:@"definir data" forState:UIControlStateNormal];
        [timetxt setTitle:@"definir hora" forState:UIControlStateNormal];
        dvw.hidden=YES;
    }else{
        dvw.hidden=YES;
        [self editdeliverydate];
    }
}-(void)cancelbtn:(id)sender{
    
    dvw.hidden=YES;
}
-(void)timetxt:(id)sender{
    timevw.hidden=NO;
}
-(void)editdeliverydate{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
  
    NSString *path = [NSString stringWithFormat:@"%@editdeliverydate?", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&orderdeliveryid=%@&datetoupdate=%@&timetoupdate=%@",productid,datetxt.titleLabel.text,timetxt.titleLabel.text];
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
                                                                  [self alertStatus:message :@"" :0];

                                                                  if([successs isEqualToString:@"1"]){
                                                                      NSLog(@"%@",listary);
                                                                      NSLog(@"page %d",cpage);
                                                                    //  [listary removeObjectAtIndex:cpage];
                                                                   //   NSLog(@"%@",listary);
                                                                   //  [table reloadData];

                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                      
                                                                  }else if([successs isEqualToString:@"0"]){
                                                                      
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
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)datetxt:(id)sender{
    [self.view endEditing:YES];
    SBPickerSelector *picker = [SBPickerSelector picker];
    picker.delegate = self;
    picker.pickerType = SBPickerSelectorTypeDate;
    [picker setMinimumDateAllowed:[NSDate date]];
    picker.doneButtonTitle = @"OK";
    picker.cancelButtonTitle = @"CANCELAR";
    
    CGPoint point = [self.view convertPoint:[sender frame].origin fromView:[sender superview]];
    CGRect frame = [sender frame];
    frame.origin = point;
    [picker showPickerIpadFromRect:frame inView:self.view];
}
-(void) pickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
   // [self.BtnSelectDate setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1] forState:UIControlStateNormal];
    
    [datetxt setTitle:[dateFormat stringFromDate:date] forState:UIControlStateNormal];
}

-(void) pickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    //NSLog(@"press cancel");
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorColor = [UIColor clearColor];
    if(tableView == subtable){
        return [products count];

    }else if(tableView == timetable){
        return [timeary count];
    }else{
    return [listary count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(tableView == subtable){
        return 50;
    }else if(tableView == timetable){
        return 50;
    }else{
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
         cell.price.text=[NSString stringWithFormat:@"%@",[[products objectAtIndex:indexPath.row]valueForKey:@"ProductQuantity"]];
        
        return cell;
        
    }else if(tableView == timetable){
        timetable.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *identifier = @"FilterCell";
        FilterCell *cell = (FilterCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //  cell.vw.layer.borderWidth=1;
        // cell.vw.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        cell.name.text=[NSString stringWithFormat:@"%@",[timeary objectAtIndex:indexPath.row]];
        
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
    
    cell.lbl1.text=[NSString stringWithFormat:@"subscrições : %@",[[listary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionName"]];
    cell.lbl2.text=[NSString stringWithFormat:@"Data de Entrega : %@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderDeliveryDate"]];
    cell.lbl3.text=[NSString stringWithFormat:@"Nr Entrega : %@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderDeliveryID"]];
    UIImageView *map = (UIImageView *)[cell viewWithTag:7];
        NSString *str=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderDeliveryStatus"]];
        sDid=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderDeliveryBoyID"]];
        if([str isEqualToString:@"2"]){
            cell.lbl4.text=@"COMPLETADO";
            cell.lbl4.textColor=[UIColor redColor];
            cell.lbl6.text=@"";
            cell.btn.hidden=YES;
            map.hidden = YES;
        }else if([str isEqualToString:@"1"]){
            cell.lbl4.text=@"Em distribuição";
            cell.lbl4.textColor=[UIColor greenColor];
            cell.lbl6.text=@"Monitorizar Entrega";
            cell.btn.hidden=NO;
            map.hidden = NO;
            
            cell.btn.tag=indexPath.row;
            [cell.btn addTarget:self action:@selector(mapBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.lbl4.text=@"PENDENTE";
            cell.lbl6.text=@"Atualizar Entrega";
            cell.lbl4.textColor=[UIColor colorWithRed:248/255.0 green:184/255.0 blue:61/255.0 alpha:1];
            map.hidden = YES;
            cell.btn.hidden=NO;

            cell.btn.tag=indexPath.row;
            [cell.btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        }
    cell.lbl5.text=[NSString stringWithFormat:@"Hora de Entrega : %@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderDeliveryTime"]];
        
    return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == subtable){
        
    }else if(tableView == timetable){
        
        [timetxt setTitle:[timeary objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        timevw.hidden=YES;

    }else{
        products=[[listary objectAtIndex:indexPath.row] valueForKey:@"product"];
        NSLog(@"%@",products);
        if(products.count>0){
            svw.hidden=NO;
            [subtable reloadData];
        }else{
            [self.view makeToast:@"Nenhum produto" duration:3.0 position:CSToastPositionBottom];

        }
        
    }
    
}

-(void)btn:(UIButton *)sender{
    cpage=sender.tag;
    [datetxt setTitle:@"definir data" forState:UIControlStateNormal];
    [timetxt setTitle:@"definir hora" forState:UIControlStateNormal];
    productid=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:sender.tag]valueForKey:@"OrderDeliveryID"]];
    dvw.hidden = NO;
    
}

-(void)mapBtn:(UIButton *)sender{
    
    NSLog(@" Delivery id : %@", sDid);
    [self getDeliveryLocation];
    
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

- (void) getDeliveryLocation{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@usersdeliveryboylocation?", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&deliveryboyid=%@",sDid];
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
                                                                  NSString *msg = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"msg"]];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      NSArray *result = [userdetails valueForKey:@"result"];
                                                                      dLat =  [NSString stringWithFormat:@"%@",[result valueForKey:@"latitude"]];
                                                                      dLong = [NSString stringWithFormat:@"%@",[result valueForKey:@"longitude"]];
                                                        
                                                                      [self showMap];
                                                                      
                                                                  }else if([successs isEqualToString:@"0"]){
                                                                      [self.view makeToast:msg duration:3.0 position:CSToastPositionBottom];
                                                                  }
                                                                  
                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              
                                                          }
                                                          
                                                      }];
    [dataTask resume];
}

-(void)findLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"didUpdateLocations");
    
    location = [locations objectAtIndex:0];
    NSLog(@"latitude = %f, longitude = %f", location.coordinate.latitude, location.coordinate.longitude);
    
    [manager stopUpdatingHeading];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"didUpdateToLocation");}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
    [manager stopUpdatingLocation];
}


- (void) showMap {
      dispatch_async(dispatch_get_main_queue(), ^{
          
          NSString *deliveryaddr = [NSString stringWithFormat:@"%@,%@", dLat, dLong];
          //NSString *deliveryaddr = @"40.765819,-73.975866";
          if (deliveryaddr==(id) [NSNull null] || [deliveryaddr length]==0 || [deliveryaddr isEqualToString:@""]) {
              [self alertStatus:@"Incorrect Address" :@"" :0];
          }else{
              //NSString *saddr = @"41.8527042,123.4041439";
              NSString* saddr = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
              NSLog(@" current location -------------------- %@",saddr);
              NSLog(@" delivery location -------------------- %@",deliveryaddr);
              
              
              NSString* urlString = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%@&daddr=%@",
                                     deliveryaddr, saddr];
              
              // NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",@"40.765819,-73.975866"];
              NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
          }
      });
}

@end
