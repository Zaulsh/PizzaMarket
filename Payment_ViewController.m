//
//  Payment_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 11/11/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//
#import "DBManager.h"
#import "Payment_ViewController.h"
#import "Confirmation_ViewController.h"
#import "UIView+Toast.h"
#import "HistoryCell.h"
#import "ItemCell.h"
#import "FilterCell.h"
#import "MBProgressHUD.h"
#import "SBPickerSelector.h"
#import "PaymentconfController.h"
#import "SWRevealViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "StringConstants.h"

//#import <JSONKit/JSON.h>
@interface Payment_ViewController ()<MBProgressHUDDelegate,SBPickerSelectorDelegate>{
    NSMutableArray *subName_arr;
    NSMutableArray *subId_arr;
    NSArray *inputarray;
    NSString *sub_str;
    NSString * subID_str,*productid, *subID_custom_str, *custom_days;
    NSMutableArray *array;
    NSInteger numberOfTableRow;
    NSMutableArray *newArray,*timeary;
    NSMutableArray *subary;
    float price;
    MBProgressHUD *HUD;
    float totalprice;
    NSMutableArray *proidary,*productlist,*newArray1;
    
    NSString *flagstr,*days;
    NSDate *selectedData;

}
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;

@end

@implementation Payment_ViewController
@synthesize sub_btn,sub_picker,pro_id,total_label;
- (void)viewDidLoad {
    [super viewDidLoad];
    sub_picker.hidden=YES;
    altvw.hidden=YES;
    altvw1.hidden=YES;
    timevw.hidden=YES;
    payvw.hidden=YES;
   
    subvw.hidden=YES;
   
    SWRevealViewController *revealViewController=self.revealViewController;
    if ( revealViewController )
    {
        //   [self.sidebarButton setTarget: self.revealViewController];
        //  [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Do any additional setup after loading the view.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"KRCS1.sqlite"];
    
    svw.layer.borderWidth=0.5;
    svw.layer.borderColor=[UIColor lightGrayColor].CGColor;
    svw.layer.cornerRadius=5;
    subtable.layer.cornerRadius=5;
    
  //  [self.tblPeople reloadData];
    // Load the data.
    [paydate setTitle:@"definir data" forState:UIControlStateNormal];
    [paytime setTitle:@"definir hora" forState:UIControlStateNormal];
    timeary=[[NSMutableArray alloc]initWithObjects:@"7:00",@"7:30",@"8:00",@"8:30",@"9:00",@"9:30",@"10:00", nil];
//    timetable.frame=CGRectMake(timetable.frame.origin.x, timetable.frame.origin.y, timetable.frame.size.width, 50*timeary.count);
//    timecancel.frame=CGRectMake(timecancel.frame.origin.x, timetable.frame.size.height, timecancel.frame.size.width, timecancel.frame.size.height);
//    timevww.frame=CGRectMake(timevww.frame.origin.x, timevww.frame.origin.y, timevww.frame.size.width, timecancel.frame.size.height+timeca.frame.size.height);
    NSLog(@"countttt %lu",(unsigned long)[_arrPeopleInfo count]);
    NSInteger *ff=[_arrPeopleInfo count];
    NSString *inStr = [NSString stringWithFormat: @"%ld", (long)ff];
    NSLog(@"key =====: %@",inStr);
    [self sharedata:@"noti_count" :inStr];
    [subvwbtn addTarget:self action:@selector(subvwbtn:) forControlEvents:UIControlEventTouchUpInside];
    [deletebtn addTarget:self action:@selector(deletebtn:) forControlEvents:UIControlEventTouchUpInside];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [altok addTarget:self action:@selector(altok:) forControlEvents:UIControlEventTouchUpInside];
    [altcancel addTarget:self action:@selector(altcancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [altok1 addTarget:self action:@selector(altok1:) forControlEvents:UIControlEventTouchUpInside];
    [altcan1 addTarget:self action:@selector(altcan1:) forControlEvents:UIControlEventTouchUpInside];
    
    [payok addTarget:self action:@selector(payok:) forControlEvents:UIControlEventTouchUpInside];
    [paycan addTarget:self action:@selector(paycan:) forControlEvents:UIControlEventTouchUpInside];
    [paydate addTarget:self action:@selector(paydate:) forControlEvents:UIControlEventTouchUpInside];
    [paytime addTarget:self action:@selector(paytime:) forControlEvents:UIControlEventTouchUpInside];
    [timecancel addTarget:self action:@selector(timecancel:) forControlEvents:UIControlEventTouchUpInside];
   
    
    NSString *feestr1 =[NSString stringWithFormat:@"Total: 0.0 €"] ;
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:feestr1];
    NSRange range1 = [feestr1 rangeOfString:@"Total"];
    [attString1 addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range1];
    total_label.attributedText = attString1;
    self.tblPeople.hidden=YES;
 //   [self.tblPeople reloadData];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     flagstr=@"0";
    proidary=[[NSMutableArray alloc]init];
    array = [[NSMutableArray alloc] init];
    subary=[[NSMutableArray alloc]init];
    pro_id=[[NSMutableArray alloc]init];
    productlist=[[NSMutableArray alloc]init];
    [self show];
    [self loadData2];
    

    
}
-(void)timecancel:(id)sender{
    
    timevw.hidden=YES;
}
-(void)paytime:(id)sender{
    
    timevw.hidden=NO;
    
   

}
-(void)paydate:(id)sender{
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
    selectedData = date;
    [paydate setTitle:[dateFormat stringFromDate:date] forState:UIControlStateNormal];
}

-(void) pickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    //NSLog(@"press cancel");
}

-(void)paycan:(id)sender{
    [paydate setTitle:@"definir data" forState:UIControlStateNormal];
    [paytime setTitle:@"definir hora" forState:UIControlStateNormal];
    payvw.hidden=YES;
}

- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:dateFormat];
    
    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
    
    return convertedString;
}

