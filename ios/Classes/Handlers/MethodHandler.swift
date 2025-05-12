//
//  MethodHandler.swift
//  Pods
//
//  Created by Yriy Malyts on 12.05.2025.
//
import Flutter

protocol MethodHandler {
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool
}
