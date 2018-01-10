#import "Kiwi.h"
#import "MEIAMTriggerAppEvent.h"
#import "MEInAppMessageHandler.h"
#import "FakeInAppHandler.h"

SPEC_BEGIN(MEIAMTriggerAppEventTests)

    beforeEach(^{
    });

    describe(@"commandName", ^{

        it(@"should return 'triggerAppEvent'", ^{
            [[[MEIAMTriggerAppEvent commandName] should] equal:@"triggerAppEvent"];
        });

    });

    describe(@"handleMessage:resultBlock:", ^{

        it(@"should pass the eventName and payload to the given messageHandler's handleApplicationEvent:payload: method", ^{
            FakeInAppHandler *inAppHandler = [FakeInAppHandler mock];
            NSString *eventName = @"nameOfTheEvent";
            NSDictionary <NSString *, NSObject *> *payload = @{
                    @"payloadKey1": @{
                            @"payloadKey2": @"payloadValue"
                    }
            };
            NSDictionary *scriptMessage = @{
                    @"id": @1,
                    @"name": eventName,
                    @"payload": payload
            };

            MEIAMTriggerAppEvent *appEvent = [[MEIAMTriggerAppEvent alloc] initWithInAppMessageHandler:inAppHandler];

            [[inAppHandler should] receive:@selector(handleApplicationEvent:payload:) withArguments:eventName, payload];

            [appEvent handleMessage:scriptMessage
                        resultBlock:^(NSDictionary<NSString *, NSObject *> *result) {
                        }];
        });

        it(@"should receive success in resultBlock", ^{
            MEIAMTriggerAppEvent *appEvent = [MEIAMTriggerAppEvent new];

            XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
            __block NSDictionary<NSString *, NSObject *> *returnedResult;
            [appEvent handleMessage:@{@"name": @"name", @"id": @"123"}
                        resultBlock:^(NSDictionary<NSString *, NSObject *> *result) {
                            returnedResult = result;
                            [exp fulfill];
                        }];
            [XCTWaiter waitForExpectations:@[exp] timeout:30];

            [[returnedResult should] equal:@{@"success": @YES, @"id" : @"123"}];
        });

        it(@"should receive failure in resultBlock, when there is no name", ^{
            MEIAMTriggerAppEvent *appEvent = [MEIAMTriggerAppEvent new];

            XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
            __block NSDictionary<NSString *, NSObject *> *returnedResult;
            [appEvent handleMessage:@{@"id": @"123"}
                        resultBlock:^(NSDictionary<NSString *, NSObject *> *result) {
                            returnedResult = result;
                            [exp fulfill];
                        }];
            [XCTWaiter waitForExpectations:@[exp] timeout:30];

            [[returnedResult should] equal:@{@"success": @NO, @"id" : @"123", @"error": @"Missing name!"}];
        });

    });

SPEC_END