-(void)payok:(id)sender{
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", dateString);
    
    NSString *yearStringA = [self curentDateStringFromDate:today withFormat:@"MM-yyyy"];
    int dayStringA = [self curentDateStringFromDate:today withFormat:@"dd"].intValue;
    int timeStringA = [self curentDateStringFromDate:today withFormat:@"mm"].intValue;
    int hoursStringA = [self curentDateStringFromDate:today withFormat:@"HH"].intValue;
    //NSLog(@"%@, %@, %@, %@", yearStringA, dayStringA, hoursStringA, timeStringA);
    
    NSString *yearStringB = [self curentDateStringFromDate:selectedData withFormat:@"MM-yyyy"];
    int dayStringB = [self curentDateStringFromDate:selectedData withFormat:@"dd"].intValue;
    //NSLog(@"%@, %@, %@, %@", yearStringB, dayStringB, hoursStringB, timeStringB);
    
    if(([paytime.titleLabel.text isEqualToString:@"definir hora"])||([paydate.titleLabel.text isEqualToString:@"definir data"])){
        [self.view makeToast:@"Campo Vazio, Por favor preencha" duration:3.0 position:CSToastPositionBottom];
        [paydate setTitle:@"definir data" forState:UIControlStateNormal];
        [paytime setTitle:@"definir hora" forState:UIControlStateNormal];
        payvw.hidden=YES;
        
    }else if([paydate.titleLabel.text isEqualToString:dateString]){
        [self.view makeToast:@"Não é possível agendar a entrega na data e hora pretendida." duration:3.0 position:CSToastPositionBottom];
        [paydate setTitle:@"definir data" forState:UIControlStateNormal];
        [paytime setTitle:@"definir hora" forState:UIControlStateNormal];
        payvw.hidden=YES;

    }else if([yearStringA isEqualToString:yearStringB] && dayStringB == dayStringA + 1 && (hoursStringA >= 19 && timeStringA >= 30)){
        [self.view makeToast:@"The time limit to order for the following day is 7.30 pm." duration:3.0 position:CSToastPositionBottom];
        [paydate setTitle:@"definir data" forState:UIControlStateNormal];
        [paytime setTitle:@"definir hora" forState:UIControlStateNormal];
        payvw.hidden=YES;
    }
    else{
      
       
       
        
      
        NSLog(@"key test sb=====: %@", subID_str);
        NSLog(@"key test sb=====: %@", subID_custom_str);
        NSLog(@"key test sb=====: %@", flagstr);
        NSLog(@"key test sb=====: %@", days);
        NSLog(@"key test sb=====: %@", custom_days);
        
        PaymentconfController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentconfController"];
        event.datestr=paydate.titleLabel.text;
        event.timestr=paytime.titleLabel.text;
        event.flagstr=flagstr;
        event.amt=[NSString stringWithFormat:@"%.02f",totalprice];
        
        if([flagstr isEqualToString:@"1"]){
            event.days=@"";
            event.subid=subID_str;
            
            if(subID_custom_str != nil && custom_days != nil){
                event.days = custom_days;
                event.subid = subID_custom_str;
            }
        }else{
            event.days=days;
            event.subid=subID_str;
        }

        

        [self.navigationController pushViewController:event animated:NO];

        [paydate setTitle:@"definir data" forState:UIControlStateNormal];
        [paytime setTitle:@"definir hora" forState:UIControlStateNormal];
        payvw.hidden=YES;
    }
}


