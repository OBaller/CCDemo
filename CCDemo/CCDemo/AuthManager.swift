//
//  AuthManager.swift
//  CCDemo
//
//  Created by naseem on 06/12/2021.
//

import FirebaseAuth
import Foundation

class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private var verificationId: String?
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                completion(false)
                return
            }
            self?.verificationId = verificationId
            completion(true)
        }
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = verificationId else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func validateLogin(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        auth.signIn(withEmail: email, password: password) {_, error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func UserSignUp(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
    auth.createUser(withEmail: email, password: password) { authResult, error in
      
    }
    }
}
