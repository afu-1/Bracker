//
//  CommonFunctions.swift
//  Bracker
//
//  Created by Annie Fu on 11/19/23.
//
// Description: basic functions needed for popover menu to work

import UIKit

//popover function from https://johncodeos.com/how-to-create-a-popover-in-ios-using-swift/
func presentPopover(_ parentViewController: UIViewController, _ viewController: UIViewController, sender: UIView, size: CGSize, arrowDirection: UIPopoverArrowDirection = .down) {
    
    //set popover VC as popover
    viewController.preferredContentSize = size
    viewController.modalPresentationStyle = .popover
    if let pres = viewController.presentationController {
        pres.delegate = parentViewController
    }
    parentViewController.present(viewController, animated: true)
    
    //to have popover extend from profile anchor
    if let pop = viewController.popoverPresentationController {
        pop.sourceView = sender
        pop.sourceRect = sender.bounds
        pop.permittedArrowDirections = arrowDirection
    }
}

//popover function from https://johncodeos.com/how-to-create-a-popover-in-ios-using-swift/
extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none //to ensure that popover doesn't take over full screen
    }
}