-(void)altok:(id)sender{
    
    altvw.hidden=YES;
}
-(void)altcancel:(id)sender{
    altvw.hidden=YES;
    altvw1.hidden=NO;

}
-(void)altok1:(id)sender{
    
    [pricetxt resignFirstResponder];
    if([pricetxt.text length] <= 0||[pricetxt.text isEqualToString:@""]||[pricetxt.text isEqualToString:@"null"])
    {
        
        [self.view makeToast:@"Por favor introduza uma entrada diferente" duration:3.0 position:CSToastPositionCenter];
    }else{
        altvw1.hidden=YES;
        
        price=[pricetxt.text floatValue];
        custom_days = pricetxt.text;
        [self list1];
     //   [self loadData1];
      //  [self loadData];
    //    [self.tblPeople reloadData];
        pricetxt.text=@"";
    }
}
-(void)altcan1:(id)sender{
    pricetxt.text=@"";
    altvw1.hidden=YES;
    [pricetxt resignFirstResponder];

    
}
-(void)back:(id)sender{
 //   [self.navigationController popViewControllerAnimated:YES];
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SWRevealViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)deletebtn:(id)sender{
    
    // Prepare the query.
    NSString *query = [NSString stringWithFormat:@"delete from CardManager"];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    
    [self loadData];
}
-(void)subvwbtn:(id)sender{
    subvw.hidden=YES;
}

