//
// Copyright (c) 2018 Emarsys. All rights reserved.
//

#import "MEDisplayedIAM.h"

@implementation MEDisplayedIAM {

}
- (instancetype)initWithCampaignId:(long)campaignId timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        _campaignId = campaignId;
        _timestamp = timestamp;
    }

    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToIam:other];
}

- (BOOL)isEqualToIam:(MEDisplayedIAM *)iam {
    if (self == iam)
        return YES;
    if (iam == nil)
        return NO;
    if (self.campaignId != iam.campaignId)
        return NO;
    if (self.timestamp != iam.timestamp && [self.timestamp timeIntervalSince1970] != [iam.timestamp timeIntervalSince1970])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = (NSUInteger) self.campaignId;
    hash = hash * 31u + [self.timestamp hash];
    return hash;
}


- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.campaignId=%ld", self.campaignId];
    [description appendFormat:@", self.timestamp=%@", self.timestamp];
    [description appendString:@">"];
    return description;
}

@end