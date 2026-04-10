import UIKit
import Flutter
import flutter_carplay

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Standard app scene
        if session.role == .windowApplication {
            window = UIWindow(windowScene: windowScene)
            let controller = FlutterViewController(project: nil, initialRoute: nil)
            window?.rootViewController = controller
            window?.makeKeyAndVisible()
            GeneratedPluginRegistrant.register(with: controller.engine!)
        }
    }
}