- (void)setAllElementofArrayToZero
{
   // for(int i = 0;i < numberOfTableRow ;i++)
  //  {
  //      [array addObject:[NSNumber numberWithInteger:1]];
   // }
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

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from CardManager";
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        // self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    // Reload the table view.
    if(self.arrPeopleInfo.count>0){
        numberOfTableRow = self.arrPeopleInfo.count;
        
        
        [self setAllElementofArrayToZero];
        self.tblPeople.hidden=NO;
    }else{
         self.tblPeople.hidden=YES;
        NSString *feestr1 =[NSString stringWithFormat:@"Total: %@ €",@"0.0"] ;
        NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:feestr1];
        NSRange range1 = [feestr1 rangeOfString:@"Total"];
        [attString1 addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range1];
        total_label.attributedText = attString1;
    }
  
}
-(void)loadData1{
    // Form the query.
    

    NSString *query = @"SELECT SUM(ProQuantity*ProPrice) FROM CardManager";
    
    NSString *rtestr;
    
    NSArray * arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSLog(@"totall %@",arrPeopleInfo);
    
    for (NSDictionary *try in arrPeopleInfo) {
        NSArray * ssss2=try;
        NSLog(@"totallllll %@",ssss2);
        for (NSDictionary *trry in ssss2) {
           rtestr=trry;
            NSLog(@"hhhhh %@",rtestr);
           
            
        }
    }
    totalprice =[rtestr floatValue];
            float to= totalprice*price;
            NSString *feestr1 =[NSString stringWithFormat:@"Total: %.02f €",to] ;
            NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:feestr1];
            NSRange range1 = [feestr1 rangeOfString:@"Total"];
            [attString1 addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range1];
            total_label.attributedText = attString1;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == subtable){
        return subary.count;
    }else if(tableView == timetable){
        return [timeary count];
    }else{
  //  tableView.separatorColor = [UIColor clearColor];
    return self.arrPeopleInfo.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == subtable){
        subtable.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *identifier = @"HistoryCell";
       HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     //   cell.lbl1.text=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:indexPath.row]valueForKey:@"FaqQuestion"]];
        cell.lbl1.text=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionName"]];
        cell.lbl2.text=[NSString stringWithFormat:@"%@ Dia(s)",[[subary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionDays"]];
        
        
        
        
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
    // Dequeue the cell.
        
        _tblPeople.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        
        
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
     NSInteger indexofPrice = [self.dbManager.arrColumnNames indexOfObject:@"ProPrice"];
    NSInteger indexofPname = [self.dbManager.arrColumnNames indexOfObject:@"ProductName"];
    NSInteger indexOfPquantity = [self.dbManager.arrColumnNames indexOfObject:@"ProQuantity"];
    NSInteger indexOfImage = [self.dbManager.arrColumnNames indexOfObject:@"ProductImage"];
    NSInteger indexOfId = [self.dbManager.arrColumnNames indexOfObject:@"ProductID"];
    NSString *proid=[NSString stringWithFormat:@"%@",[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfId]];
   
    cell.name.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexofPname]];
        [array addObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPquantity]];
        cell.count.text = [NSString stringWithFormat:@"%i",[[array objectAtIndex:indexPath.row] intValue]];

        //  [array addObject:cell.count.text];
        
        
        NSString *feestr =[NSString stringWithFormat:@"preço unitário       %@ €",[[productlist objectAtIndex:indexPath.row]valueForKey:@"ProductUnitPrice"]] ;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:feestr];
        NSRange range = [feestr rangeOfString:@"preço unitário"];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range];
        cell.price.attributedText = attString;
        
        NSString *str=[NSString stringWithFormat:@"%@", [[productlist objectAtIndex:indexPath.row]valueForKey:@"ProductPrice"]];
        float pc= [str floatValue];
        
        NSLog(@"price %ld",(long)indexofPrice);
        
        NSString *feestr1 =[NSString stringWithFormat:@"Montante Líquido    %.02f €",pc] ;
        NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:feestr1];
        NSRange range1 = [feestr1 rangeOfString:@"Montante Líquido"];
        [attString1 addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range1];
        cell.price1.attributedText = attString1;
        
        float to= [cell.count.text floatValue]*pc;
        NSLog(@"quantity %ld",(long)indexOfPquantity);

        NSString *feestr2 =[NSString stringWithFormat:@"Total   %.02f €",to] ;
        NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:feestr2];
        NSRange range2 = [feestr2 rangeOfString:@"Total"];
        [attString2 addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range2];
        cell.total.attributedText = attString2;
    
