//
//  Data+Sodium.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import struct Foundation.Data

#if compiler(>=6)
extension Data: @retroactive Sodium.DataProtocol { }
#else
extension Data: Sodium.DataProtocol { }
#endif
