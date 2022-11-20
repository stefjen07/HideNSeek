//
//  AudioService.swift
//  HideNSeek
//
//  Created by Евгений on 17.11.22.
//

import Foundation
import AVFoundation
import SoundAnalysis

class AudioService: NSObject {
	var delegate: DiscoverServiceDelegate?

	var player: AVAudioPlayer?
	var audioEngine: AVAudioEngine!
	var queue: DispatchQueue = .init(label: "audio_queue")
	var timer: Timer?

	var soundClassifier: BirdsClassifier?
	var streamAnalyzer: SNAudioStreamAnalyzer?
	var warmth: Double = 0

	init(recording: Bool) {
		if recording {
			soundClassifier = try? BirdsClassifier(configuration: .init())
			audioEngine = .init()
		} else if let url = Bundle.main.url(forResource: "birds", withExtension: "mp3") {
			player = try? AVAudioPlayer(contentsOf: url)
		}

		super.init()
	}

	func startAudioEngine() {
		audioEngine.prepare()

		do {
			try audioEngine.start()
		} catch {
			print("Audio engine failure")
		}
	}

	func prepareForRecording() {
		do {
			try AVAudioSession.sharedInstance().setActive(false)
			try AVAudioSession.sharedInstance().setCategory(.record, mode: .default, policy: .default, options: [.interruptSpokenAudioAndMixWithOthers])
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			print(error.localizedDescription)
		}

		let inputNode = audioEngine.inputNode
		let recordingFormat = inputNode.outputFormat(forBus: 0)
		streamAnalyzer = SNAudioStreamAnalyzer(format: recordingFormat)
		inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
			[unowned self] (buffer, when) in
			self.queue.async {
				self.streamAnalyzer?.analyze(buffer,
											atAudioFramePosition: when.sampleTime)
			}
		}
		startAudioEngine()
	}

	func createClassificationRequest() {
		guard let soundClassifier = soundClassifier else { return }

		do {
			let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
			try streamAnalyzer?.add(request, withObserver: self)
		} catch {
			fatalError("error adding the classification request")
		}
	}

	func stopRecording() {
		audioEngine.inputNode.removeTap(onBus: 0)
		audioEngine.stop()
	}
}

extension AudioService: DiscoverServiceProtocol {
	func startSeeking() {
		prepareForRecording()
		createClassificationRequest()
	}

	func stopSeeking() {
		stopRecording()
	}

	func startAdvertising() {
		do {
			try AVAudioSession.sharedInstance().setActive(false)
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .default, options: [.interruptSpokenAudioAndMixWithOthers])
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			print(error.localizedDescription)
		}

		timer = Timer.scheduledTimer(withTimeInterval: Constants.soundInterval, repeats: true) { [weak self] _ in
			guard let player = self?.player else { return }

			player.currentTime = Double.random(in: 0..<player.duration - Constants.soundDuration)
			player.prepareToPlay()
			player.play()

			Timer.scheduledTimer(withTimeInterval: Constants.soundDuration, repeats: false) { _ in
				player.stop()
			}
		}
	}

	func stopAdvertising() {
		player?.stop()
		timer?.invalidate()
	}
}

extension AudioService: SNResultsObserving {
	func request(_ request: SNRequest, didProduce result: SNResult) {
		guard let result = result as? SNClassificationResult else { return }

		let sorted = result.classifications.sorted { (first, second) -> Bool in
			return first.confidence > second.confidence
		}

		if sorted.first?.identifier == "birds" {
			warmth += 0.3 * (sorted.first?.confidence ?? 0.5)
			warmth = min(1, warmth)
		} else {
			warmth *= 0.85
			warmth -= 0.03
			warmth = max(0, warmth)
		}

		delegate?.discoverService(self, newWarmth: warmth, mode: .sound)
	}
}
