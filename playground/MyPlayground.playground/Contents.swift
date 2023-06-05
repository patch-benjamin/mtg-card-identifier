import UIKit
import Vision
//
//extension String {
//    subscript (index: Int) -> String? {
//        guard index < count, index > 0 else { return nil }
//        return self[self.index(startIndex, offsetBy: index)]
//    }
//}



enum CardFace: String {
    case front
    case back
}

enum ImageType: String {
    case jpeg = "jpg"
}

//func imageUrl(for scryfallId: String, cardFace: CardFace = .front, fileFormat: ImageType = .jpeg) -> String? {
//    guard !scryfallId.isEmpty, let dir1 = scryfallId[0], let dir2 = scryfallId[1] else { return nil }
//
//    let fileFace = cardFace.rawValue
//    let fileType = "large"
//    let fileFormat = "jpg"
//    return "https://cards.scryfall.io/\(fileType)/\(cardFace)/\(dir1)/\(dir2)/\(scryfallId).\(fileFormat)"
//}


enum Asset: String {
    case card1
    case card2
    case card3
    case card4
    case card5
    case card6
    case card7
    
    var image: UIImage {
        UIImage(named: rawValue + ".png") ?? UIImage(named: rawValue + ".jpg")!
    }
}

func recognizeText(asset: Asset) {
    let image = asset.image
    guard let cgImage = image.cgImage else { return }
    
    let request = VNRecognizeTextRequest { (request, error) in
        guard let observations = request.results as? [VNRecognizedTextObservation],
              error == nil else {
            print("Error recognizing text: \(error?.localizedDescription ?? "Unknown Error")")
            return
        }
        
        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        
        print("Recognized text: \n\(recognizedStrings.joined(separator: "\n"))")
    }
    
    let requests = [request]
    let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    
    do {
        try imageRequestHandler.perform(requests)
    } catch let error as NSError {
        print("Error performing image request: \(error.localizedDescription)")
    }
    print("done!")
}

recognizeText(asset: .card4)

//let fileURL = Bundle.main.url(forResource: "AtomicCards", withExtension: "json")!
//let data = try! Data(contentsOf: fileURL)
//let string = String(data: data, encoding: .utf8)!
//print("\n\n\n")
//print(string.count)
