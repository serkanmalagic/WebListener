//
//  ViewController.swift
//  WebListener
//
//  Created by Serkan Malagiç on 22.11.2024.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var timer: Timer?
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let speechSynthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        loadingIndicator.transform = CGAffineTransform.init(scaleX: 4, y: 4)
        loadingIndicator.startAnimating()

    }
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(checkWebsiteForKeyword), userInfo: nil, repeats: true)
        print("Zamanlayıcı başlatıldı. Her 3 dakikada bir kontrol edilecek.")
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        print("Zamanlayıcı durduruldu.")
    }
    
    @objc func checkWebsiteForKeyword() {
        let urlString = "https://www.youtube.com/@RockstarGames/videos"
        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            return
        }
        
        print("Web sitesi kontrol ediliyor...")
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Hata oluştu: \(error)")
                return
            }
            
            guard let data = data, let htmlContent = String(data: data, encoding: .utf8) else {
                print("HTML içeriği alınamadı.")
                return
            }
            
            if htmlContent.lowercased().contains("trailer 2") {
                print("Grand Theft Auto bulundu!")
                self?.playAlertSound()
            } else {
                self?.playAlert2()
                print("bulamadım!")
            }
        }
        
        task.resume()
    }
    
    func playAlertSound() {
        
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }

        guard let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") else {
            print("Ses dosyası bulunamadı.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
            print("Ses çalınıyor!")
        } catch {
            print("Ses dosyası çalınırken hata: \(error)")
        }
        
        let text = "Fragman çıktı amına koyim koş la koşşş"
        speakText(text)
    }
    
    func speakText(_ text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 1.0
        speechSynthesizer.speak(speechUtterance)
    }
    
    func playAlert2() {
        guard let soundURL = Bundle.main.url(forResource: "sound2", withExtension: "mp3") else {
            print("Ses dosyası bulunamadı.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
            print("Ses çalınıyor!")
        } catch {
            print("Ses dosyası çalınırken hata: \(error)")
        }
    }
}

