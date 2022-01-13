//
//  Localization.swift
//  HostsX
//
//  Created by zm on 2021/12/17.
//

import Foundation

struct Localization {

    enum About {
        static let version = "about.version".localized
    }

    enum Error {
        static let invalidHosts = "error.invalidHosts".localized
        static let invalidURL = "error.invalidURL".localized
        static let compile = "error.compile".localized
        static let execute = "error.execute".localized
        static let cancelled = "error.cancelled".localized
    }

    enum Update {
        static let finished = "update.finished".localized
        static let succeeded = "update.succeeded".localized
        static let failed = "update.failed".localized
        static let unfinished = "update.unfinished".localized
    }

    enum Menu {
        static let local = "menu.local".localized
        static let remote = "menu.remote".localized
        static let remoteDownload = "menu.remote.download".localized
        static let remoteConfig = "menu.remote.config".localized
        static let help = "menu.help".localized
        static let helpCheck = "menu.help.check".localized
        static let helpAbout = "menu.help.about".localized
        static let quit = "menu.quit".localized
    }

    enum Hosts {
        static let alias = "hosts.alias".localized
        static let url = "hosts.url".localized
        static let origin = "hosts.origin".localized
        static let available = "hosts.available".localized
        static let unavailable = "hosts.unavailable".localized
        static let unknown = "hosts.unknown".localized
    }

    enum Dialog {
        static let cancel = "dialog.cancel".localized
        static let done = "dialog.done".localized
    }


    enum Remote {
        static let hosts = "remote.hosts".localized
        static let hostsOK = "remote.hosts.ok".localized
        static let aliasPrompt = "remote.alias.prompt".localized
        static let aliasPlaceholder = "remote.alias.placeholder".localized
        static let urlPlaceholder = "remote.url.placeholder".localized


        static let aliasPromptEmpty = "remote.alias.prompt.empty".localized
        static let aliasPromptInvalid = "remote.alias.prompt.invalid".localized
        static let aliasPromptExists = "remote.alias.prompt.exists".localized

        static let urlPromptEmpty = "remote.url.prompt.empty".localized
        static let urlPromptInvalid = "remote.url.prompt.invalid".localized
        static let urlPromptExists = "remote.url.prompt.exists".localized

        static func hostsConfirmOpen(_ alias: String) -> String {
            "remote.hosts.confirm.open".localized(alias)
        }
        static func hostsConfirmRemove(_ alias: String) -> String {
            "remote.hosts.confirm.remove".localized(alias)
        }
        static func hostsConfirmOrigin(_ alias: String) -> String {
            "remote.hosts.confirm.origin".localized(alias)
        }
    }
}

