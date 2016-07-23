//
//  ViewController.m
//  JHCountLineNumberDemo
//
//  Created by 简豪 on 16/7/18.
//  Copyright © 2016年 codingMan. All rights reserved.
/*
 项目github地址为： https://github.com/China131/JHCodeLinesCountDemo.git
 本人博客：http://www.cnblogs.com/ToBeTheOne
 */

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (nonatomic,strong)NSMutableArray * pathArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _pathArr = [NSMutableArray array];
    
    /*        要计算项目的根目录 请根据您的需求添加url         */
    NSString *basePath = @"/Users/JH/Desktop/项目/公司项目/CRM资料/CRMCJ_JIANHAO/CRMCJ/Resource";
    
    /*        递归函数 递归并存储所有的.h .m .swift等代码文件        */
    [self recordFilePathWithPath:basePath];
    
    /*        总代码行数         */
    long allCount = 0;
    
    /*        遍历之前统计出来的文件目录  逐个计算行数         */
    for (NSString *path in _pathArr) {
        
        /*        将文件内容取出         */
        NSString * str = [NSString stringWithContentsOfFile:path encoding:kCFStringEncodingUTF8 error:nil];
        
        /*        根据换行符切割字符串 并存入数组         */
        NSArray * arr = [str componentsSeparatedByString:@"\n"];
        
        /*        数组个数         */
        NSInteger count = [arr count];
        
        /*        遍历切割的字符串数组         */
        for (NSString * lineStr in arr) {
            
            /*        当为注释文件时或者空白行时不添加         */
            if ([lineStr hasPrefix:@"//"]||([lineStr rangeOfString:@"/*"].length>0&&[lineStr rangeOfString:@"*/"].length>0)||[[lineStr componentsSeparatedByString:@" "] count]==lineStr.length+1) {
                
                count -- ;
                
            }
            
        }
        
        
        allCount += count;

    }
    
    
    /*        展示行数         */
    _showLabel.text = [NSString stringWithFormat:@"当前文件代码行数为：%ld 行",allCount];
}



#pragma mark---------------------->递归文件夹下文件
- (void)recordFilePathWithPath:(NSString *)path{

    /*        文件管理器         */
    NSFileManager *manager = [NSFileManager defaultManager];
    
    /*        该目录下文件存在的情况下  是否为文件夹bool值         */
    BOOL ret = NO;
   
    BOOL fileExist = [manager fileExistsAtPath:path isDirectory:&ret];
    
    /*        文件存在时         */
    if (fileExist) {
        
        /*        该目录为文件夹时         */
        if (ret) {
            
            /*        该目录下的所有文件         */
            NSArray *arr = [manager contentsOfDirectoryAtPath:path error:nil];
            
            for (NSString *secondPath in arr) {
                
                /*        拼接地址         */
                NSString *newPath = [path stringByAppendingPathComponent:secondPath];
                
                /*        递归文件夹下文件         */
                [self recordFilePathWithPath:newPath];
            }
            
        }else{
            
            /*        该目录为文件时 筛选出合适的文件  博主暂订这几种文件 当然还有.mm文件 如果您的项目中存在 可以添加上去         */
            if ([path hasSuffix:@".h"]||[path hasSuffix:@".m"]||[path hasSuffix:@".swift"]||[path hasSuffix:@".pch"]) {
                /*        将该目录添加到文件目录数组中         */
                [_pathArr addObject:path];
            }
            
        }
        
    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
