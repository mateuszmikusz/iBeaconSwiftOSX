//
//  CBBeaconTransmitterProtocol.swift
//  iBeaconSwiftOSX
//
//  Created by Marcelo Gigirey on 11/13/14.
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

protocol CBBeaconTransmitterProtocol: CBPeripheralManagerDelegate {
    var beaconData: CBBeaconAvertisementData! { get set }
    var delegate: CBTransmitterDelegate? { get set }
    
    func setUpBeacon(proximityUUID uuid: UUID?, major M: CLBeaconMajorValue?, minor m: CLBeaconMinorValue?, measuredPower power: Int8?)
    func startTransmitting()
    func stopTransmitting()
}
