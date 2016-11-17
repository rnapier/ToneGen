//
//  Log.swift
//  audio
//
//  Created by Rob Napier on 4/21/16.
//  Copyright © 2016 Jaybird LLC. All rights reserved.
//
//  Based on SlimLogger: https://github.com/melke/SlimLogger
//  Converted to provide more structured logging.

import Foundation

// Swift naming rules now require lowercase for enum cases (they're not types)
// swiftlint:disable type_name
public enum LogLevel: Int {
    case trace  = 100
    case debug  = 200
    case info   = 300
    case warn   = 400
    case error  = 500
    case fatal  = 600

    var string: String {
        switch self {
        case .trace:
            return "TRACE"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warn:
            return "WARN"
        case .error:
            return "ERROR"
        case .fatal:
            return "FATAL"
        }
    }
}
// swiftlint:enable type_name

public struct LogLocation {
    let file: String
    let line: Int
    let function: String
}

let noLogLocation = LogLocation(file: "", line: 0, function: "")

protocol LogDestination {
    func log(_ message: String, data: () -> [String : Any], level: LogLevel, location: LogLocation)
    func flush()
}

final class Log {
    fileprivate init() {}

    // Keys for data dictionary. Try to keep these broad enough for reuse.
    // If it's "the obvious thing named in the message," just use objectKey rather than creating a new key.
    static let endpointKey = "endpoint"
    static let errorKey = "error"
    static let fromKey = "from"
    static let nameKey = "name"
    static let optionsKey = "options"
    static let pathKey = "path"
    static let responseKey = "response"
    static let objectsKey = "objs"
    static let objectKey = "obj"
    static let toKey = "to"

    static let log = Log()

    var destinations: [LogDestination] = []
    let cleanedFilenamesCache = NSCache<AnyObject, AnyObject>()

    static func addDestination(_ destination: LogDestination) {
        log.destinations.append(destination)
    }

    static func trace(_ message: String, data: @autoclosure () -> [String : Any] = [:], file: String = #file, line: Int = #line, function: String = #function) {
        log.logInternal(message, data: data, level: .trace, file: file, line: line, function: function)
    }

    static func debug(_ message: String, data: @autoclosure () -> [String : Any] = [:], file: String = #file, line: Int = #line, function: String = #function) {
        log.logInternal(message, data: data, level: .debug, file: file, line: line, function: function)
    }

    static func info(_ message: String, data: @autoclosure () -> [String : Any] = [:], file: String = #file, line: Int = #line, function: String = #function) {
        log.logInternal(message, data: data, level: .info, file: file, line: line, function: function)
    }

    static func warn(_ message: String, data: @autoclosure () -> [String : Any] = [:], file: String = #file, line: Int = #line, function: String = #function) {
        log.logInternal(message, data: data, level: .warn, file: file, line: line, function: function)
    }

    static func error(_ message: String, data: @autoclosure () -> [String : Any] = [:], file: String = #file, line: Int = #line, function: String = #function) {
        log.logInternal(message, data: data, level: .error, file: file, line: line, function: function)
    }

    // Fatals should go through something else like fatalError.
    fileprivate static func fatal(_ message: String, data: @autoclosure () -> [String : Any] = [:], file: String = #file, line: Int = #line, function: String = #function) {
        log.logInternal(message, data: data, level: .fatal, file: file, line: line, function: function)
        log.flush()
    }

    // Assertions. Log, then assert (means duplicate message in Develop, but makes sure we get the message in QA).
    static func assert(_ condition: Bool, _ message: String, data: @autoclosure () -> [String : Any] = [:], file: StaticString = #file, line: Int = #line, function: String = #function) {
        if !condition {
            Log.assertionFailure(message, data: data, file: file, line: line, function: function)
        }
    }

    static func assertionFailure(_ message: String = "", data: @autoclosure () -> [String : Any] = [:], file: StaticString = #file, line: Int = #line, function: String = #function) {
        Log.fatal(message, data: data, file: String(describing: file), line: line)
        Swift.assertionFailure(message, file: file, line: UInt(line))
    }

    // Fatal errors. Log, then fatal.
    static func precondition(_ condition: Bool, _ message: String = "", data: @autoclosure () -> [String : Any] = [:], file: StaticString = #file, line: Int = #line, function: String = #function) {
        if !condition {
            Log.preconditionFailure(message, data: data, file: file, line: line, function: function)
        }
    }

    static func preconditionFailure(_ message: String = "", data: @autoclosure () -> [String : Any] = [:], file: StaticString = #file, line: Int = #line, function: String = #function) -> Never {
        Log.fatal(message, data: data, file: String(describing: file), line: line)
        Swift.preconditionFailure(message, file: file, line: UInt(line))
    }

    static func fatalError(_ message: String = "", data: @autoclosure () -> [String : Any] = [:], file: StaticString = #file, line: Int = #line, function: String = #function) -> Never {
        fatal(message, data: data, file: String(describing: file), line: line, function: function)
        Swift.fatalError(message, file: file, line: UInt(line))
    }

    func flush() {
        for destination in destinations {
            destination.flush()
        }
    }

    // swiftlint:disable:next function_parameter_count
    fileprivate func logInternal(_ message: String, data: () -> [String : Any], level: LogLevel, file: String, line: Int, function: String) {
        let cleanedfile = cleanedFilename(String(file))
        let location = LogLocation(file: cleanedfile, line: line, function: function)
        for dest in destinations {
            dest.log(message, data: data, level: level, location: location)
        }
    }

    fileprivate func cleanedFilename(_ filename: String) -> String {
        if let cleanedfile = cleanedFilenamesCache.object(forKey: filename as AnyObject) as? String {
            return cleanedfile
        } else {
            let items = filename.characters.split(omittingEmptySubsequences: true, whereSeparator: { $0 == "/" }).map { String($0) }
            let retval = items.last ?? ""
            cleanedFilenamesCache.setObject(retval as AnyObject, forKey:filename as AnyObject)
            return retval
        }
    }
}

// Wrappers for ObjC. While these are identical to Log, they allow us to evolve Log without breaking ObjC compatibility
// Note that it is currently impossible to get correct file/line into the fatalError calls, since ObjC can't generate the
// StaticString that Swift requires. But the correct error will be in the log.
@objc class JAYLog: NSObject {
    @objc class func fatalError(_ message: String, data: [String: Any], file: String, line: Int, function: String) {
        Log.fatal(message, data: data, file: file, line: line)
        Swift.fatalError(message)
    }

    @objc class func assertionFailure(_ message: String, data: [String: Any], file: String, line: Int, function: String) {
        Log.fatal(message, data: data, file: file, line: line)
        Swift.assertionFailure(message)
    }

    @objc class func error(_ message: String, data: [String: Any], file: String, line: Int, function: String) {
        Log.error(message, data: data, file: file, line: line)
    }

    @objc class func warn(_ message: String, data: [String: Any], file: String, line: Int, function: String) {
        Log.warn(message, data: data, file: file, line: line)
    }

    @objc class func info(_ message: String, data: [String: Any], file: String, line: Int, function: String) {
        Log.info(message, data: data, file: file, line: line)
    }

    @objc class func debug(_ message: String, data: [String: Any], file: String, line: Int, function: String) {
        Log.debug(message, data: data, file: file, line: line)
    }

    @objc class func trace(_ message: String, data: [String: Any], file: String, line: Int, function: String) {
        Log.trace(message, data: data, file: file, line: line)
    }

}
