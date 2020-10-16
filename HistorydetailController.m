//
//  HistorydetailController.m
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import "HistorydetailController.h"
#import "ItemCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface HistorydetailController (){
    NSMutableArray *products;
}

@end

@implementation HistorydetailController
@synthesize listary;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    products=[[NSMutableArray alloc]init];
    
    products=[listary valueForKey:@"product"];
    NSString *dateString = [listary valueForKey:@"OrderEndDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [dateFormatter stringFromDate:date];
    
  //  NSString *str=[NSString stringWithFormat:@"%u",[[listary valueForKey:@"product"] count]];
   // NSString *str1=[NSString stringWithFormat:@"%@",[listary valueForKey:@"OrderID"]];
    
   
    NSString *feestr3 =[NSString stringWithFormat:@"subscrição : %@",[listary valueForKey:@"SubscriptionName"]] ;
    NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:feestr3];
    NSRange range3 = [feestr3 rangeOfString:@"subscrição"];
    [attString3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:64/255.0f green:30/255.0f blue:7/255.0f alpha:1] range:range3];
    lbl2.attributedText = attString3;
    lbl3.text=[listary valueForKey:@"OrderCurrentStatus"];
    
    NSString *feestr4 =[NSString stringWithFormat:@"Custo da subscrição : %@ €",[listary valueForKey:@"Ordercost"]] ;
    NSMutableAttributedString *attString4 = [[NSMutableAttributedString alloc] initWithString:feestr4];
    NSRange range4 = [feestr4 rangeOfString:@"Custo da subscrição"];
    [attString4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:64/255.0f green:30/255.0f blue:7/255.0f alpha:1] range:range4];
    lbl4.attributedText = attString4;
    
    NSString *feestr5 =[NSString stringWithFormat:@"NR Entrega :  %@",[listary valueForKey:@"OrderNumDelivery"]] ;
    NSMutableAttributedString *attString5 = [[NSMutableAttributedString alloc] initWithString:feestr5];
    NSRange range5 = [feestr5 rangeOfString:@"Nr Entrega"];
    [attString5 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:64/255.0f green:30/255.0f blue:7/255.0f alpha:1] range:range5];
    lbl5.attributedText = attString5;
    
    NSString *feestr6 =[NSString stringWithFormat:@"Data de Início : %@",newDateString] ;
    NSMutableAttributedString *attString6 = [[NSMutableAttributedString alloc] initWithString:feestr6];
    NSRange range6 = [feestr6 rangeOfString:@"Data de Início"];
    [attString6 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:64/255.0f green:30/255.0f blue:7/255.0f alpha:1] range:range6];
   lbl6.attributedText = attString6;
    
    
   
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorColor = [UIColor clearColor];
    
    return [products count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 70;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    static NSString *identifier = @"ItemCell";
    ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text=[NSString stringWithFormat:@"%@",[[products objectAtIndex:indexPath.row]valueForKey:@"ProductName"]];
    cell.price.text=[NSString stringWithFormat:@"%@ €",[[products objectAtIndex:indexPath.row]valueForKey:@"ProductPrice"]];
    cell.count.text=[NSString stringWithFormat:@"%@ ",[[products objectAtIndex:indexPath.row]valueForKey:@"Productqty"]];

//    NSString *ssss3=[[products objectAtIndex:indexPath.row]valueForKey:@"ProductImage"];
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ssss3]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        cell.img.image = [UIImage imageWithData:data];
//    }];
    NSString *ssss3=[NSString stringWithFormat:@"%@", [[products objectAtIndex:indexPath.row]valueForKey:@"ProductImage"]];
    NSLog(@"img %@",ssss3);
    ssss3  = [ssss3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    ssss3= [ssss3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:ssss3] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"bread_images.jpg"]]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
