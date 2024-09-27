//
//  AesHelper.swift
//  Runner
//
//  Created by Lam Nguyen Tuan on 27/9/24.
//

import Foundation
import CryptoSwift

class AesHelper {
    // AES algorithm and configuration constants
    private static let ALGORITHM = "AES"
    private static let TRANSFORMATION = "AES/CBC/PKCS5"
    
    // Generates a secret key from a string
    private func generateSecretKey(secretKey: String) -> [UInt8] {
        return Array(secretKey.utf8)
    }
    
    // Generates an IV key from a string
    private func generateIvKey(ivKey: String) -> [UInt8] {
        return Array(ivKey.utf8)
    }
    
    // Encrypt method using AES
    func encrypt(value: String, privateKey: String, ivKey: String) -> String? {
        do {
            let ivBytes = generateIvKey(ivKey: ivKey) // Convert IV key to bytes
            let secretKeyBytes = generateSecretKey(secretKey: privateKey) // Convert secret key to bytes
            
            let aes = try AES(key: secretKeyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs5)
            let encryptedBytes = try aes.encrypt(Array(value.utf8)) // Encrypt the input value
            
            let encryptedData = Data(encryptedBytes)
            return encryptedData.base64EncodedString() // Return the Base64 encoded encrypted string
        } catch {
            print("Encryption error: \(error)")
            return nil
        }
    }
    
    // Decrypt method using AES
    func decrypt(value: String, privateKey: String, ivKey: String) -> String? {
        do {
            let ivBytes = generateIvKey(ivKey: ivKey) // Convert IV key to bytes
            let secretKeyBytes = generateSecretKey(secretKey: privateKey) // Convert secret key to bytes
            
            let aes = try AES(key: secretKeyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs5)
            
            guard let encryptedData = Data(base64Encoded: value) else { return nil }
            let encryptedBytes = Array(encryptedData)
            
            let decryptedBytes = try aes.decrypt(encryptedBytes) // Decrypt the data
            
            return String(bytes: decryptedBytes, encoding: .utf8) // Convert decrypted bytes to string
        } catch {
            print("Decryption error: \(error)")
            return nil
        }
    }
}
