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
	var timer: Timer?

	var peripherals: [CBPeripheral] = []
	var warmth: Double = 0

	override init() {
		super.init()
		centralManager.delegate = self

		timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [unowned self] _ in
			if self.peripherals.isEmpty == true {
				warmth = 0
				delegate?.discoverService(self, newWarmth: warmth, mode: .network)
			} else {
				self.peripherals.forEach { $0.readRSSI() }
			}
		}
	}

	deinit {
		timer?.invalidate()
	}

	func processRSSI(_ RSSI: NSNumber) {
		warmth = 0.5 * warmth + (Double(RSSI) + 80) / 128
		warmth = min(1, max(0, warmth))
		delegate?.discoverService(self, newWarmth: warmth, mode: .network)
	}
}

extension BluetoothService: DiscoverServiceProtocol {
	func startSeeking() {
		centralManager.scanForPeripherals(withServices: [Constants.serviceUUID])
	}

	func stopSeeking() {
		centralManager.stopScan()

		for peripheral in peripherals {
			centralManager.cancelPeripheralConnection(peripheral)
		}
	}

	func startAdvertising() {
		peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [Constants.serviceUUID]])
	}

	func stopAdvertising() {
		peripheralManager.stopAdvertising()

		if peripheralManager.state == .poweredOn {
			peripheralManager.removeAllServices()
		}
	}
}

extension BluetoothService: CBCentralManagerDelegate {
	func centralManagerDidUpdateState(_ central: CBCentralManager) {

	}

	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		peripheral.delegate = self
		peripherals.append(peripheral)
		central.connect(peripheral)
		processRSSI(RSSI)
	}

	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		guard let index = peripherals.firstIndex(of: peripheral) else { return }

		central.cancelPeripheralConnection(peripheral)
		peripherals.remove(at: index)
	}
}

extension BluetoothService: CBPeripheralDelegate {
	func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
		processRSSI(RSSI)
	}
}
