//
//  HalfScreenPresentationController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class HalfScreenPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
            guard let containerView = containerView else { return .zero }
        let height = containerView.bounds.height * 0.5 // 50% of screen height
            return CGRect(
                x: 0,
                y: containerView.bounds.height - height,
                width: containerView.bounds.width,
                height: height
            )
        }

        override func presentationTransitionWillBegin() {
            super.presentationTransitionWillBegin()

            // Optional: Add a dimming view
            let dimmingView = UIView(frame: containerView!.bounds)
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimmingView.alpha = 0
            containerView?.addSubview(dimmingView)

            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                dimmingView.alpha = 1
            }, completion: nil)
        }

        override func dismissalTransitionWillBegin() {
            super.dismissalTransitionWillBegin()

            // Fade out the dimming view
            containerView?.subviews.last?.removeFromSuperview()
        }
    }

