//
//  SideMenuManager.swift
//  PennyMead
//
//  Created by siddappa tambakad on 17/01/24.
//

import Foundation
import UIKit

class SideMenuManager {
    static let shared = SideMenuManager()

    var sideMenuShadowView: UIView!
    var sideMenuVc: Drawer!
    var sideMenuRevealWidth: CGFloat = 300
    let paddingForRotation: CGFloat = 0
    var isExpanded: Bool = false
    var sideMenuRightConstraint: NSLayoutConstraint?

    private init() {}

    func configureSideMenu(parentViewController: UIViewController) {
        // Initialize side menu components
        sideMenuShadowView = UIView(frame: parentViewController.view.bounds)
        sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuShadowView.backgroundColor = .black
        sideMenuShadowView.alpha = 0
        sideMenuShadowView.isUserInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = parentViewController as? UIGestureRecognizerDelegate
        sideMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        parentViewController.view.insertSubview(sideMenuShadowView, at: 5)

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sideMenuVc = storyboard.instantiateViewController(withIdentifier: "drawer") as? Drawer
        parentViewController.view.insertSubview(sideMenuVc.view, at: 10)
        parentViewController.addChild(sideMenuVc)
        self.sideMenuVc?.delegate = parentViewController as? DrawerDelegate
        sideMenuVc.didMove(toParent: parentViewController)

        sideMenuVc.view.translatesAutoresizingMaskIntoConstraints = false
        sideMenuRightConstraint = sideMenuVc.view.trailingAnchor.constraint(equalTo: parentViewController.view.trailingAnchor, constant: sideMenuRevealWidth + paddingForRotation)
        sideMenuRightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            sideMenuVc.view.widthAnchor.constraint(equalToConstant: sideMenuRevealWidth),
            sideMenuVc.view.bottomAnchor.constraint(equalTo: parentViewController.view.bottomAnchor),
            sideMenuVc.view.topAnchor.constraint(equalTo: parentViewController.view.topAnchor)
        ])
    }

    @objc private func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if isExpanded {
                toggleSideMenu(expanded: false)
            }
        }
    }

    func toggleSideMenu(expanded: Bool) {
        guard sideMenuRightConstraint != nil else {
            return
        }

        if expanded {
            animateSideMenu(targetPosition: 0) { _ in
                self.isExpanded = true
            }
            animateShadow(alpha: 0.6)
        } else {
            animateSideMenu(targetPosition: (sideMenuRevealWidth + paddingForRotation)) { _ in
                self.isExpanded = false
            }
            animateShadow(alpha: 0)
        }
    }

    private func animateShadow(alpha: CGFloat) {
        UIView.animate(withDuration: 1) {
            self.sideMenuShadowView.alpha = alpha
        }
    }

    private func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        print("Animating side menu to \(targetPosition)")
        UIView.animate(withDuration: 0.3) {
            self.sideMenuRightConstraint?.constant = targetPosition
            self.sideMenuVc?.view.layoutIfNeeded()
        } completion: { (finished) in
            print("Animation completed")
            completion(finished)
        }
    }


}
