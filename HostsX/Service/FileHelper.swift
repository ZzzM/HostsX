//
//  FileHelper.swift
//  HostsX
//
//  Created by zm on 2021/12/20.
//

import AppKit

struct FileHelper {


    static let defaultHosts = """
        ##
        # Host Database
        #
        # localhost is used to configure the loopback interface
        # when the system is booting.  Do not change this entry.
        ##
        127.0.0.1    localhost
        255.255.255.255    broadcasthost
        ::1             localhost
        """


    static func reset(completion: @escaping FailureClosure) {
        do {
            try checkAndCreate(at: HXPath.temporary)
            try write(to: HXPath.tmpHosts, contents: defaultHosts)
            try copy(tmp: HXPath.tmpHosts, sys: HXPath.hosts)
        } catch {
            completion(error)
        }
    }


    static func localUpdate(completion: @escaping FailureClosure) {
        guard let url = open() else {
            return
        }
        read(url, failure: completion) {
            do {
                try checkAndCreate(at: HXPath.temporary)
                try write(to: HXPath.tmpHosts, contents: $0)
                try copy(tmp: HXPath.tmpHosts,
                         old: HXPath.oldHosts,
                         sys: HXPath.hosts)
            } catch {
                completion(error)
            }
        }
    }

    static func remoteUpdate(completion: @escaping FailureClosure) {
        guard let urlString = DataSource.default?.url else {
            return completion(HXError.invalidURL)
        }
        guard let url = URL(string: urlString) else {
            return completion(HXError.invalidURL)
        }
        read(url, failure: completion) {
            do {
                try checkAndCreate(at: HXPath.temporary)
                try write(to: HXPath.tmpHosts, contents: join($0))
                try copy(tmp: HXPath.tmpHosts,
                         old: HXPath.oldHosts,
                         sys: HXPath.hosts)
                completion(.none)
            } catch {
                completion(error)
            }
        }
    }

}

extension FileHelper {


    private static func checkAndCreate(at path: String) throws {

        var isDirectory = ObjCBool(true)
        var willCreate = true

        if FileManager.default.fileExists(atPath: path, isDirectory:&isDirectory) {
            if isDirectory.boolValue {
                willCreate  = false
            } else {
                try remove(at: path)
            }
        }
        guard willCreate else { return }
        try FileManager.default.createDirectory(atPath: path,
                                            withIntermediateDirectories: false)
    }



    private static func write(to path: String, contents: String) throws {
        try contents.write(toFile: path, atomically: true, encoding: .utf8)
    }

    private static func remove(at path: String) throws {

        try FileManager.default.removeItem(atPath: path)
    }

    private static func read(_ url: URL,
                             failure: @escaping FailureClosure,
                             success: @escaping ReusltClosure) {
        DispatchQueue.global().async {
            do {
                //sleep(5)
                let content = try String(contentsOf: url)
                DispatchQueue.main.async {
                    success(content)
                }
            } catch {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }

    private static func open() -> URL? {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        return .OK == panel.runModal() ? panel.url : .none
    }


    private static func copy(tmp: String, sys: String) throws {
        let appleScript = NSAppleScript(command: "cp -f \(tmp) \(sys)")
        try appleScript.execute()
    }

    private static func copy(tmp: String, old: String, sys: String) throws {
        let command = """
        cp -f \(sys) \(old)
        cp -f \(tmp) \(sys)
        """
        let appleScript = NSAppleScript(command: command)
        try appleScript.execute()
    }


    private static func join(_ content: String) throws -> String {

        let joined = """
        \(HXTag.start)

        \(HXTag.flag)

        \(HXTag.end)

        \(content)
        """

        guard let hosts = try? String(contentsOfFile: HXPath.hosts),
              let startIndex = hosts.range(of: HXTag.start)?.upperBound,
              let endIndex = hosts.range(of: HXTag.end)?.lowerBound else{
            return joined
        }

        let myHosts = hosts[startIndex..<endIndex].trimmingCharacters(in: .whitespacesAndNewlines)

        return  joined.replacingOccurrences(of: HXTag.flag, with: myHosts)

    }
}


