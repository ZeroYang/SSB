#import <UIKit/UIKit.h>
#import "AppData.h"

// if Set button to minus frame,it will not get click event
// so make itmeView big ,set it to upleft corner
#define DELETE_BTN_OFFSET (10)

#define MENUITEM_WIDTH (150)
#define MENUITEM_HEIGHT (117)

#define MENUITEM_YUE_HEIGHT (25)

@protocol MenuItemDelegate <NSObject>
@optional

- (void)removeFromSpringboard:(int)index;
- (void)disableEditingMode;
- (void)enableEditingMode;
- (void)startHolding;
- (void)stopHolding;
- (BOOL)isHolding;
- (void)checkMove:(int)index point:(CGPoint)point;

@end

@interface SBMenuItem : UIView {
    BOOL isInEditingMode;
    BOOL isRemovable;
    
    UIImage *backGroundImage;
    UIImage *imageIcon ;
    UIImage *stausImage;
    UIImage *infoLine;
    BOOL isHolding;
    
//    id <MenuItemDelegate> delegate;
    BOOL isAddBtn;
    UILongPressGestureRecognizer *longPress;//weak ref
}

@property (nonatomic, strong) AppData *appData;//weak ref
@property (nonatomic, assign) CGPoint preCenter;//only for moving deal
@property (nonatomic, assign) id <MenuItemDelegate> delegate;
@property (nonatomic, assign) UIViewController *control;//weak ref
@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic, strong) UIProgressView *progressView;

- (id)initWithApp:(AppData *)app;

- (void)clickItem:(id)sender;
- (void)removeFromSuperviewWithAnimate;
- (void)enableEditing;
- (void)disableEditing;
- (void)enableHolding;
- (void)disableHolding;

@end