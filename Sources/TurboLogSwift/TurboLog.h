#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TurboLogLevel) {
    TurboLogLevelDebug,
    TurboLogLevelInfo,
    TurboLogLevelWarning,
    TurboLogLevelError
};

@interface TurboLog : NSObject

+ (void)configureWithDailyRolling:(BOOL)dailyRolling
                 maximumFileSize:(NSUInteger)maximumFileSize
            maximumNumberOfFiles:(NSUInteger)maximumNumberOfFiles
                  logsDirectory:(NSString *)logsDirectory
                  logsFilename:(NSString *)logsFilename
                         error:(NSError **)error;

+ (BOOL)deleteLogFiles:(NSError **)error;
+ (NSArray<NSString *> *)getLogFilePaths;
+ (void)writeWithLogLevel:(TurboLogLevel)logLevel message:(NSArray * _Nonnull)message;

@end

NS_ASSUME_NONNULL_END
