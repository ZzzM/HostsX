//
//  Localization.swift
//  HostsX
//
//  Created by zm on 2021/12/17.
//

import Foundation

struct L10n {

    enum About {
        static let version = "about.version".localized
        static let check = "about.check".localized
    }

    enum Error {
        static let invalidURL = "error.invalidURL".localized
        static let scriptCompilation = "error.script.compilation".localized
        static let scriptExcution = "error.script.excution".localized
    }


    enum Menu {
        static let local = "menu.local".localized
        static let remote = "menu.remote".localized
        static let reset = "menu.reset".localized
        static let resetHint = "menu.reset.hint".localized

        static let about = "menu.about".localized
        static let quit = "menu.quit".localized
    }

    enum Button {
        static let cancel = "button.cancel".localized
        static let remove = "button.remove".localized
        static let save = "button.save".localized
        static let reset = "button.reset".localized
        static let open = "button.open".localized
        static let edit = "button.edit".localized
    }

    enum Source {
        static let tag = "source.tag".localized
        static let url = "source.url".localized


        static let tagHint = "source.tag.hint".localized
        static let tagPlaceholder = "source.tag.placeholder".localized
        static let tagEmpty = "source.tag.empty".localized
        static let tagInvalid = "source.tag.invalid".localized
        static let tagExists = "source.tag.exists".localized

        static let urlPlaceholder = "source.url.placeholder".localized
        static let urlEmpty = "source.url.empty".localized
        static let urlInvalid = "source.url.invalid".localized
        static let urlExists = "source.url.exists".localized

    }

    enum Remote {
        static let no = "remote.no".localized
        static let max = "remote.max".localized
        static func remove(_ tag: String) -> String {
            "remote.remove".localized(tag)
        }
    }

}

