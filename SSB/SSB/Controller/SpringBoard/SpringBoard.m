#import "SpringBoard.h"
#import "AppDelegate.h"
//#import "MyCardManage.h"
//#import "MyCardViewController.h"


#define ITME_MOVING_THRESHOLD (0.1) // second

@implementation SpringBoard

@synthesize items;
@synthesize title;

- (void)initTopBar
{
    UIImageView *topimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_title_logo.png"]];
    CGRect frame = CGRectMake(10, 12, topimage.frame.size.width, topimage.frame.size.height);
    topimage.frame = frame;
    [self addSubview:topimage];
    
    CGFloat btnHeight = 28;
    UIButton *btnTaoka = [UIButton buttonWithType:UIButtonTypeCustom];
	btnTaoka.frame = CGRectMake(246, (SP_TITLEBAR_HEIGHT - btnHeight) / 2, 69, btnHeight);
    btnTaoka.backgroundColor = [UIColor clearColor];
	[btnTaoka addTarget:self
                 action:@selector(btnTaokaClicked:)
       forControlEvents:UIControlEventTouchUpInside];
	[btnTaoka setImage:[UIImage imageNamed: @"btnTaoka.png"] forState:UIControlStateNormal];
    [btnTaoka setImage:[UIImage imageNamed: @"btnTaokaSel.png"] forState:UIControlStateSelected];
	[self addSubview:btnTaoka];
}

- (void)initScrollWithFrame:(CGRect)frame
                      items:(NSMutableArray *)menuItems
{
    // create a container view to put the menu items inside
    itemsContainer = [[UIScrollView alloc]
                                    initWithFrame:CGRectMake(0,
                                                             0,
                                                             frame.size.width,
                                                             frame.size.height)];
    itemsContainer.delegate = self;
    // NO backgroundColor, can't scroll!!!
    itemsContainer.backgroundColor = [UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:0xf7/255.0 alpha:1.0];
    [itemsContainer setScrollEnabled:YES];
    [itemsContainer setPagingEnabled:NO];
    
    int itemGap = SP_ITEMS_GAP;
    CGFloat startX = (frame.size.width - (MENUITEM_WIDTH * SP_ITEMS_PER_LINE) - (SP_ITEMS_PER_LINE - 1) * itemGap) / 2;
    CGFloat startY = startX;
    
    self.items = menuItems;
    int counter = 0;
    int itemInWidth = 0;
    int itemInHeight = 0;
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    for (SBMenuItem *item in self.items) {
        item.tag = counter;
        item.delegate = self;
        
        itemInWidth = counter % SP_ITEMS_PER_LINE;
        itemInHeight = counter / SP_ITEMS_PER_LINE;
        pointX = startX + itemInWidth * itemGap + itemInWidth * MENUITEM_WIDTH;
        pointY = startY + itemInHeight * itemGap + itemInHeight * MENUITEM_HEIGHT;
        [item setFrame:CGRectMake(pointX - DELETE_BTN_OFFSET, pointY - DELETE_BTN_OFFSET, MENUITEM_WIDTH + DELETE_BTN_OFFSET, MENUITEM_HEIGHT + DELETE_BTN_OFFSET)];
        [itemsContainer addSubview:item];
        counter++;
    }
    
    [itemsContainer setContentSize:CGSizeMake(frame.size.width ,(itemInHeight + 1) * (2 * itemGap + MENUITEM_HEIGHT))];
    
    [self addSubview:itemsContainer];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self
                                     action:@selector(clickBackground:)];
    [itemsContainer addGestureRecognizer:tapGr];
}

- (id)initWithTitle:(NSString *)boardTitle
               items:(NSMutableArray *)menuItems
               frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setUserInteractionEnabled:YES];
    if (self) {
        preToIndex = -1;
        isHolding = NO;
        isInEditingMode = NO;
        self.backgroundColor = [UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:0xf7/255.0 alpha:1.0];
        
        [self initScrollWithFrame:frame items:menuItems];
        [self initTopBar];
    }
    return self;
}


// transition animation function required for the springboard look & feel
- (CGAffineTransform)offscreenQuadrantTransformForView:(UIView *)theView {
    CGPoint parentMidpoint = CGPointMake(CGRectGetMidX(theView.superview.bounds), CGRectGetMidY(theView.superview.bounds));
    CGFloat xSign = (theView.center.x < parentMidpoint.x) ? -1.f : 1.f;
    CGFloat ySign = (theView.center.y < parentMidpoint.y) ? -1.f : 1.f;
    return CGAffineTransformMakeTranslation(xSign * parentMidpoint.x, ySign * parentMidpoint.y);
}

#pragma mark - MenuItem Delegate Methods

