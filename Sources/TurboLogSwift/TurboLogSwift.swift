import Foundation

public class TurboLogger {
    public static func configure(
        dailyRolling: Bool,
        maximumFileSize: UInt,
        maximumNumberOfFiles: UInt,
        logsDirectory: String,
        logsFilename: String
    ) throws {
        var error: NSError?
        TurboLog.configure(withDailyRolling: dailyRolling,
                          maximumFileSize: maximumFileSize,
                          maximumNumberOfFiles: maximumNumberOfFiles,
                          logsDirectory: logsDirectory,
                          logsFilename: logsFilename,
                          error: &error)
        if let error = error {
            throw error
        }
    }
    
    public static func deleteLogFiles() throws {
        try TurboLog.deleteFiles()
    }
    
    public static func getLogFilePaths() -> [String] {
        return TurboLog.getFilePaths()
    }
    
    public static func write(level: TurboLogLevel, message: Any...) {
        TurboLog.write(with: level, message: message)
    }
}
