//
//  DeliverySchedule_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 11/29/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "DeliverySchedule_ViewController.h"
#import "MyOrder_ViewController.h"
#import "StringConstants.h"

@interface DeliverySchedule_ViewController (){
    NSMutableArray *orDeDate_arr;
    NSMutableArray *orDeStatus_arr;
    NSMutableArray *orDelId_arr;
    NSString *OrDelId_str;
    NSString *date_str;
}

@end

@implementation DeliverySchedule_ViewController
@synthesize indi_view,indicator,orderid_str,calender_view,Date_label,datepicker,Cancel_btn;
- (void)viewDidLoad {
    [super viewDidLoad];
    calender_view.hidden=YES;
    Cancel_btn.hidden=YES;
    datepicker.hidden=YES;
    

    indi_view.hidden=YES;
    indicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
    indicator.startAnimating;
    NSLog(@"orderrriddd %@",orderid_str);
    [self order];
    //[self.tableview reloadData];
    // Do any additional setup after loading the view.
 

    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
//    [scrollViewChildDetail setScrollEnabled:YES];
//    [scrollViewChildDetail setContentSize:CGSizeMake(320, 520)];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    //hide keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.tableview reloadData];
    // Do any additional setup after loading the view.
}
-(void)dismissKeyboard {
    [Date_label resignFirstResponder];
   
    
}

