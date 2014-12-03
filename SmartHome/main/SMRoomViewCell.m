//
//  SMRoomViewCell.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-18.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SMRoomViewCell.h"

@implementation SMRoomViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if(highlighted)
    {
    }
    else
    {}
}

@end
