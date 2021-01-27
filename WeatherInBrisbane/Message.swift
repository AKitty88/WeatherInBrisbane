//
//  Message.swift
//  WeatherInBrisbane
//
//  Created by User on 28/1/21.
//

import Foundation
import UIKit
import SwiftMessages

@objcMembers class Message: NSObject {
    func showErrorMessage(text: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureTheme(backgroundColor: .white, foregroundColor: .red)
        view.configureContent(title: "Error", body: text)
        view.button?.setTitle("OK", for: .normal)
        SwiftMessages.show(view: view)
    }

    func showSuccessMessage(text: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.configureTheme(backgroundColor: .white, foregroundColor: .blue)
        view.configureContent(title: "Success", body: text)
        view.button?.setTitle("OK", for: .normal)
        SwiftMessages.show(view: view)
    }
}
