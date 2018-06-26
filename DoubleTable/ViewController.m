//
//  ViewController.m
//  DoubleTable
//
//  Created by HanOBa on 2018/6/26.
//  Copyright © 2018年 HanOBa. All rights reserved.
//

#import "ViewController.h"


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define kNum 10

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong)UITableView *leftTable;
@property (nonatomic,strong)UITableView *rightTable;

@property (nonatomic, strong) NSIndexPath * currentIndexPath;//记录当前IndexPath
@end

@implementation ViewController



#pragma mark - Init
-(UITableView *)leftTable{
    
    if (!_leftTable) {
        _leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth / 3.0, kHeight) style:(UITableViewStylePlain)];
        _leftTable.delegate = self;
        _leftTable.dataSource = self;
        [self.view addSubview:_leftTable];
    }
    return _leftTable;
}

-(UITableView *)rightTable{
    
    if (!_rightTable) {
        _rightTable = [[UITableView alloc]initWithFrame:CGRectMake(kWidth / 3.0, 64, kWidth / 3.0 * 2, kHeight - 64) style:(UITableViewStylePlain)];
        _rightTable.delegate = self;
        _rightTable.dataSource = self;
        [self.view addSubview:_rightTable];
    }
    return _rightTable;
}



#pragma mark - ViewDidload
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TableView双联动";
    
    //Regist
    [self.leftTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"left"];
    
    [self.rightTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"right"];
    
    
    //Mark
    _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}


#pragma mark - Table Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _leftTable) {
        
        return 1;
    }
    return kNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _leftTable) {
        
        return kNum;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _leftTable) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Left = %ld",indexPath.row + 1];
        
        if (indexPath.row == _currentIndexPath.section) {
            cell.textLabel.textColor = [UIColor greenColor];
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
        }
        
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }else if (tableView == _rightTable){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"right" forIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Right = %ld",indexPath.section + 1];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _leftTable) {
        
        return 60;
    }else if (tableView == _rightTable){
        
        return 50;
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _rightTable) {
        
        UIView *head = [[UIView alloc]init];
        head.backgroundColor = [UIColor lightGrayColor];
        return head;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == _rightTable) {
        return 20.0f;
    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _leftTable) {
        
        _currentIndexPath = indexPath;
        [tableView reloadData];
        [_rightTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    }
}



#pragma mark - Scroll Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _rightTable) {

        NSIndexPath * indexPath = [_rightTable indexPathForRowAtPoint:scrollView.contentOffset];
        _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [_leftTable reloadData];
        [_leftTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}



#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
