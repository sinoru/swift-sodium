//
//  Sodium.swift
//
//
//  Created by Jaehong Kang on 8/12/24.
//

import Clibsodium

public struct Sodium {
    public static func initialize() throws {
        guard sodium_init() != -1 else {
            throw Error.cannotInitialize
        }
    }
}
