import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var photoOutput = AVCapturePhotoOutput()
    
    private var captureButton: UIButton!
    private var previewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewContainer = UIView()
        previewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewContainer)
        
        addCaptureButton()
        
        NSLayoutConstraint.activate([
            previewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            previewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewContainer.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -28),
            
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 64),
            captureButton.heightAnchor.constraint(equalToConstant: 64),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        setupCamera()
    }
    
    private func setupCamera() {
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspect
            previewLayer.frame = previewContainer.bounds
            previewContainer.layer.addSublayer(previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        } catch {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewContainer.bounds
    }
    
    private func addCaptureButton() {
        captureButton = UIButton(type: .custom)
        captureButton.backgroundColor = .white
        captureButton.setTitle("", for: .normal)
        captureButton.layer.cornerRadius = 32
        captureButton.clipsToBounds = true
        
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)
        
        captureButton.addTarget(self, action: #selector(didTapCaptureButton), for: .touchUpInside)
        captureButton.addTarget(self, action: #selector(captureButtonTouchDown), for: .touchDown)
        captureButton.addTarget(self, action: #selector(captureButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func captureButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.captureButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }
    
    @objc private func captureButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.captureButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func didTapCaptureButton() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    // Removed duplicate photoOutput(_:didFinishProcessingPhoto:error:) method here
}


// Minimal SwiftUI CameraView to fix DualCameraView errors
import SwiftUI
import UIKit

enum CameraPosition {
    case front
    case back
}

struct CameraView: UIViewControllerRepresentable {
    let position: CameraPosition
    let onImageCaptured: (UIImage) -> Void

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.position = position
        controller.onImageCaptured = onImageCaptured
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

// Extend CameraViewController to support front/back and callback
import AVFoundation
import ObjectiveC.runtime

extension CameraViewController {
    private struct AssociatedKeys {
        static var position: UInt8 = 0
        static var onImageCaptured: UInt8 = 0
    }

    var position: CameraPosition {
        get { objc_getAssociatedObject(self, &AssociatedKeys.position) as? CameraPosition ?? .back }
        set { objc_setAssociatedObject(self, &AssociatedKeys.position, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    var onImageCaptured: ((UIImage) -> Void)? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.onImageCaptured) as? ((UIImage) -> Void) }
        set { objc_setAssociatedObject(self, &AssociatedKeys.onImageCaptured, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Use the 'position' property to select front/back camera
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        let device: AVCaptureDevice?
        switch position {
        case .front:
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        case .back:
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        if let device {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
                DispatchQueue.global(qos: .userInitiated).async {
                    self.captureSession.startRunning()
                }
            } catch {
                print("Error setting camera device: \(error)")
            }
        }
    }
    
    // Update delegate to call back
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        onImageCaptured?(image)
    }
}

#Preview {
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
        // Show a placeholder
        Color.gray.overlay(Text("Camera Preview Not Available"))
    } else {
        CameraView(position: .back, onImageCaptured: { _ in })
    }
}

