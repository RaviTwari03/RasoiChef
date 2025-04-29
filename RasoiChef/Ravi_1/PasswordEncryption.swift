import Foundation
import CommonCrypto

class PasswordEncryption {
    static let shared = PasswordEncryption()
    private let salt = "RasoiChefSalt123" // In production, use a secure random salt per user
    
    private init() {}
    
    func encryptPassword(_ password: String) -> String {
        let saltedPassword = password + salt
        
        guard let data = saltedPassword.data(using: .utf8) else {
            return ""
        }
        
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &hash)
        }
        
        return Data(hash).base64EncodedString()
    }
    
    func verifyPassword(_ password: String, against hashedPassword: String) -> Bool {
        let encryptedAttempt = encryptPassword(password)
        return encryptedAttempt == hashedPassword
    }
} 