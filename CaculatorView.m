

#import "CaculatorView.h"

@implementation CaculatorView
- (NSMutableArray *)digitalArray {
    if (_digitalArray == nil) {
        _digitalArray = [NSMutableArray array];
    }
    return _digitalArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self p_sdetupView];
    }
    return self;
}

- (void)p_sdetupView {
    _isOnOperator = NO;
    
    
    // 显示屏幕
    _showDigitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 375-9, 128)];
    _showDigitalLabel.font = [UIFont fontWithName:@"Menlo" size:29];
    _showDigitalLabel.backgroundColor = [UIColor colorWithRed:0.626 green:0.655 blue:0.971 alpha:0.5];
    _showDigitalLabel.text = @"0";
    _showDigitalLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_showDigitalLabel];
    
    
    // 数字按钮
    for (int i = 11; i >= 0; i--) {
        CGFloat x = 189 - i%3*(91 + 1);
        CGFloat y = 252 + i/3*(100 + 2);
       
        _digitalButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _digitalButton.frame = CGRectMake(x, y, 91, 100);
        _digitalButton.backgroundColor = [UIColor cyanColor];
        _digitalButton.titleLabel.font = [UIFont fontWithName:@"Menlo" size:40];
        _digitalButton.layer.cornerRadius = 10;
        [_digitalButton setTitle:[NSString stringWithFormat:@"%d", 9-i] forState:UIControlStateNormal];
        [_digitalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_digitalButton addTarget:self action:@selector(showDigital:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_digitalButton];
         if (i == 9) {
            [_digitalButton setTitle:@"=" forState:UIControlStateNormal];
             [_digitalButton removeTarget:self action:@selector(showDigital:) forControlEvents:UIControlEventTouchUpInside];
             [_digitalButton addTarget:self action:@selector(operatorDigital:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 10) {
            [_digitalButton setTitle:@"0" forState:UIControlStateNormal];
        }
        if (i == 11) {
            [_digitalButton setTitle:@"." forState:UIControlStateNormal];
        }
        
        
    }
    
    NSArray *operatorArray = [NSArray arrayWithObjects:@"+",@"-",@"×",@"÷", nil];
     // 运算符按钮
    for (int i = 0; i < 4; i++) {
        CGFloat x = 281;
        CGFloat y = 252 + i%4*(100 + 2);
        
        _operatorButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _operatorButton.frame = CGRectMake(x, y, 91, 100);
        _operatorButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.884 blue:0.441 alpha:1.000];
        _operatorButton.titleLabel.font = [UIFont fontWithName:@"Menlo" size:40];
        _operatorButton.layer.cornerRadius = 10;
        [_operatorButton setTitle:[operatorArray objectAtIndex:i] forState:UIControlStateNormal];
        [_operatorButton addTarget:self action:@selector(operatorDigital:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_operatorButton];
        
    }
    
    // 删除键按钮
    NSArray *deleteArr = [NSArray arrayWithObjects:@"%", @"+/-", @"c", @"mc",nil];
    for (int i = 0; i < 4; i++) {
        CGFloat x = 5 + i*(91 +1);
        CGFloat y = 150;
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteButton.frame = CGRectMake(x, y, 91, 100);
        _deleteButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.503 blue:0.888 alpha:1.000];
        _deleteButton.layer.cornerRadius = 10;
        _deleteButton.titleLabel.font = [UIFont fontWithName:@"Menlo" size:40];
        [_deleteButton setTitle:[deleteArr objectAtIndex:i] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteDigital:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [_deleteButton removeTarget:self action:@selector(deleteDigital:) forControlEvents:UIControlEventTouchUpInside];
            [_deleteButton addTarget:self action:@selector(operatorDigital:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:_deleteButton];
    }
}
// label显示结果
- (void)showDigital:(UIButton *)sender {
    // 获取当前按键值
    NSString *currentString = [sender titleForState:UIControlStateNormal];
    // label 显示是否为0 
    if ([_showDigitalLabel.text isEqualToString:@"0"]) {
        _showDigitalLabel.text = @"";
    }
    if ([currentString isEqualToString:@"."]) {
        currentString = @"";
        _showDigitalLabel.text = @"0.";  
    }
    // 获取当前label显示的数据
    NSString *laterString = [NSString stringWithString:_showDigitalLabel.text];   
    if (_isOnOperator == YES) {// 如果上一步点击了运算符，
            _isOnOperator = NO;// 
        }else {
            currentString = [laterString stringByAppendingString:currentString];// 如果没有点击，则把原有数据和当前按键值拼接
        }
    if(currentString.length < 21){// label只能显示20个数据 防止超出无法正常显示数据
         _showDigitalLabel.text = currentString;// label 显示当前按键值
    } 
}
// 四则运算
- (void)operatorDigital:(UIButton *)sender {
    // 如果上一次没有使用运算符按钮 且数据个数小于或等于一个
    if (_isOnOperator == NO && self.digitalArray.count <= 1) {
        _isOnOperator = YES;
        [self.digitalArray addObject:self.showDigitalLabel.text];// 向数组添加当前label显示值
    }
    
    if ( self.digitalArray.count > 1) {
        double i = 0;
        if([self.operator1 isEqualToString:@"+"]) {
                i = [self popDigital] + [self popDigital];
        }
        if([self.operator1 isEqualToString:@"-"]) {
            double a = [self popDigital];
            double b = [self popDigital];
            i = b - a;
        }
        if([self.operator1 isEqualToString:@"×"]) {
            i = [self popDigital] * [self popDigital];
        }
        if([self.operator1 isEqualToString:@"÷"]) {
            double a = [self popDigital];
            double b = [self popDigital];
            i = (a != 0 ? b / a : -1);
        }
        // % 运算
        if ([self.operator1 isEqualToString:@"%"]) {
            int a = [self popDigital];
            int b = [self popDigital];
            i =  b % a ;
        }

        [self.digitalArray removeAllObjects];// 清除所有数据
        self.showDigitalLabel.text = [self formatControl:[NSString stringWithFormat:@"%lf", i]];// 判断长度 去除无用的0
        if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"="]) {
            _isOnOperator = NO;
        }else {
            [self.digitalArray addObject:self.showDigitalLabel.text];
        }  
    }
    _operator1 = [NSString string];// 清空运算符
    _operator1 = [_operator1 stringByAppendingString:[sender titleForState:UIControlStateNormal]];// 赋予当前运算符
}
// 删除操作
- (void)deleteDigital:(UIButton *)sender {
    NSMutableString *tempStr = [NSMutableString stringWithString:self.showDigitalLabel.text];
    // 删除最后一个数字
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"mc"]&&tempStr.length != 0) {
        [tempStr deleteCharactersInRange:NSMakeRange((tempStr.length - 1), 1)];
        _showDigitalLabel.text = tempStr;
    }
    // 删除所有数字
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"c"]&&tempStr.length != 0) {
        _showDigitalLabel.text = @"";
        [self.digitalArray removeAllObjects]; // 清空数组
    }
    // 数字正负
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"+/-"]&&tempStr.length != 0) {
        NSString *tempU;
        if ([tempStr hasPrefix:@"-"]) {
             tempU = [tempStr substringFromIndex:1];
        }else {
            [tempStr insertString:@"-" atIndex:0];
        }
        self.showDigitalLabel.text = [self.showDigitalLabel.text hasPrefix:@"-"] ? tempU : tempStr;
    }
   
}
// 取出数组中的元素
- (double)popDigital {
    double i = [[_digitalArray lastObject] doubleValue];
    [_digitalArray removeObjectAtIndex:self.digitalArray.count - 1];
    return i;
}
// 判断长度
- (NSString *)formatControl:(NSString *)string {
    if (string.length > 20) {
        string = @"E";
    }else {// 长度不大于20 清除无用的零
        string = [self removeUselessToZero:string];
    }
    return string;
}
// 清除无用的零
- (NSString *)removeUselessToZero:(NSString *)string {
    if ([string rangeOfString:@"."].length == 0) {// 没有 .
        return string;
    }
    if ([string hasSuffix:@"0"]) {
        string = [string substringToIndex:string.length - 1];
        return [self removeUselessToZero:string]; // 使用递归
    }
    if ([string hasSuffix:@"."]) {// 删除 .
        string = [string substringToIndex:string.length - 1];
    }
    return  string;
}
@end
