import SwiftUI

struct DualCameraView: View {
    enum Step {
        case back
        case front
        case done
    }
    
    private static let prompts = [
        "Capture something red.",
        "Photograph your favorite snack.",
        "Find and photograph something round.",
        "Take a picture of a shadow.",
        "Shoot a photo of something textured.",
        "Capture a reflection.",
        "Photograph something blue.",
        "Find and photograph a pattern.",
        "Take a picture of something shiny.",
        "Shoot a photo of something old.",
        "Capture something green.",
        "Photograph a close-up of a leaf.",
        "Find and photograph something yellow.",
        "Take a picture of your shoes.",
        "Shoot a photo of something tall.",
        "Capture something small.",
        "Photograph a street sign.",
        "Find and photograph something that makes you smile.",
        "Take a picture of the sky.",
        "Shoot a photo of a flower.",
        "Capture something that moves.",
        "Photograph your favorite book.",
        "Find and photograph something soft.",
        "Take a picture of a door handle.",
        "Shoot a photo of a cup or mug.",
        "Capture something colorful.",
        "Photograph a shadow of a tree.",
        "Find and photograph a reflection in water.",
        "Take a picture of something metallic.",
        "Shoot a photo of something that looks old-fashioned.",
        "Capture something that smells good.",
        "Photograph a handwritten note.",
        "Find and photograph a toy.",
        "Take a picture of a clock.",
        "Shoot a photo of a bike.",
        "Capture something that makes noise.",
        "Photograph a pair of glasses.",
        "Find and photograph a hat.",
        "Take a picture of a staircase.",
        "Shoot a photo of a window.",
        "Capture something that’s your favorite color.",
        "Photograph a piece of jewelry.",
        "Find and photograph your favorite food.",
        "Take a picture of a pet or animal.",
        "Shoot a photo of the floor.",
        "Capture the pattern of stripes.",
        "Photograph something with polka dots.",
        "Find and photograph something round.",
        "Take a picture of a plant pot.",
        "Shoot a photo of a bicycle wheel.",
        "Capture something soft like fabric.",
        "Photograph your favorite shoes.",
        "Find and photograph something with buttons.",
        "Take a picture of a lamp.",
        "Shoot a photo of a book spine.",
        "Capture the texture of wood.",
        "Photograph a reflection in a mirror.",
        "Find and photograph a colorful wall.",
        "Take a picture of a fruit.",
        "Shoot a photo of a city street.",
        "Capture something glowing or lit.",
        "Photograph a favorite hobby item.",
        "Find and photograph a handwritten sign.",
        "Take a picture of a clock face.",
        "Shoot a photo of a key.",
        "Capture something transparent.",
        "Photograph a favorite piece of clothing.",
        "Find and photograph a pair of shoes.",
        "Take a picture of a bicycle.",
        "Shoot a photo of a pet collar.",
        "Capture something that’s a souvenir.",
        "Photograph an interesting shadow.",
        "Find and photograph something that’s broken.",
        "Take a picture of a flower pot.",
        "Shoot a photo of a hat or cap.",
        "Capture something with words on it.",
        "Photograph a favorite toy.",
        "Find and photograph a picture frame.",
        "Take a picture of a chair.",
        "Shoot a photo of a watch or clock.",
        "Capture something round or circular.",
        "Photograph a favorite snack packaging.",
        "Find and photograph a sticker.",
        "Take a picture of a phone or gadget.",
        "Shoot a photo of the ceiling.",
        "Capture something that’s striped.",
        "Photograph a favorite beverage.",
        "Find and photograph a colorful poster.",
        "Take a picture of a pair of sunglasses.",
        "Shoot a photo of a door.",
        "Capture something that smells nice.",
        "Photograph a favorite tool.",
        "Find and photograph something you made.",
        "Take a picture of a cozy corner.",
        "Shoot a photo of footwear.",
        "Capture something that’s fuzzy.",
        "Photograph a favorite snack wrapper.",
        "Find and photograph a colorful pen or pencil."
    ]
    
    @State private var step: Step = .back
    @State private var backPhoto: UIImage?
    @State private var frontPhoto: UIImage?
    @State private var currentPrompt: String?
    
    var body: some View {
        VStack {
            switch step {
            case .back:
                VStack {
                    Text(currentPrompt ?? "...")
                        .font(.headline)
                        .padding()
                    
                    CameraView(position: .back) { image in
                        backPhoto = image
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
                    
                    if let backPhoto = backPhoto {
                        Image(uiImage: backPhoto)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()
                    }
                    
                    HStack {
                        Button("Retake") {
                            backPhoto = nil
                            currentPrompt = DualCameraView.prompts.randomElement()
                        }
                        .padding()
                        
                        Button(backPhoto == nil ? "Capture" : "Next") {
                            if backPhoto == nil {
                                // Trigger capture handled inside CameraView
                                // Here just proceed when photo is set via binding.
                            } else {
                                step = .front
                            }
                        }
                        .disabled(backPhoto == nil)
                        .padding()
                    }
                }
                .onAppear {
                    if currentPrompt == nil {
                        currentPrompt = DualCameraView.prompts.randomElement()
                    }
                }
                
            case .front:
                VStack {
                    Text("Take a selfie")
                        .font(.title)
                        .padding()
                    
                    CameraView(position: .front) { image in
                        frontPhoto = image
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
                    
                    if let frontPhoto = frontPhoto {
                        Image(uiImage: frontPhoto)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()
                    }
                    
                    HStack {
                        Button("Retake") {
                            frontPhoto = nil
                        }
                        .padding()
                        
                        Button(frontPhoto == nil ? "Capture" : "Finish") {
                            if frontPhoto == nil {
                                // Capture handled inside CameraView
                            } else {
                                step = .done
                            }
                        }
                        .disabled(frontPhoto == nil)
                        .padding()
                    }
                }
                
            case .done:
                VStack(spacing: 20) {
                    Text("Photos Captured")
                        .font(.largeTitle)
                        .padding()
                    
                    if let backPhoto = backPhoto {
                        VStack(alignment: .leading) {
                            Text("Back Photo (Prompt):")
                                .font(.headline)
                            Text(currentPrompt ?? "")
                                .italic()
                        }
                        Image(uiImage: backPhoto)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    if let frontPhoto = frontPhoto {
                        VStack(alignment: .leading) {
                            Text("Selfie:")
                                .font(.headline)
                        }
                        Image(uiImage: frontPhoto)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button("Restart") {
                        backPhoto = nil
                        frontPhoto = nil
                        currentPrompt = nil
                        step = .back
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}
