//
//  BluetoothService.swift
//  HideNSeek
//
//  Created by Евгений on 19.11.22.
//

import CoreBluetooth

class BluetoothService: NSObject {
	var delegate: DiscoverServiceDelegate?

	let centralManager = CBCentralManager()
	let peripheralManager = CBPeripheralManager()

	var peripherals: [CBPeripheral] = []
	var warmth: Double = 0

	override init() {
		super.init()
		centralManager.delegate = self

		Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
			self.peripherals.forEach { $0.readRSSI() }
		}
	}

	func processRSSI(_ RSSI: NSNumber) {
		warmth += (128 - Double(RSSI)) / 256
		warmth = min(1, max(0, warmth))
		delegate?.warmthChanged(warmth, mode: .network)
	}
}

extension BluetoothService: DiscoverServiceProtocol {
	func startSeeking() {
		centralManager.scanForPeripherals(withServices: [Constants.serviceUUID])
	}

	func stopSeeking() {
		centralManager.stopScan()
	}

	func startAdvertising() {
		peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [Constants.serviceUUID]])
	}

	func stopAdvertising() {
		peripheralManager.stopAdvertising()
	}
}

extension BluetoothService: CBCentralManagerDelegate {
	func centralManagerDidUpdateState(_ central: CBCentralManager) {

	}

	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		peripheral.delegate = self
		peripherals.append(peripheral)
		centralManager.connect(peripheral)
		processRSSI(RSSI)
	}
}

extension BluetoothService: CBPeripheralDelegate {
	func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
		processRSSI(RSSI)
	}
}
