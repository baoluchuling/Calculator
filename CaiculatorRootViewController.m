

#import "CaiculatorRootViewController.h"
#import "CaculatorView.h"
@interface CaiculatorRootViewController ()
@property (nonatomic, retain) CaculatorView *myView;
@end

@implementation CaiculatorRootViewController
- (void)loadView {
    _myView = [[CaculatorView alloc]init];
    self.view = _myView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.642 green:0.671 blue:0.999 alpha:1.000];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
