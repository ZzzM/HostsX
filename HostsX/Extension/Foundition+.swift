//
//  Foundition+.swift
//  HostsX
//
//  Created by zm on 2021/12/15.
//

import Foundation

extension NSObject {
    var className: String { String(describing: type(of: self)) }
    static var className: String { String(describing: self) }
}

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }

    func localized(_ arg: String) -> String { String(format: localized, arg) }
}

extension NSAppleScript {

    convenience init?(command: String) {
        let source = """
        do shell script \
        "\(command)" \
        with administrator privileges
        """
        self.init(source: source)
    }

}

extension Optional where Wrapped == NSAppleScript {
    func doShell() throws {
        var errorInfo : NSDictionary?
        guard let appleScript = self else {
            throw HostsError.compile
        }
        appleScript.executeAndReturnError(&errorInfo)

        guard let errorMessage = errorInfo?["NSAppleScriptErrorMessage"]  as? String else {
            return
        }

        switch errorInfo?["NSAppleScriptErrorNumber"]  as? Int {
        case -128: throw HostsError.cancelled
        default: throw HostsError.execute(errorMessage)
        }

    }
}

extension Error {

    var code: Int {
        (self as NSError).code
    }

    var isCancelled: Bool {
        -999 == code
    }
}

extension Date {

    private var calendar: Calendar {
        Calendar.current
    }

    var year: Int {
        calendar.component(.year, from: self)
    }

}
