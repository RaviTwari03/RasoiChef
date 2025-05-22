//
//  RazorpayManager.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 22/05/25.
//


import SwiftUI
import Razorpay

class RazorpayManager: NSObject, ObservableObject, RazorpayPaymentCompletionProtocol, ExternalWalletSelectionProtocol {
    static let shared = RazorpayManager()
    @Published var paymentStatus: String = "none"
    private var razorpay: RazorpayCheckout!
    private var onSuccess: ((String) -> Void)?
    private var onFailure: ((String) -> Void)?
    let keyId = "rzp_test_SbggbeJP3exx2F"
    
    override init() {
        super.init()
        setupRazorpay()
    }
    
    private func setupRazorpay() {
        razorpay = RazorpayCheckout.initWithKey(keyId, andDelegate: self)
        razorpay.setExternalWalletSelectionDelegate(self)
    }
    
    func showPaymentForm(amount: Double, userId: UUID, onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        
        let options: [String: Any] = [
            "amount": amount * 100, // Convert to paise
            "currency": "INR",
            "description": "RasoiChef Order Payment",
            "prefill": [
                "contact": "",
                "email": ""
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        
        if let rzp = self.razorpay {
            rzp.open(options)
        }
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        DispatchQueue.main.async {
            self.paymentStatus = "error: \(str)"
            print("Payment error: \(str)")
            self.onFailure?(str)
        }
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        DispatchQueue.main.async {
            self.paymentStatus = "success: \(payment_id)"
            print("Payment success: \(payment_id)")
            self.onSuccess?(payment_id)
        }
    }
    
    // MARK: - External Wallet Selection Protocol
    func onExternalWalletSelected(_ walletName: String, withPaymentData paymentData: [AnyHashable : Any]?) {
        // Handle external wallet selection if needed
    }
}

// MARK: - Payment Completion Protocol with Data
extension RazorpayManager: RazorpayPaymentCompletionProtocolWithData {
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        onPaymentError(code, description: str)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        onPaymentSuccess(payment_id)
    }
} 