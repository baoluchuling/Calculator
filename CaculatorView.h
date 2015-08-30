

#import <UIKit/UIKit.h>

@interface CaculatorView : UIView
@property (nonatomic, retain) UIButton *digitalButton;
@property (nonatomic, retain) UIButton *operatorButton;
@property (nonatomic, retain) UIButton *deleteButton;

@property (nonatomic, retain) UILabel *showDigitalLabel;

@property (nonatomic, retain) NSMutableArray *digitalArray;
@property (nonatomic, retain) NSString *operator1;
@property (nonatomic, assign) BOOL isOnOperator;
@end
