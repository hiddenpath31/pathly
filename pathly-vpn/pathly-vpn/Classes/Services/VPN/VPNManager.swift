//
//  VPNManager.swift
//  astra-vpn
//
//  Created by Александр on 25.01.2022.
//

import Foundation
import NetworkExtension

enum ConnectionStatus {
    case connect(date: Date)
    case connection
    case disconnect
    case fail
    
    var title: NSAttributedString {
        switch self {
        case .connect(let date):
            let now = Date()
            let time = Date.timeDifference(from: date, to: now)
            let result = "Connected \(time)".uppercased()
                .attr
                .colored(Asset.accentColor.color)
                .fonted(FontFamily.SFProText.medium.font(size: 16))
            return result
        case .connection:
            let result = "Connecting".uppercased()
                .attr
                .colored(.white)
                .fonted(FontFamily.SFProText.regular.font(size: 16))
            return result
        case .disconnect:
            let result = "Disconnect".uppercased()
                .attr
                .colored(.white)
                .fonted(FontFamily.SFProText.regular.font(size: 16))
            return result
        case .fail:
            let result = "Fail".uppercased()
                .attr
                .colored(.white)
                .fonted(FontFamily.SFProText.regular.font(size: 16))
            return result
        }
    }
}

final class VPNManager: NSObject {
    static let shared: VPNManager = {
        let instance = VPNManager()
        instance.manager.localizedDescription = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        instance.loadProfile(callback: nil)
        return instance
    }()
    
    let manager: NEVPNManager = { NEVPNManager.shared() }()
    public var isDisconnected: Bool {
        get {
            return (status == .disconnected)
                || (status == .reasserting)
                || (status == .invalid)
        }
    }
    public var status: NEVPNStatus { get { return manager.connection.status } }
    public let statusEvent = Subject<NEVPNStatus>()
    private var serverModel: Server?
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VPNManager.VPNStatusDidChange(notification:)),
            name: NSNotification.Name.NEVPNStatusDidChange,
            object: nil)
    }
    
    public func disconnect(completionHandler: (()->Void)? = nil) {
        manager.onDemandRules = []
        manager.isOnDemandEnabled = false
        manager.saveToPreferences { _ in
            self.manager.connection.stopVPNTunnel()
            completionHandler?()
        }
    }
    
    @objc private func VPNStatusDidChange(notification: NSNotification?){
        statusEvent.notify(status)
    }
    
    func loadProfile(callback: ((Bool)->Void)?) {
        manager.protocolConfiguration = nil
        manager.loadFromPreferences { error in
            if let error = error {
                NSLog("Failed to load preferences: \(error.localizedDescription)")
                callback?(false)
            } else {
                print(self.manager.connection.status)
                callback?(self.manager.protocolConfiguration != nil)
            }
        }
    }
    
    private func saveProfile(callback: ((Bool)->Void)?) {
        manager.saveToPreferences { error in
            self.manager.saveToPreferences { error in
                if let error = error {
                    NSLog("Failed to save profile: \(error.localizedDescription)")
                    callback?(false)
                } else {
                    callback?(true)
                }
            }
        }
    }
    
    public func connectIKEv2(config: Server, onSuccess: @escaping ((Bool) -> Void), onError: @escaping ((String) -> Void)) {
        let p = NEVPNProtocolIKEv2()
        if config.pskEnabled {
            p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
        } else {
            p.authenticationMethod = NEVPNIKEAuthenticationMethod.none
        }
  
        p.remoteIdentifier = config.ip
        p.serverAddress = config.ip
        p.authenticationMethod = .sharedSecret
        p.sharedSecretReference = config.getPSKRef()
        p.useExtendedAuthentication = false
        p.disconnectOnSleep = false
        p.enableFallback = true
        
        loadProfile { _ in
            self.manager.protocolConfiguration = p
            self.manager.isEnabled = true
            self.saveProfile { success in
                if !success {
                    onError("Unable To Save VPN Profile")
                    return
                }
                self.loadProfile() { success in
                    if !success {
                        onError("Unable To Load Profile")
                        return
                    }
                    let result = self.startVPNTunnel()
                    if !result {
                        onError("Can't connect")
                    } else {
                        onSuccess(true)
                    }
                }
            }
        }
        
    }
    
    private func startVPNTunnel() -> Bool {
        do {
            try self.manager.connection.startVPNTunnel()
            return true
        } catch NEVPNError.configurationInvalid {
            NSLog("Failed to start tunnel (configuration invalid)")
        } catch NEVPNError.configurationDisabled {
            NSLog("Failed to start tunnel (configuration disabled)")
        } catch {
            NSLog("Failed to start tunnel (other error)")
        }
        return false
    }
    
    public func isConnectActive() -> Bool {
        if self.manager.connection.status == .connected {
            return true
        } else {
            return false
        }
    }
    
    public func connectDate() -> Date? {
        return self.manager.connection.connectedDate
    }
    
    func getConnectionTime() -> String? {
        if let connectedDate = self.manager.connection.connectedDate {
            let now = Date()
            let time = Date.timeDifference(from: connectedDate, to: now)
            return time
        }
        
        return nil
    }
    
}


