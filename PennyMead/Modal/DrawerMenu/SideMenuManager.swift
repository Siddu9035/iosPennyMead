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
    var sideMenuRevealWidth: CGFloat = 290
    let paddingForRotation: CGFloat = 0
    var isExpanded: Bool = false
    var sideMenuRightConstraint: NSLayoutConstraint?
    var isSideDrawerOpen: Bool = false
    
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
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGestureRight.direction = .right
        parentViewController.view.addGestureRecognizer(swipeGestureRight)

        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGestureLeft.direction = .left
        parentViewController.view.addGestureRecognizer(swipeGestureLeft)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            switch gesture.direction {
            case .right:
                    toggleSideMenu(expanded: false)
//                print("right")
            case .left:
                    toggleSideMenu(expanded: true)
//                print("left")
            default:
                break
            }
        }
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
                self.animateShadow(alpha: 0.75)
            }
            UIView.animate(withDuration: 0.3) {
                self.sideMenuVc.view.frame.origin.x -= self.sideMenuRevealWidth
            }
        } else {
            animateSideMenu(targetPosition: (sideMenuRevealWidth + paddingForRotation)) { _ in
                self.isExpanded = false
                self.animateShadow(alpha: 0)
            }
            UIView.animate(withDuration: 0.3) {
                self.sideMenuVc.view.frame.origin.x += self.sideMenuRevealWidth
            }
        }
    }
    
    private func animateShadow(alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.sideMenuShadowView.alpha = alpha
        }
    }
    
    private func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 5, animations: {
            self.sideMenuRightConstraint?.constant = targetPosition
            self.sideMenuVc?.view.layoutIfNeeded()
        }, completion: completion)
    }
    
}
