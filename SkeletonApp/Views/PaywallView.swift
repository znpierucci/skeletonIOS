//
//  PaywallView.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI
import StoreKit

private var product: SKProduct?

struct PaywallView: View {
    @Binding var isSubscribed: Bool
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var shadowRadius: CGFloat = 5
    @State private var shadowOpacity: Double = 0.5
    @State private var isAnimating = false

    var body: some View {
        VStack {
            //VIEW GOES HERE
            
            Button(action: {
                purchaseManager.purchaseSubscription()
            }) {
                Text("Try 3 days Free! 🎉")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(
                        Color.blue
                            .opacity(isAnimating ? 1.0 : 0.6) // Animate opacity for glowing effect
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                    )
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
                    .shadow(color: Color.black.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 0)
                    .onAppear {
                        animateShadow()
                    }
            }
            .onAppear {
                isAnimating = true
            }
        }
        .background(Constants.appGradient)
        .preferredColorScheme(.light)
        .onAppear {
            if UserDefaults.standard.bool(forKey: "isSubscribed") {
                isSubscribed = true
            }
        }
        .onChange(of: purchaseManager.isSubscribed) { newValue in
            if newValue {
                isSubscribed = true
            }
        }
    }
    
    private func animateShadow() {
        withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            shadowRadius = 10
            shadowOpacity = 0.75
        }
    }
}

class PurchaseManager: NSObject, ObservableObject {
    static let shared = PurchaseManager()

    @Published var isSubscribed = false
    private var product: SKProduct?

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func fetchProduct() {
        //TODO: ADD OUR REAL SUBSCRIPTION PRODUCT HERE
        let productIdentifier = "your_subscription_product_identifier"  // Replace with your actual product ID
        let request = SKProductsRequest(productIdentifiers: [productIdentifier])
        request.delegate = self
        request.start()
    }

    func purchaseSubscription() {
        //TODO: REMOVE THESE BELOW 2 LINES WHEN READY FOR TEST FLIGHT
        isSubscribed = true
        UserDefaults.standard.set(true, forKey: "isSubscribed")
        
        guard let product = product else {
            fetchProduct() // Fetch the product if it hasn't been fetched yet
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension PurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let fetchedProduct = response.products.first else {
            print("Product not found")
            return
        }
        
        self.product = fetchedProduct
        purchaseSubscription()
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to fetch product: \(error.localizedDescription)")
    }
}

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // User successfully purchased the subscription
                isSubscribed = true
                SKPaymentQueue.default().finishTransaction(transaction)
                UserDefaults.standard.set(true, forKey: "isSubscribed")  // Save subscription status
            case .failed:
                // Handle failure
                if let error = transaction.error as? SKError {
                    print("Transaction Failed: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                // Handle restored purchases
                isSubscribed = true
                SKPaymentQueue.default().finishTransaction(transaction)
                UserDefaults.standard.set(true, forKey: "isSubscribed")  // Save subscription status
            default:
                break
            }
        }
    }
}
