import UIKit
import Flutter
import Firebase  // <-- 1st add

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        
        if FirebaseApp.app() == nil {
        FirebaseApp.configure()      

        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
