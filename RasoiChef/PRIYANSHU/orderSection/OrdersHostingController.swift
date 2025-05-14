import SwiftUI
import UIKit

class OrdersHostingController: UIHostingController<OrdersView> {
    init() {
        super.init(rootView: OrdersView())
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: OrdersView())
    }
} 