//    NSString *ssss3=[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfImage]];
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ssss3]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        cell.img.image = [UIImage imageWithData:data];
       //   }];
        
        NSString *ssss3=[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfImage]];
        NSLog(@"img %@",ssss3);
        ssss3  = [ssss3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        ssss3= [ssss3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:ssss3] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"bread_images.jpg"]]];
        
        

  
    //count increase
 // UIButton *  btn=(UIButton *)[cell viewWithTag:4];
       
        
        cell.delbtn.tag=indexPath.row;
        [cell.delbtn addTarget:self action:@selector(delbtn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *name= @"1";
    name = [NSString stringWithFormat:@"%i",[[array objectAtIndex:indexPath.row] intValue]];
    // Count.text=lbl2.text;
   // UIButton *  btn1=(UIButton *)[cell viewWithTag:7];
        cell.minbtn.tag=indexPath.row;
        [cell.minbtn addTarget:self action:@selector(minbtn:) forControlEvents:UIControlEventTouchUpInside];

        cell.plusbtn.tag=indexPath.row;
        [cell.plusbtn addTarget:self action:@selector(plusbtn:) forControlEvents:UIControlEventTouchUpInside];
          NSLog(@"rejkdj %@",array);
    return cell;
}
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==subtable){
        
    }else{
        
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
      
    }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == subtable){
        lbl1.text=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionName"]];
        lbl2.text=[NSString stringWithFormat:@"%@ Dia(s)",[[subary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionDays"]];
        days=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionDays"]];
        NSString *subid=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionDays"]];
        subID_str=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionID"]];
        NSLog(@"key test tableView didseelect low=====: %@", subID_str);
        int days=[subid intValue];
         subvw.hidden=YES;
        if((days <= 1)||(days==1)||(days==0)){
           
            
            flagstr=@"1";
            [self list];
            altvw.hidden=NO;
            [self loadData];
            
        }else{
        NSString *priceval=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:indexPath.row]valueForKey:@"SubscriptionDays"]];
        price= [priceval floatValue];
            if(proidary.count>0){
                flagstr=@"0";
                [self list];
                
               // [self loadData1];
                [self loadData];
            }
      
     //   [self.tblPeople reloadData];
       
        }
        
    }
    
    if(tableView == timetable){
        
        [paytime setTitle:[timeary objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        timevw.hidden=YES;
        
    }
}

-(void)delbtn:(UIButton *)sender
{
   //

    NSString *s1=[NSString stringWithFormat:@"%@",[newArray objectAtIndex:sender.tag]];

    // Prepare the query.
    NSString *query = [NSString stringWithFormat:@"delete from CardManager where ProductID=%@", s1];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
NSString *cval=[NSString stringWithFormat:@"%@",[[productlist objectAtIndex:sender.tag]valueForKey:@"ProductPrice"]];
    NSString *str=[newArray1 objectAtIndex:sender.tag];
       float count=([cval floatValue]*[str intValue]);
    totalprice= totalprice-count;
    NSString *feestr1 =[NSString stringWithFormat:@"Total: %.02f €",totalprice] ;
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:feestr1];
    NSRange range1 = [feestr1 rangeOfString:@"Total"];
    [attString1 addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range1];
    total_label.attributedText = attString1;
    
    [newArray removeObjectAtIndex:sender.tag];
    [self loadData];
    [self.tblPeople reloadData];
}

-(void)loadData2{
    // Form the query.
    newArray=[[NSMutableArray alloc]init];
   proidary= [[NSMutableArray alloc]init];
    NSString *query = @"select ProductID from CardManager";
    NSArray * arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

    // Get the results.
    if (arrPeopleInfo != nil) {
        // self.arrPeopleInfo = nil;
    }
    NSLog(@"ooooo %@",arrPeopleInfo);
    for (NSDictionary *result in arrPeopleInfo) {
        NSArray *aa=result;
        // NSLog(@"reultttt %@",aa);
        for (int i=0;i<[aa count];i++){
          NSMutableDictionary  *proidss = [[NSMutableDictionary alloc] init];

            NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                 [aa objectAtIndex:i]];
            NSLog(@"obje %@",tmpObject);
            [proidss setValue:tmpObject forKey:@"ID"];
            [proidary addObject:proidss];
           [newArray addObject: tmpObject];
            tmpObject=nil;
            
           
        }
       

    }
    
    newArray1=[[NSMutableArray alloc]init];
    NSString *query1 = @"select ProQuantity from CardManager";
    NSArray * arrPeopleInfo1 = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query1]];
    
    // Get the results.
    if (arrPeopleInfo1 != nil) {
        // self.arrPeopleInfo = nil;
    }
    NSLog(@"prqua %@",arrPeopleInfo1);
    for (NSDictionary *result in arrPeopleInfo1) {
        NSArray *aa=result;
        // NSLog(@"reultttt %@",aa);
        for (int i=0;i<[aa count];i++){
           
            
            NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                 [aa objectAtIndex:i]];
            [newArray1 addObject: tmpObject];
            tmpObject=nil;
            
            
        }
        
        
    }
    NSLog(@"prqua %@",newArray1);

  
}
-(void)plusbtn:(UIButton *)sender
{
  //  [self loadData2];
   // [array replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:sender.tag] intValue]+1 ]];
    NSLog(@"%@",array);

    NSInteger str=[[array objectAtIndex:sender.tag] intValue];
    
    if(str >=1){
        
        [array replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:sender.tag] intValue]+1 ]];
        
        
        
    }
    
    
    

    NSString *s1=[NSString stringWithFormat:@"%@",[newArray objectAtIndex:sender.tag]];
    NSString *quan=[NSString stringWithFormat:@"%i",[[array objectAtIndex:sender.tag] intValue]];
    int c=[quan intValue];

  NSString  *query = [NSString stringWithFormat:@"update CardManager set ProQuantity='%d' where ProductID='%@'",c,s1];
    [self.dbManager executeQuery:query];

    NSLog(@"%@",query);

    [self quant];
    [self loadData];
    [self.tblPeople reloadData];
    
}
-(void)quant{
    [self loadData2];
    float count=0;
    for(int i=0;i<productlist.count;i++){
        NSString *cval=[NSString stringWithFormat:@"%@",[[productlist objectAtIndex:i]valueForKey:@"ProductPrice"]];
        NSString *str=[newArray1 objectAtIndex:i];
        
        count=([cval floatValue]*[str intValue])+count;
        
        
    }
    totalprice= count;
    NSString *feestr1 =[NSString stringWithFormat:@"Total: %.02f €",totalprice] ;
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:feestr1];
    NSRange range1 = [feestr1 rangeOfString:@"Total"];
    [attString1 addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range1];
    total_label.attributedText = attString1;
}

