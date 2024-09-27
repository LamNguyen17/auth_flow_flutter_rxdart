import UIKit
import Flutter
import FBSDKCoreKit // <--- ADD THIS LINE
import RxSwift
import CryptoSwift

let CRYPTO_CHANNEL = "crypto_channel"
let INVALID_ARGUMENT = "invalid_argument"
let ENCRYPT_METHOD = "encrypt"
let DECRYPT_METHOD = "decrypt"

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let disposeBag = DisposeBag() // For RxSwift memory management

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)// <--- ADD THIS LINE
        GeneratedPluginRegistrant.register(with: self)
        let flutterVC = window?.rootViewController as! FlutterViewController
        let cryptoChannel = FlutterMethodChannel(
            name: CRYPTO_CHANNEL,
            binaryMessenger: flutterVC.binaryMessenger
        )
        let aesHelper = AesHelper()
        cryptoChannel.setMethodCallHandler { call, result in
            switch (call.method) {
            case ENCRYPT_METHOD:
                if let value = call.arguments as? [String: String],
                   let text = value["value"],
                   let secretKey = value["secret_key"],
                   let ivKey = value["iv_key"] {
                    
                    // Use RxSwift to perform encryption in the background
                    Observable<String?>.create { observer in
                        guard let encryptedData = aesHelper.encrypt(value: text, privateKey: secretKey, ivKey: ivKey) else {
                            return Disposables.create()
                        }
                        observer.onNext(encryptedData)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)) // Perform in background thread
                    .observe(on: MainScheduler.instance) // Observe result on main thread
                    .subscribe(
                        onNext: { encryptedData in
                            result(encryptedData)
                        }
                    )
                    .disposed(by: self.disposeBag)
                } else {
                    result(FlutterError(code: INVALID_ARGUMENT, message: "Data to encrypt is null", details: nil))
                }
            case DECRYPT_METHOD:
                if let value = call.arguments as? [String: String],
                   let text = value["value"],
                   let secretKey = value["secret_key"],
                   let ivKey = value["iv_key"] {
                    // Use RxSwift to perform decryption in the background
                    Observable<String?>.create { observer in
                        guard let decryptedData = aesHelper.decrypt(value: text, privateKey: secretKey, ivKey: ivKey) else {
                            return Disposables.create()
                        }
                        observer.onNext(decryptedData)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)) // Perform in background thread
                    .observe(on: MainScheduler.instance) // Observe result on main thread
                    .subscribe(
                        onNext: { decryptedData in
                            result(decryptedData)
                        }
                    )
                    .disposed(by: self.disposeBag)
                } else {
                    result(FlutterError(code: INVALID_ARGUMENT, message: "Data to decrypt is null", details: nil))
                }
            default: result(FlutterMethodNotImplemented)
            }
        }
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
