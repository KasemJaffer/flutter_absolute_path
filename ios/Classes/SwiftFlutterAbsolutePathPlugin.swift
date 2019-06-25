import Flutter
import UIKit
import Photos

public class SwiftFlutterAbsolutePathPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_absolute_path", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterAbsolutePathPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "getAbsolutePath"){
            guard let uri = (call.arguments as? Dictionary<String, String>)?["uri"] else {
                result(FlutterError(code: "assertion_error", message: "uri is required.", details: nil))
                return
            }
            if (uri.starts(with: "file://") || uri.starts(with: "/var/mobile/Media") || uri.starts(with: "/private/var/mobile")) {
                result( uri.replacingOccurrences(of: "file://", with: ""))
                return
            }
            let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: [uri], options: .none).firstObject
            if(phAsset == nil) {
                result(nil)
                return
            }
            let editingOptions = PHContentEditingInputRequestOptions()
            editingOptions.isNetworkAccessAllowed = true
            phAsset!.requestContentEditingInput(with: editingOptions) { (input, _) in
                let url = input?.fullSizeImageURL?.absoluteString.replacingOccurrences(of: "file://", with: "")
                result(url)
            }
        }
    }
}
