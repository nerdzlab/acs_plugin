//
//  UIApplication+endEditing.swift
//  Pods
//
//  Created by Yriy Malyts on 10.04.2025.
//

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
