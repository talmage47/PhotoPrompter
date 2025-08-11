import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var photoOutput = AVCapturePhotoOutput()
    
    private var captureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        addCaptureButton()
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
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
        } catch {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    private func addCaptureButton() {
        captureButton = UIButton(type: .custom)
        captureButton.backgroundColor = .white
        captureButton.setTitle("", for: .normal)
        captureButton.layer.cornerRadius = 32
        captureButton.clipsToBounds = true
        
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)
        
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 64),
            captureButton.heightAnchor.constraint(equalToConstant: 64),
        ])
        
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
        static var position = "position"
        static var onImageCaptured = "onImageCaptured"
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

