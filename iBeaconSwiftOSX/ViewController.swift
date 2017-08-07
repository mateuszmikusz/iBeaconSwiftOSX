//
//  ViewController.swift
//  iBeaconSwiftOSX
//
//  Created by Marcelo Gigirey on 11/9/14.
//  Copyright (c) 2014 Marcelo Gigirey. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Cocoa
import Foundation
import CoreBluetooth

class ViewController: NSViewController, CBTransmitterDelegate {
    // Properties
    var isAdvertising: Bool?
    //var isReadyForAdvertising : Bool?
    var transmitter : CBBeaconTransmitter?
    
    // Constants
    let kCBUserDefaultsUDID = "kCBUserDefaultsUDID"
    let kCBCUserDefaultsMajor = "kCBCUserDefaultsMajor"
    let kCBCUserDefaultsMinor = "kCBCUserDefaultsMinor"
    let kCBCUserDefaultsMeasuredPower = "kCBCUserDefaultsMeasuredPower"
    
    @IBOutlet weak var uuidTextField: NSTextFieldCell!
    @IBOutlet weak var majorTextField: NSTextField!
    @IBOutlet weak var minorTextField: NSTextField!
    @IBOutlet weak var measuredPowerTextField: NSTextField!
    @IBOutlet weak var generateUUIDButton: NSButton!
    @IBOutlet weak var startButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isAdvertising = false
        //isReadyForAdvertising = false
        
        transmitter = CBBeaconTransmitter()
        transmitter?.delegate = self
        
        // Retrieve Values from NSUserDefaults
        loadUserDefaults()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func loadUserDefaults() {
        let udid : NSString? = UserDefaults.standard.string(forKey: kCBUserDefaultsUDID) as NSString?
        if udid != nil {
            uuidTextField.stringValue = "\(udid!)"
        }
        
        let major : NSString? = UserDefaults.standard.string(forKey: kCBCUserDefaultsMajor) as NSString?
        if major != nil {
            majorTextField.stringValue = "\(major!)"
        }
        
        let minor : NSString? = UserDefaults.standard.string(forKey: kCBCUserDefaultsMinor) as NSString?
        if minor != nil {
            minorTextField.stringValue = "\(minor!)"
        }
        
        let measuredPower : NSString? = UserDefaults.standard.string(forKey: kCBCUserDefaultsMeasuredPower) as NSString?
        if measuredPower != nil {
            measuredPowerTextField.stringValue = "\(measuredPower!)"
        }
    }
    
    @IBAction func startButtonClicked(_ sender: AnyObject) {
        // Transmit
        if !isAdvertising! {
            // Store Values in NSUserDefaults
            UserDefaults.standard.set(uuidTextField.stringValue, forKey: kCBUserDefaultsUDID)
            UserDefaults.standard.set(majorTextField.stringValue, forKey: kCBCUserDefaultsMajor)
            UserDefaults.standard.set(minorTextField.stringValue, forKey: kCBCUserDefaultsMinor)
            UserDefaults.standard.set(measuredPowerTextField.stringValue, forKey: kCBCUserDefaultsMeasuredPower)
            
            transmitAsBeacon()
        }
        else {
            stopBeacon()
        }
    }
    
    @IBAction func genereateUUIDClicked(_ sender: AnyObject) {
        uuidTextField.stringValue = "\(UUID().uuidString)"
    }
    
    // Transmit as iBeacon
    func transmitAsBeacon() {
        transmitter?.setUpBeacon(proximityUUID: UUID(uuidString: uuidTextField.stringValue)!,
            major: UInt16(majorTextField.integerValue),
            minor: UInt16(minorTextField.integerValue),
            measuredPower: Int8(measuredPowerTextField.integerValue))
        transmitter?.startTransmitting()
    }
    
    func stopBeacon() {
        transmitter?.stopTransmitting()
    }
    
    func toggleControls(_ beaconStatus: BeaconStatus) {
        switch beaconStatus
        {
        case .advertising:
            startButton.title = "Turn iBeacon off"
            startButton.isEnabled = true
            enableControls(false)
        case .notAdvertising:
            startButton.title = "Turn iBeacon on"
            startButton.isEnabled = true
            enableControls(true)
        case .resumeAdvertise:
            transmitAsBeacon()
            startButton.isEnabled = true
            enableControls(false)
        case .cannotAdvertise:
            startButton.isEnabled = false
            enableControls(false)
        }
    }
    
    func enableControls(_ enabled: Bool) {
        generateUUIDButton.isEnabled = enabled
        uuidTextField.isEnabled = enabled
        majorTextField.isEnabled = enabled
        minorTextField.isEnabled = enabled
        measuredPowerTextField.isEnabled = enabled
    }
    
    func transmitterDidPoweredOn(_ isPoweredOn: Bool) {
        if isPoweredOn {
            toggleControls(isAdvertising! ? BeaconStatus.resumeAdvertise : BeaconStatus.notAdvertising)
        }
        else {
            toggleControls(BeaconStatus.cannotAdvertise)
        }
    }
    
    func transmitterDidStartAdvertising(_ isAdvertising: Bool) {
        self.isAdvertising = isAdvertising
        toggleControls(isAdvertising == true ? BeaconStatus.advertising : BeaconStatus.notAdvertising)
    }
    
    enum BeaconStatus {
        case advertising
        case notAdvertising
        case resumeAdvertise
        case cannotAdvertise
    }
}