//-(void)keyboardWillBeHidden:(NSNotification *)notification
//{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.scrollViewChildDetail.contentInset = contentInsets;
//    self.scrollViewChildDetail.scrollIndicatorInsets = contentInsets;
//}
//-(void)keyboardWasShown:(NSNotification*)notification
//{
//    NSDictionary *info = [notification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.view.frame.origin.x,self.view.frame.origin.y, kbSize.height+100, 0);
//    self.scrollViewChildDetail.contentInset = contentInsets;
//    self.scrollViewChildDetail.scrollIndicatorInsets = contentInsets;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)order{
    indi_view.hidden=NO;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@orderdeliveries", BASE_URL]];
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:url];
    [rq setHTTPMethod:@"POST"];
    NSString *post = [NSString stringWithFormat:@"&orderid=%@",orderid_str];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    [rq setHTTPBody:postData];
    [rq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:rq queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             NSError *parseError = nil;
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
             NSLog(@"Server Response (we want to see a 200 return code) %@",response);
             
             indi_view.hidden=YES;
             NSString *status = [dictionary valueForKey:@"status"];
             //
             NSLog(@"Count %@", status);
             orDeStatus_arr=[[NSMutableArray alloc]init];
             orDeDate_arr=[[NSMutableArray alloc]init];
             orDelId_arr=[[NSMutableArray alloc]init];
             
             NSArray *   results = [dictionary valueForKey:@"orderdeliverylist"];
             NSLog(@"Count %@", results);
             
                for (NSDictionary *Dicproduct in results) {
                 NSString *Name =[Dicproduct objectForKey:@"OrderDeliveryDate"];
                 NSLog(@"   >>>>>>,,,,fixedplan,,, %@",Name);
                 [orDeDate_arr addObject:Name];
                 NSString *Price =[Dicproduct objectForKey:@"OrderDeliveryStatus"];
                 NSLog(@"   >>>>>>,,,,fixedplan,,, %@",Price);
                 [orDeStatus_arr addObject:Price];
                 NSString *oderId =[Dicproduct objectForKey:@"OrderDeliveryID"];
                 NSLog(@"   >>>>>>,,,,fixedplan,,, %@",oderId);
                [orDelId_arr addObject:oderId];
                 [self.tableview reloadData];
                 
             }
             NSLog(@"dictionary %@",dictionary);
         }
         else if ([data length] == 0 && error == nil){
             indi_view.hidden=YES;
             NSLog(@"no data returned");
             [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
             //no data, but tried
         }
         else if (error != nil)
         {
             indi_view.hidden=YES;
             NSLog(@"there was a download error");
             [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
             //couldn't download
             
         }
     }];
    
    
    
}
-(IBAction)Send:(id)sender{
    indi_view.hidden=NO;
    calender_view.hidden=YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@editdeliverydate", BASE_URL]];
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:url];
    [rq setHTTPMethod:@"POST"];
    NSString *post = [NSString stringWithFormat:@"&orderdeliveryid=%@&datetoupdate=%@",OrDelId_str,date_str];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    [rq setHTTPBody:postData];
    [rq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:rq queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             NSError *parseError = nil;
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
             NSLog(@"Server Response (we want to see a 200 return code) %@",response);
             indi_view.hidden=YES;
             NSString *msg = [dictionary valueForKey:@"msg"];
                NSLog(@"Count %@", msg);

              [self alertStatus:msg:@"" :0];
             NSLog(@"dictionary %@",dictionary);
         }
         else if ([data length] == 0 && error == nil){
             indi_view.hidden=YES;
             NSLog(@"no data returned");
             [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
             //no data, but tried
         }
         else if (error != nil)
         {
             indi_view.hidden=YES;
             NSLog(@"there was a download error");
             [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
             //couldn't download
             
         }
     }];
    

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    tableView.separatorColor = [UIColor clearColor];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-4  tablearray  >> > > > > > > %@",orDeDate_arr);
    return [orDeDate_arr count];
    return [orDeStatus_arr count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }
    
    
    NSLog(@"   >>>>>>,,,,,,, >>>   str-5  [self.tablearray objectAtIndex:indexPath.row]  >> > > > > > > %@",[orDeStatus_arr objectAtIndex:indexPath.row]);
    
    
    
    
    UILabel *lbl=(UILabel *)[cell viewWithTag:1];
    NSString * ssss1=[orDeDate_arr objectAtIndex:indexPath.row];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    lbl.text=[NSString stringWithFormat:@"%@",ssss1];
    
    UILabel *lbl1=(UILabel *)[cell viewWithTag:2];
   UIImageView *img=(UIImageView *)[cell viewWithTag:4];
     NSString * ssss2=[orDeStatus_arr objectAtIndex:indexPath.row];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    if ([ssss2 isEqualToString:@"0"]) {
        lbl1.textColor=[UIColor colorWithRed:(252/255.0) green:(184/255.0) blue:(61/255.0) alpha:1];
         lbl1.text=@"Pending";
        img.image=[UIImage imageNamed:@"icon_pend.png"];
    }else if ([ssss2 isEqualToString:@"2"]){
        lbl1.textColor=[UIColor greenColor];
        lbl1.text=@"Delivered";
        img.image=[UIImage imageNamed:@"icon_del.png"];

    }
    UILabel *lbl2=(UILabel *)[cell viewWithTag:3];
    lbl2.text = [NSString stringWithFormat:@"Delivery No.%li", indexPath.row +1];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrDelId_str=[orDelId_arr objectAtIndex:indexPath.row];
    NSString * ssss2=[orDeStatus_arr objectAtIndex:indexPath.row];
       if ([ssss2 isEqualToString:@"0"]) {
           calender_view.hidden=NO;
    }else if ([ssss2 isEqualToString:@"2"]){
         [self alertStatus:@"Product Delivered" :@"" :0];
    }

    
    
    
}
//datepicker
-(IBAction)datePickerBtnAction:(id)sender
{
    //     indi_view.hidden=NO;
    //    indicator.hidden = NO;
    // datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0,10, 50)];
    //datepicker.datePickerMode=UIDatePickerModeDate;
    if([datepicker isHidden]){
            Cancel_btn.hidden=NO;
        datepicker.hidden=NO;
        datepicker.backgroundColor=[UIColor whiteColor];
        datepicker.date=[NSDate date];
        [datepicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
        //    [self.view addSubview:datepicker];
        //    rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
        //    self.navigationItem.rightBarButtonItem=rightBtn;
    }else{
        datepicker.hidden=YES;
        Cancel_btn.hidden=YES;
    }
}

-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
   date_str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datepicker.date]];
    //assign text to label
    Date_label.text=date_str;
    datepicker.hidden=YES;
    Cancel_btn.hidden=YES;

    NSLog(@" date = %@",date_str);
    
    
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
- (IBAction)Cancel:(id)sender{
    datepicker.hidden=YES;
    Cancel_btn.hidden=YES;
    
}
- (IBAction)CalenderCancel:(id)sender{
    calender_view.hidden=YES;
    
}
-(IBAction)backArrow:(id)sender{
    MyOrder_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyOrder_ViewController"];
    
       
    [self.navigationController pushViewController:event animated:NO];
    
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
