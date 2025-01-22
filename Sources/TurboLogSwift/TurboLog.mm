#import "TurboLog.h"
#import <CocoaLumberjack/DDFileLogger.h>
#import <CocoaLumberjack/DDOSLogger.h>
#import <CocoaLumberjack/DDLogMacros.h>
#import "TurboLogFormatter.h"

static const DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface TurboLog()
+ (DDFileLogger *)fileLogger;
+ (void)setFileLogger:(DDFileLogger *)logger;
+ (NSString *)format:(NSArray *)messageArray;

@end

@interface CustomLogFileManager : DDLogFileManagerDefault
@property (nonatomic, strong) NSString *logFileName;
- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory logFileName:(NSString *)logFileName;
@end

static DDFileLogger *_fileLogger = nil;

@implementation TurboLog
+ (DDFileLogger *)fileLogger {
    return _fileLogger;
}

+ (void)setFileLogger:(DDFileLogger *)logger {
    _fileLogger = logger;
}

+ (void)configureWithDailyRolling:(BOOL)dailyRolling
                 maximumFileSize:(NSUInteger)maximumFileSize
            maximumNumberOfFiles:(NSUInteger)maximumNumberOfFiles
                  logsDirectory:(NSString *)logsDirectory
                  logsFilename:(NSString *)logsFilename
                         error:(NSError **)error {

    id<DDLogFileManager> fileManager;
    if (logsFilename && ![logsFilename isEqualToString:@""]) {
        fileManager = [[CustomLogFileManager alloc] initWithLogsDirectory:logsDirectory logFileName:logsFilename];
    } else {
        fileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logsDirectory];
    }
    fileManager.maximumNumberOfLogFiles = maximumNumberOfFiles;
    
    DDFileLogger* fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
    fileLogger.logFormatter = [[TurboLoggerFormatter alloc] init];
    fileLogger.rollingFrequency = dailyRolling ? 24 * 60 * 60 : 0;
    fileLogger.maximumFileSize = maximumFileSize;
    [DDLog removeAllLoggers];
    [DDLog addLogger:fileLogger];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    [DDLog addLogger:[[DDOSLogger alloc] initWithSubsystem:bundleIdentifier category:@"TurboLogger"]];
    [self setFileLogger:fileLogger];
}

+ (BOOL)deleteLogFiles:(NSError **)error {
    NSArray<DDLogFileInfo*> *files = [[self fileLogger].logFileManager unsortedLogFileInfos];
    for (DDLogFileInfo* file in files) {
        if (![[NSFileManager defaultManager] removeItemAtPath:file.filePath error:error]) {
            return NO;
        }
    }
    return YES;
}

+ (NSArray<NSString *> *)getLogFilePaths {
    return [self fileLogger].logFileManager.sortedLogFilePaths;
}

+ (void)writeWithLogLevel:(TurboLogLevel)logLevel message:(NSArray *)message {
    NSString *str = [self format:message];
    switch (logLevel) {
        case TurboLogLevelDebug:
            DDLogDebug(@"%@", str);
            break;
        case TurboLogLevelInfo:
            DDLogInfo(@"%@", str);
            break;
        case TurboLogLevelWarning:
            DDLogWarn(@"%@", str);
            break;
        case TurboLogLevelError:
            DDLogError(@"%@", str);
            break;
    }
}



+ (NSString *)format:(NSArray *)messageArray {
    NSMutableString *str = [NSMutableString string];
    for (id object in messageArray) {
        [str appendFormat:@" %@", object];
    }
    NSCharacterSet *charc = [NSCharacterSet characterSetWithCharactersInString:@" "];
    return [str stringByTrimmingCharactersInSet:charc];
}

@end

@implementation CustomLogFileManager

- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory logFileName:(NSString *)logFileName {
    self = [super initWithLogsDirectory:logsDirectory];
    if (self) {
        _logFileName = logFileName;
    }
    return self;
}

- (NSString *)newLogFileName {
    // From CocoaLumberjack/Sources/CocoaLumberjack/DDFileLogger.m
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat: @"yyyy'-'MM'-'dd'--'HH'-'mm'-'ss'-'SSS'"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@ %@.log", self.logFileName, dateString];
}

- (BOOL)isLogFile:(NSString *)fileName {
    return YES;
}

@end
