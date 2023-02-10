//
//  Home.swift
//  ImageGeneratorAi
//
//  Created by Bouchedoub Ramzi on 10/2/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ViewModel()
    @State var prompt: String = ""
    @State var generatedImage: UIImage?
    @State var isLoading: Bool = false
    var body: some View {
        NavigationView{
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("backgroundColor"))
                } else {
                    VStack {
                        Text("DALL-E IMAGE GENERATOR")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.title2)
                            .bold()
                            .offset(y: 10)
                        Spacer()
                        if let generatedImage = generatedImage {
                            Image(uiImage: generatedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height/1.8)
                                .padding(10)
                                .background(Color("bg"))
                        } else {
                            Image("placeholderImage")
                                .resizable()
                                .frame(width: 300, height: 300)
                                .opacity(0.5)
                        }
                        Spacer()
                        Text("ENTER YOUR PROMPT BELOW")
                            .foregroundColor(Color.black)
                            .font(.caption2.bold())
                        TextField("Enter your prompt", text: $prompt)
                                      .padding(7)
                                      .padding(.horizontal, 25)
                                      .background(Color(.systemGray6))
                                      .cornerRadius(8)
                                      .padding(.horizontal, 10)
                        Button{
                            Task {
                                isLoading = true
                                generatedImage = await viewModel.generateImage(from: prompt)
                                isLoading = false
                            }
                        }label: {
                            Text("Generate")
                            .foregroundColor(.white)
                            
                            .onAppear {
                                viewModel.setup()
                            }
                        }
                       
                        .frame(width: 350  ,height: 45)
                        .background(.black)
                        .cornerRadius(25)
                        .padding(.vertical ,15)
    
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                    } label:{
                        Image(systemName: "square.and.arrow.down")
                                                    .font(.system(size: 20))
                                                    .aspectRatio( contentMode: .fit)
                                                    .frame(width: 25, height: 25)
                                                    .padding(10)
                    }
                    .cornerRadius(100)
                            }
                    }
            .navigationTitle("Image Generator Ai")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("backgroundColor"))
        }
    }
    class ImageSaver: NSObject {
        func writeToPhotoAlbum(image: UIImage) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
        }
        @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            print("Save finished!")
        }
    }
}
