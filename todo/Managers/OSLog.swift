//
//  OSLog.swift
//  todo
//
//  Created by Юлия Тепаева on 23.11.2023.
//

import OSLog
//swiftlint:disable:next prefixed_toplevel_constant
let log = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "common")
