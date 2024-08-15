//
//  SodiumSecretBox.swift
//
//
//  Created by Jaehong Kang on 8/15/24.
//

@_exported import protocol SodiumCore.AEADCipher
@_exported import struct SodiumCore.DataSize
@_exported import struct SodiumCore.Sodium
@_exported import struct SodiumCore.SymmetricKey

public typealias XSalsa20Poly1305 = SecretBoxXSalsa20Poly1305
public typealias XChaCha20Poly1305 = SecretBoxXChaCha20Poly1305
