//
//  CBBeaconTransmitter.swift
//  iBeaconSwiftOSX
//
//  Created by Marcelo Gigirey on 11/5/14.
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

import Foundation
import CoreBluetooth
import CoreLocation

final class CBBeaconTransmitter: NSObject, CBBeaconTransmitterProtocol {
    private lazy var __once: () = {
            //print("__once")
            self.manager = CBPeripheralManager(delegate: self, queue: nil)
        }()
    // Properties
    var manager: CBPeripheralManager!
    var beaconData: CBBeaconAvertisementData!
    var delegate: CBTransmitterDelegate?
    
    override init() {
        super.init()
        // http://stackoverflow.com/a/24137213/3824765
        _ = __once
    }
    
    // Set Up
    func setUpBeacon(proximityUUID uuid: UUID?, major M: CLBeaconMajorValue?, minor m: CLBeaconMinorValue?, measuredPower power: Int8?) {
        beaconData = CBBeaconAvertisementData(proximityUUID: uuid!, major: M!, minor: m!, measuredPower: power!)
    }
    
    // Transmitting
    func startTransmitting() {
        if let advertisement = beaconData.beaconAdvertisement() {
            print(advertisement)
            manager.startAdvertising(advertisement as? [String : Any])
        }
    }
    
    func stopTransmitting() {
        manager.stopAdvertising()
        //manager.delegate = nil
        delegate?.transmitterDidStartAdvertising(false)
        print("Advertising our iBeacon Stopped")
    }
    
    
    // CBPeripheralManager Delegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("The peripheral state is ")
        switch peripheral.state {
        case .poweredOff:
            print("Powered off")
        case .poweredOn:
            print("Powered on")
        case .resetting:
            print("Resetting")
        case .unauthorized:
            print("Unauthorized")
        case .unknown:
            print("Unknown")
        case .unsupported:
            print("Unsupported")
        }
        
        let isPoweredOn = peripheral.state == CBPeripheralManagerState.poweredOn ? true : false
        delegate?.transmitterDidPoweredOn(isPoweredOn)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error == nil {
            print("Advertising our iBeacon Started")
            delegate?.transmitterDidStartAdvertising(true)
        } else {
            print("Failed to advertise iBeacon. Error = \(String(describing: error))")
            delegate?.transmitterDidStartAdvertising(false)
        }
    }
}
