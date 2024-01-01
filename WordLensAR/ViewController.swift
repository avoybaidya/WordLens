// ViewController.swift
// Created by Avoy on 7/27/23.

import UIKit
import SceneKit
import ARKit
import AVFoundation
import Firebase

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var arButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var scanView: UIImageView!

    // MARK: - Properties
    private var arService: ARService!
    private var speechService: SpeechService!
    private var firebaseService: FirebaseService!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupServices()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arService.startARSession(with: sceneView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arService.pauseARSession()
    }

    // MARK: - UI Setup
    private func setupUI() {
        [arButton, cancelButton, speechButton, scanView].forEach { view in
            view?.layer.cornerRadius = 15
            view?.clipsToBounds = true
        }
        cancelButton.configureAsHidden(true)
    }

    // MARK: - Services Setup
    private func setupServices() {
        arService = ARService(delegate: self)
        speechService = SpeechService(delegate: self)
        firebaseService = FirebaseService()
    }

    // MARK: - Actions
    @IBAction func cancelPressed(_ sender: UIButton) {
        arService.stopAR()
        speechService.stopSpeaking()
        updateUIForCancellation()
    }

    @IBAction func speechPressed(_ sender: UIButton) {
        toggleUIForSpeech()
        let screenshot = captureViewSnapshot(scanView)
        speechService.recognizeTextAndSpeak(from: screenshot)
    }

    @IBAction func arPress(_ sender: UIButton) {
        toggleUIForAR()
        let screenshot = captureViewSnapshot(scanView)
        arService.recognizeTextAndAddARObject(from: screenshot)
    }

    // MARK: - Helper Methods
    private func updateUIForCancellation() {
        arButton.configureAsHidden(false)
        speechButton.configureAsHidden(false)
        cancelButton.configureAsHidden(true)
        scanView.configureAsHidden(false)
    }

    private func toggleUIForSpeech() {
        // UI updates for speech recognition and synthesis
    }

    private func toggleUIForAR() {
        // UI updates for AR interactions
    }

    private func captureViewSnapshot(_ view: UIView) -> UIImage? {
        // Capture a snapshot of the view and return the image
    }
}

// MARK: - ARServiceDelegate
extension ViewController: ARServiceDelegate {
    func arService(_ service: ARService, didDetectPlaneWithNode node: SCNNode) {
        // Handle plane detection
    }

    func arService(_ service: ARService, didUpdateNode node: SCNNode) {
        // Handle plane updates
    }
}

// MARK: - SpeechServiceDelegate
extension ViewController: SpeechServiceDelegate {
    func speechService(_ service: SpeechService, didStartSpeaking utterance: AVSpeechUtterance) {
        // Handle speech synthesis start
    }

    func speechService(_ service: SpeechService, didFinishSpeaking utterance: AVSpeechUtterance) {
        // Handle speech synthesis completion
    }
}

// MARK: - Button Extension for UI Configuration
private extension UIButton {
    func configureAsHidden(_ hidden: Bool) {
        isUserInteractionEnabled = !hidden
        isHidden = hidden
    }
}
