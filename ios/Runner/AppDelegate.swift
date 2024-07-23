import UIKit
import Flutter
import FBSDKCoreKit // <--- ADD THIS LINE

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)// <--- ADD THIS LINE
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // <--- OVERRIDE THIS METHOD WITH THIS CODE
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme != nil {
            let facebookAppId: String? = Bundle.main.object(forInfoDictionaryKey: "2212639675736989") as? String
            if facebookAppId != nil && url.scheme!.hasPrefix("fb\(facebookAppId!)") && url.host ==  "authorize" {
                print("is login by facebook")
                return ApplicationDelegate.shared.application(app, open: url, options: options)
            }
        }
        return false
    }
}
