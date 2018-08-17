//
//  TMScannerVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 13/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import AVFoundation
import UIKit

class TMQRScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //MARK: Variables
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var completionHandler: ((_ qrcode : String) -> Void)!
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner()
        btnCancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    //MARK: QR Scanner
    func scanner() {
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        let videoInput: AVCaptureDeviceInput

        if let videoCaptureDevice = AVCaptureDevice.default(for: .video) {
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
        }else{
            failed()
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        AlertManager.shared.showAlertTitle(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", buttonsArray: ["OK"]) { (buttonIndex : Int) in
            switch buttonIndex {
            case 0 :
                //OK clicked
                self.captureSession = nil
                self.dismiss(animated: true, completion: nil)
                break
            default:
                break
            }
        }
    }
    //MARK: - UIButton
    func btnCancel()  {
        let btnCancel = UIButton(frame: CGRect(x: self.view.bounds.midX - (GConstant.Screen.Width * 0.4)/2, y: GConstant.Screen.Height - 80, width: (GConstant.Screen.Width * 0.4), height: 50))
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.titleLabel?.textColor = .white
        btnCancel.titleLabel?.font      = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        btnCancel.addTarget(self, action: #selector(btnCancelAction(_:)), for: .touchUpInside)
        view.addSubview(btnCancel)
    }
    //MARK: - UIButton action methods
    @objc private func btnCancelAction(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.completionHandler(stringValue)
        }
        
        dismiss(animated: true)
    }
    
    //MARK: UIViewController Methods
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