- (void)checkMove:(int)index point:(CGPoint)point
{
    SBMenuItem *moveingItem = [items objectAtIndex:index];
    CGPoint tempCenter;
    CGPoint preCenter = moveingItem.preCenter;
    int toIndex = -1;
    
    SBMenuItem *item;
    // XXX:not check addbtn
    for (int i = 0; i < [items count] - 1; i++) {
        // not check self
        if (i == index) {
            continue;
        }
        item = [items objectAtIndex:i];
        if (CGRectContainsPoint(item.frame, point)) {
            // need moving!
            toIndex = i;
            break;
        }
    }
    
    // check if place to white space, meaning move to be the last one
    if (toIndex < 0) {
        if (([items count] - 2) == index) {
            // the last one is self
            return;
        }
        // [items count] - 2: not check addbtn
        item = [items objectAtIndex:[items count] - 2];
        CGFloat leftRectOfLastItemX = item.frame.origin.x + item.frame.size.width;
        CGRect leftRectOfLastItem = CGRectMake(leftRectOfLastItemX,
                                               item.frame.origin.y,
                                               itemsContainer.contentSize.width - leftRectOfLastItemX,
                                               item.frame.size.height);
        CGFloat downRectOfLastItemY = item.frame.origin.y + item.frame.size.height;
        CGRect downRectOfLastItem = CGRectMake(0,
                                               downRectOfLastItemY,
                                               itemsContainer.contentSize.width,
                                               itemsContainer.contentSize.height - downRectOfLastItemY);
        if (CGRectContainsPoint(leftRectOfLastItem, point)
            || CGRectContainsPoint(downRectOfLastItem, point)) {
            toIndex = [items count] - 2;
        }
    }
    
    if (toIndex < 0) {
        return;
    }
    
    // ====start Threshold logic
    if (toIndex != preToIndex) {
        preToIndex = toIndex;
        self.preDate = [NSDate date];
        return;
    }
    
    if ([[NSDate date] timeIntervalSinceDate:self.preDate] < ITME_MOVING_THRESHOLD) {
        return;
    }
    preToIndex = -1;
    // ====end of Threshold logic
    
    // set new tag and position for movingItem
    item = [items objectAtIndex:toIndex];
    moveingItem.tag = item.tag;
    moveingItem.preCenter = item.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    if (index < toIndex) {
        for (int i = index + 1; i <= toIndex; i++) {
            item = [items objectAtIndex:i];
            tempCenter = item.center;
            item.center = preCenter;
            item.tag--;
            preCenter = tempCenter;
        }
        for (int i = index + 1; i <= toIndex; i++) {
            [items exchangeObjectAtIndex:i withObjectAtIndex:(i - 1)];
        }
    } else {
        for (int i = index - 1; i >= toIndex; i--) {
            item = [items objectAtIndex:i];
            tempCenter = item.center;
            item.center = preCenter;
            item.tag++;
            preCenter = tempCenter;
        }
        for (int i = index - 1; i >= toIndex; i--) {
            [items exchangeObjectAtIndex:i withObjectAtIndex:(i + 1)];
        }
    }
    // sync tag to card index
//    for (item in items) {
//        item.appData.index = item.tag;
//    }

    [UIView commitAnimations];
}

- (void)removeFromSpringboard:(int)index
{
    //[[MyCardManage shareInstance] removeACardWithIndex:index];
    
    // have a animation while disappearing
    SBMenuItem *menuItem = [items objectAtIndex:index];
    CGPoint preCenter = menuItem.center;
    CGPoint tempCenter;
    [menuItem removeFromSuperviewWithAnimate];
    
    // do rect moveing after index, do animate
    for (int i = index + 1; i < [items count]; i++) {
        menuItem = [items objectAtIndex:i];
        tempCenter = menuItem.center;
        [UIView animateWithDuration:0.2 animations:^{
            menuItem.center = preCenter;
        }];
        preCenter = tempCenter;
        menuItem.tag = menuItem.tag - 1;
    }
    
    //[(MyCardViewController *)menuItem.control updateBadge];
    [items removeObjectAtIndex:index];
    
    if (1 == [items count]) {
        [self disableEditingMode];
    }
}

- (SBMenuItem *)getMenuItemByApp:(AppData *)app
{
    for (SBMenuItem *item in items) {
        if (item.appData == app) {
            return item;
        }
    }
    return nil;
}

#pragma mark - Custom Methods

- (void)clickBackground:(UITapGestureRecognizer *)sender
{
    if (isHolding) {
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
        // UITapGestureRecognizer bug fix for iOS 5
        SBMenuItem *item;
        CGPoint point = [sender locationInView:self];
        // fix offset of scrollview
        point.y = point.y + itemsContainer.contentOffset.y;
        for (int i = 0; i < [items count]; i++) {
            item = [items objectAtIndex:i];
            if (CGRectContainsPoint(item.frame, point)) {
                [item clickItem:sender];
                return;
            }
        }
    }
    
    if (isInEditingMode) {
        [self disableEditingMode];
    }
}

- (void)disableEditingMode
{
    for (SBMenuItem *item in items) {
        [item disableEditing];
    }
    
    isInEditingMode = NO;
}

- (void)enableEditingMode
{
    for (SBMenuItem *item in items) {
        [item enableEditing];
    }
    
    isInEditingMode = YES;
}

//- (IBAction)btnTaokaClicked:(id)sender
//{
//    [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootToTaoka];
//}

- (void)startHolding
{
    for (SBMenuItem *item in items) {
        item.removeButton.enabled = NO;
    }
    
    isHolding = YES;
}

- (void)stopHolding
{
    for (SBMenuItem *item in items) {
        item.removeButton.enabled = YES;
    }
    
    preToIndex = -1;
    isHolding = NO;
}

- (BOOL)isHolding
{
    return isHolding;
}

@end