-(void)minbtn:(UIButton *)sender
{
    NSInteger str=[[array objectAtIndex:sender.tag] intValue];
    if(str >1){
        [array replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:sender.tag] intValue]-1]];
        
    }
    NSString *s1=[NSString stringWithFormat:@"%@",[newArray objectAtIndex:sender.tag]];

    NSString *quan=[NSString stringWithFormat:@"%i",[[array objectAtIndex:sender.tag] intValue]];
    int c=[quan intValue];
    
    NSString  *query = [NSString stringWithFormat:@"update CardManager set ProQuantity='%d' where ProductID='%@'",c,s1];
    [self.dbManager executeQuery:query];
    
    NSLog(@"%@",query);
   // [self loadData2];
    [self quant];
    [self loadData];
    [self.tblPeople reloadData];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)show{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
   
    NSString *path = [NSString stringWithFormat:@"%@get_subscription", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);

    
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
                                                                      subary=[userdetails valueForKey:@"Subscriptionlist"];
                                                                      
                                                                      subtable.frame=CGRectMake(subtable.frame.origin.x, subtable.frame.origin.y, subtable.frame.size.width,50*subary.count);
                                                                      lbl1.text=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:2]valueForKey:@"SubscriptionName"]];
                                                                      lbl2.text=[NSString stringWithFormat:@"%@ Dia(s)",[[subary objectAtIndex:2]valueForKey:@"SubscriptionDays"]];
                                                                      NSString *priceval=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:2]valueForKey:@"SubscriptionDays"]];
                                                                   subID_str=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:2]valueForKey:@"SubscriptionID"]];
                                                                      NSLog(@"key test show=====: %@", subID_str);
                                                                      days=[NSString stringWithFormat:@"%@",[[subary objectAtIndex:2]valueForKey:@"SubscriptionDays"]];
                                                                      price= [priceval floatValue];
                                                                      
                                                                      if(proidary.count>0){
                                                                          [self list];
                                                                          
                                                                         // [self loadData1];
                                                                          [self loadData];
                                                                      }
                                                                      [subtable reloadData];

                                                                   
                                                                      }else{
                                                                          
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
-(void)list{
  
    productlist=[[NSMutableArray alloc]init];

    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:proidary options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"json %@",jsonData);
    NSError* error;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if([flagstr isEqualToString:@"1"]){
        
    }else{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    }
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@change_plan", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
     NSString *value = [NSString stringWithFormat:@"&subscription=%@&productids=%@",subID_str,jsonString];
     NSLog(@"value:%@",value);
     value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
  //  value = [value stringByReplacingOccurrencesOfString:@"%7B" withString:@"{"];
    //value = [value stringByReplacingOccurrencesOfString:@"%7D" withString:@"}"];

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
                                                                    
                                                                      NSLog(@"dictionary %@",userdetails);
                                                                      productlist=[userdetails valueForKey:@"Productlist"];
                                                                      float count=0;
                                                                      
                                                                      
                                                                          
                                                                      
                                                                      for(int i=0;i<productlist.count;i++){
                                                                          NSString *cval=[NSString stringWithFormat:@"%@",[[productlist objectAtIndex:i]valueForKey:@"ProductPrice"]];
                                                                          NSString *str=[newArray1 objectAtIndex:i];

                                                                          count=([cval floatValue]*[str intValue])+count;
                                                                        
                                                                      }
                                                                      if(self.arrPeopleInfo.count>0){
                                                                      totalprice= count;
                                                                      NSString *feestr1 =[NSString stringWithFormat:@"Total: %.02f €",totalprice] ;
                                                                      NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:feestr1];
                                                                      NSRange range1 = [feestr1 rangeOfString:@"Total"];
                                                                      [attString1 addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range1];
                                                                      total_label.attributedText = attString1;
                                                                      [self.tblPeople reloadData];
                                                                      }
                                                                  }else{
                                                                      
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



-(void)list1{
    
    productlist=[[NSMutableArray alloc]init];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:proidary options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"json %@",jsonData);
    NSError* error;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@insertsubscription", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&days=%@&productids=%@",pricetxt.text,jsonString];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"%7B" withString:@"{"];
    //value = [value stringByReplacingOccurrencesOfString:@"%7D" withString:@"}"];
    
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
                                                                      
                                                                      NSLog(@"dictionary %@",userdetails);
                                                                      productlist=[userdetails valueForKey:@"Productlist"];
                                                                      float count=0;
                                                                      for(int i=0;i<productlist.count;i++){
                                                                          NSString *cval=[NSString stringWithFormat:@"%@",[[productlist objectAtIndex:i]valueForKey:@"ProductPrice"]];
                                                                          NSString *str=[newArray1 objectAtIndex:i];
                                                                          
                                                                          count=([cval floatValue]*[str intValue])+count;
                                                                          
                                                                          
                                                                      }
                                                                      subID_custom_str = [userdetails valueForKey:@"SubscriptionID"];
                                                                      NSLog(@"key test list1=====: %@", subID_str);
                                                                      if(self.arrPeopleInfo.count>0){
                                                                      totalprice= count;
                                                                      NSString *feestr1 =[NSString stringWithFormat:@"Total: %.02f €",totalprice] ;
                                                                      NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:feestr1];
                                                                      NSRange range1 = [feestr1 rangeOfString:@"Total"];
                                                                      [attString1 addAttribute:NSForegroundColorAttributeName value:[UIColor  blackColor] range:range1];
                                                                      total_label.attributedText = attString1;
                                                                      [self.tblPeople reloadData];
                                                                      }
                                                                  }else{
                                                                      
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

//pickerview
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    
    return [inputarray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@" fgdfhj  ^00000000000000000 ");
    [sub_btn setTitle:[NSString stringWithFormat:@" %@",[inputarray objectAtIndex:row]] forState:UIControlStateNormal];
    sub_picker.hidden =YES;
    subID_str=[subId_arr objectAtIndex:row];
    NSLog(@"idddddd %@",subID_str);
    [self list];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    
    sub_str=[inputarray objectAtIndex:row];
    //        gender_value_str=gender_value_str1;
     NSString * ssss2=[subId_arr objectAtIndex:row];
    NSLog(@"idddddd %@",ssss2);
    NSLog(@" 0000000000&&&&&&&&&&&&&&&&ggggggg     1111111111111111%@",sub_str);
    
    return [inputarray objectAtIndex:row];
}


#pragma Mark -- IBActions
- (IBAction)subbutton:(id)sender {
    sub_picker.hidden = NO;
    subvw.hidden=NO;
   
}
-(IBAction)Pay:(id)sender{
    if([total_label.text isEqualToString:@"Total: 0.0 €"]){
        [self.view makeToast:@"Adicionar produto" duration:3.0 position:CSToastPositionBottom];
        
    }else{
    payvw.hidden=NO;
    }
 //   Confirmation_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Confirmation_ViewController"];
    
    
  //  [self.navigationController pushViewController:event animated:NO];
    
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
