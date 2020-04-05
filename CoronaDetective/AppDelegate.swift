//
//  AppDelegate.swift
//  CoronaDetective
//
//  Created by Gautam Madaan on 3/31/20.
//  Copyright © 2020 Gautam Madaan. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PPKControllerDelegate {
    let gautam = "4083688895";
    let nikita = "4082034274";
    var mapDeviceToTimeStrongStrength = [String: Date]();
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize PPKController
        PPKController.enable(withConfiguration: "72b9e4db88ac42dab46ff9528b15eb5a", observer: self)
        PPKController.enableProximityRanging();
        return true
    }
    
    func ppkControllerInitialized() {
        // State restoration = true, makes devices discoverable even when the app crashes or is termintaed by OS
        PPKController.startDiscovery(withDiscoveryInfo: nikita.data(using: .utf8), stateRestoration: true)
    }
    /**
            Is called when prozimity strength is changed
     http://p2pkit.io/api/v2/ios/Constants/PPKProximityStrength.html for ranges
     */
    func proximityStrengthChanged(for peer: PPKPeer) {
        // On signal strength change
        // if signal drops below strong
//           - if the time elapsed since it was strong has been 10 seconds. write the data and remove from dictionary
        //   - If time elapsed since it was storing is less than 10 seconds, remove from dictionary
        
        // if proximity changes to strong or immediate
//          - if a time stamp is found do nothing
//          - if timestamp is not found, start the process again
        
        let proximityStrengthValue = peer.proximityStrength.rawValue;
        let discoveryInfoString = self.getDiscoveryInfo(for: peer);
        let timeStrongStrength = mapDeviceToTimeStrongStrength[discoveryInfoString];
        if (proximityStrengthValue < PPKProximityStrength.strong.rawValue) {
            print(proximityStrengthValue, PPKProximityStrength.strong.rawValue)
            if timeStrongStrength != nil {
                print(timeStrongStrength?.timeIntervalSinceNow as Any);
                if abs(timeStrongStrength?.timeIntervalSinceNow ?? Double(0)) >= Double(10) {
                    var parameters = [String: String]();
                    parameters["source"] = nikita;
                    parameters["destination"] = "9810190852";
                    AF.request("https://InfatuatedRevolvingFacts--gautim26.repl.co", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in print(response)})
                    print("Available for more than 10 seconds");
                }
                mapDeviceToTimeStrongStrength.removeValue(forKey: discoveryInfoString);
                print(mapDeviceToTimeStrongStrength, "Device removed from tagging");
            
            }
        } else if proximityStrengthValue >= PPKProximityStrength.strong.rawValue {
            if (timeStrongStrength == nil) {
                mapDeviceToTimeStrongStrength[discoveryInfoString] = Date.init();
                print( mapDeviceToTimeStrongStrength, "Device in range after reset");
            }
        }
    }
    
    func getDiscoveryInfo(for peer: PPKPeer) -> String {
        if let discoveryInfo = peer.discoveryInfo {
            guard let discoveryInfoString = String(data: discoveryInfo, encoding: .utf8) else { return "" }
        return discoveryInfoString;
        }
        return "";
    }
    
    /**
            Called when any peer goes out of range
     */
    func peerLost(_ peer: PPKPeer) {
        
    }

    func peerDiscovered(_ peer: PPKPeer) {
        let discoveryInfoString = self.getDiscoveryInfo(for: peer);
        if (discoveryInfoString != "") {
            print("\(peer.peerID) is here with discovery info: \(discoveryInfoString )")
            if peer.proximityStrength.rawValue >= PPKProximityStrength.strong.rawValue {
                mapDeviceToTimeStrongStrength[discoveryInfoString] = Date.init();
                print(mapDeviceToTimeStrongStrength);
            }
        }
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

