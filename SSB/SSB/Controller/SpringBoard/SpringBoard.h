#import <UIKit/UIKit.h>
#import "SBMenuItem.h"

#define SP_TITLEBAR_HEIGHT (44)
#define SP_ITEMS_PER_LINE (2)
#define SP_ITEMS_GAP (5)

@interface SpringBoard : UIView <MenuItemDelegate, UIScrollViewDelegate> {
    BOOL isInEditingMode;
    UIScrollView *itemsContainer;
    BOOL isHolding;// if a item is in holding mode
    
    //record for moving Threshold time
    int preToIndex;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSDate *preDate;

- (id)initWithTitle:(NSString *)boardTitle
              items:(NSMutableArray *)menuItems
              frame:(CGRect)frame;

- (SBMenuItem *)getMenuItemByApp:(AppData *)app;

@end
