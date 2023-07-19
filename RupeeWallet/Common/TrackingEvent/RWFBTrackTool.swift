//
//  RWFBTrackTool.swift
//  RupeeWallet
//
//  Created by Tim on 2023/7/19.
//

import UIKit
import FacebookCore

@objcMembers public class RWFBTrackTool: NSObject {
    public static func applicationDidFinishLaunching(with application: UIApplication, options: [UIApplication.LaunchOptionsKey : Any]) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: options);
    }
    
    public static func application(with application:UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    public static func trac(point: String) {
        let event = AppEvents.Name(point)
        AppEvents.shared.logEvent(event)
    }
}
