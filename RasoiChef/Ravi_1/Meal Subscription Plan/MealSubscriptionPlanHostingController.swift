import UIKit
import SwiftUI

class MealSubscriptionPlanHostingController: UIHostingController<MealSubscriptionPlanView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: MealSubscriptionPlanView())
    }
    
    override init(rootView: MealSubscriptionPlanView) {
        super.init(rootView: rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meal Subscription Plan"
    }
} 