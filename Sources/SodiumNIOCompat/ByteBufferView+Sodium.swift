//
//  ByteBufferView+Sodium.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import struct NIOCore.ByteBufferView

#if compiler(>=6)
extension ByteBufferView: @retroactive Sodium.DataProtocol { }
#else
extension ByteBufferView: Sodium.DataProtocol { }
#endif
