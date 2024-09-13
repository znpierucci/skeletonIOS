//
//  PhotoUploadView.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct PhotoUploadView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var isActive = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isCameraReady = false
    @StateObject private var cameraModel = CameraModel() // Use CameraModel
    
    @State private var isImagePickerPresented = false
    let isDebugging = true

    var body: some View {
        VStack {
            CustomBackButtonView {
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading, 10) // Adjust the padding as needed

            Spacer()

            Text("Take a selfie so our AI can analyze your smile")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            // Camera preview area
            ZStack {
                if cameraModel.isTaken, let image = UIImage(data: cameraModel.picData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 3))
                } else {
                    GeometryReader { geometry in
                        CameraPreview(size: geometry.size)
                            .environmentObject(cameraModel)
                    }
                    .frame(width: 300, height: 300)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 3))
                }
            }
            .padding(.bottom, 20)

            Text("add whatever text we want here")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity)
                .lineLimit(nil)

            Spacer()

            //TODO: UNCOMMENT THIS WHEN LOCALLY TESTING
            Button(action: {
                isImagePickerPresented = true
            }) {
                HStack {
                    Text("📱 Upload Photo")
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(25)
                .padding(.horizontal, 40)
            }
            .padding(.bottom, 20)
            //TODO: UNCOMMENT THIS WHEN LOCALLY TESTING

            NavigationLink(destination: Question1View(uploadedImage: selectedImage), isActive: $isActive) {
                EmptyView()
            }
            
            Button(action: {
                if !isDebugging {
                    cameraModel.takePicture()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        selectedImage = UIImage(data: cameraModel.picData)
                        self.isActive = true // Navigate to the next page
                    }
                } else {
                    self.isActive = true
                }
            }) {
                Text("📸 Take Photo")
                    .foregroundColor(isCameraReady ? Color.black : Color.gray.opacity(0.5))
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.white)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
            .disabled(!isCameraReady)
        }
        .background(Constants.appGradient)
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                    cameraModel.stopSession()
            }
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                    cameraModel.startSession()
            }
            //TODO: maybe refactor this to only need 1 permission check?
            requestCameraPermission()
            cameraModel.checkPermission()
            isCameraReady = cameraModel.isCameraAccessGranted()
            cameraModel.clearPicData() // Add this line to clear picData
            selectedImage = nil
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
        .alert(isPresented: $cameraModel.showAlert) {
            Alert(title: Text(cameraModel.alertMessage))
        }
        //TODO: UNCOMMENT THIS WHEN LOCALLY TESTING
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        //TODO: UNCOMMENT THIS WHEN LOCALLY TESTING
    }

    private func requestCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    print("Camera access granted.")
                    DispatchQueue.main.async {
                        self.isCameraReady = true
                    }
                } else {
                    print("Camera access denied.")
                }
            }
        case .authorized:
            print("Camera access already granted.")
            self.isCameraReady = true
        case .restricted, .denied:
            print("Camera access restricted or denied.")
        @unknown default:
            print("Unknown camera access status.")
        }
    }
}

struct CameraView2: View {
    @StateObject private var cameraModel = CameraModel()

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let size = geometry.size
                CameraPreview(size: size)
                    .environmentObject(cameraModel)
            }
            .ignoresSafeArea(.all, edges: .all)
        }
        .alert(isPresented: $cameraModel.showAlert) {
            Alert(title: Text(cameraModel.alertMessage))
        }
    }
}

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    /// View Properties
    @Published var isTaken = false
    @Published var alertMessage: String = ""
    @Published var showAlert = false
    /// Camera Properties
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    @Published var picData = Data(count: 0)
    private var isSettingUpCamera = false
    
    override init() {
        super.init()
        checkPermission()
    }

    func checkPermission() {
        guard !isSettingUpCamera else { return }
        isSettingUpCamera = true

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.global(qos: .userInitiated).async {
                self.setUpCamera()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.setUpCamera()
                    }
                } else {
                    self.showAlertMessage("Camera access denied.")
                }
            }
        case .denied:
            self.showAlertMessage("Please Enable Camera Access in the App Settings!")
        default:
            self.showAlertMessage("Unexpected camera authorization status.")
        }
    }
    
    func isCameraAccessGranted() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    func setUpCamera(_ position: AVCaptureDevice.Position = .front) {
        guard !session.isRunning else { return }

        do {
            session.beginConfiguration()
            // Remove any existing inputs
            session.inputs.forEach { session.removeInput($0) }

            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
                let input = try AVCaptureDeviceInput(device: device)

                if session.canAddInput(input) {
                    session.addInput(input)
                }

                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                session.commitConfiguration()
                
                DispatchQueue.main.async {
                    self.session.startRunning()
                    self.isSettingUpCamera = false
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlertMessage("No camera available.")
                    self.isSettingUpCamera = false
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.showAlertMessage("Error setting up camera: \(error.localizedDescription)")
                self.isSettingUpCamera = false
            }
        }
    }

    func takePicture() {
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }

    func clearPicData() {
        DispatchQueue.main.async {
            self.picData = Data(count: 0)
            self.isTaken = false
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let imageData = photo.fileDataRepresentation() else {
            showAlertMessage("Couldn't capture image, try again!")
            return
        }
        
        self.picData = imageData
        
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation { self.isTaken.toggle() }
            }
        }
    }
    
    func showAlertMessage(_ message: String) {
        alertMessage = message
        showAlert.toggle()
    }

    func stopSession() {
        session.stopRunning()
    }

    func startSession() {
        guard !session.isRunning else { return }
        checkPermission()
    }

    deinit {
        stopSession()
    }
}

struct CameraPreview: UIViewRepresentable {
    var size: CGSize
    @EnvironmentObject private var cameraModel: CameraModel
    
    func makeUIView(context: Context) ->  UIView {
        let view = UIView(frame: .init(origin: .zero, size: size))
        view.backgroundColor = .black

        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraModel.session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {  }
}
