//
//  viewModel.swift
//  ImageGeneratorAi
//
//  Created by Bouchedoub Ramzi on 10/2/2023.
//

import Foundation
import SwiftUI
import OpenAIKit

final class ViewModel: ObservableObject {
    
    private var openAI: OpenAI?
    let apiKey = "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"
    
    func setup() {
        openAI = OpenAI(
            Configuration(
                organization: "Personal",
                apiKey: apiKey
            )
        )
    }
    
    func generateImage(from prompt: String) async -> UIImage? {
        guard let openAI = openAI else {
            return nil
        }
        
        let imageParameters = ImageParameters(
            prompt: prompt,
            resolution: .medium,
            responseFormat: .base64Json
        )
    
        do {
            let result = try await openAI.createImage(parameters: imageParameters)
            let imageData = result.data[0].image
            let image = try openAI.decodeBase64Image(imageData)
            return image
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
   
}
