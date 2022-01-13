//
//  FileHelper.swift
//  HostsX
//
//  Created by zm on 2021/12/20.
//

import Foundation
import AppKit

struct FileHelper {

    static func localUpdate(completion: @escaping FailureClosure) {
        guard let url = open() else {
            return completion(HostsError.cancelled)
        }
        read(url, failure: completion) {
            do {
                try check($0)
                try write(to: .temp, contents: $0)
                try copy(atPath: HostsPath.temp, toPath: HostsPath.hosts)
                completion(.none)
            } catch {
                completion(error)
            }
        }
    }

    static func remoteUpdate(completion: @escaping FailureClosure) {
        guard let url = URL(string: RemoteSource.originUrl) else {
            return completion(HostsError.invalidURL)
        }
        read(url, failure: completion) {
            do {
                try check($0)
                try write(to: .temp, contents: join($0))
                try copy(atPath: HostsPath.temp, toPath: HostsPath.hosts)
                completion(.none)
            } catch {
                completion(error)
            }
        }
    }

}

extension FileHelper {


    private static func write(to url: URL, contents: String) throws {
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }

    private static func remove(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
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
        let _openPanel = NSOpenPanel()
        _openPanel.allowsMultipleSelection = false
        _openPanel.canChooseDirectories = false
        _openPanel.canCreateDirectories = false
        _openPanel.canChooseFiles = true
        return _openPanel.runModal() == .OK ? _openPanel.url : .none
    }

    private static func copy(atPath: String, toPath: String) throws {
        let appleScript = NSAppleScript(command: "cp -f \(atPath) \(toPath)")
        try appleScript.doShell()
    }

    private static func check(_ content: String) throws {
        guard content.contains("localhost"), content.contains("127.0.0.1") else {
            throw HostsError.invalidHosts
        }
    }

    private static func join(_ content: String) throws -> String {

        let joined = """
        \(HostsTag.start)

        \(HostsTag.flag)

        \(HostsTag.end)

        \(content)
        """
        guard
            let hosts = try? String(contentsOfFile: HostsPath.hosts),
            let startIndex = hosts.range(of: HostsTag.start)?.upperBound,
            let endIndex = hosts.range(of: HostsTag.end)?.lowerBound else{
                return joined
            }

        let myHosts = hosts[startIndex..<endIndex].trimmingCharacters(in: .whitespacesAndNewlines)

        return  joined.replacingOccurrences(of: HostsTag.flag, with: myHosts)

    }
}


