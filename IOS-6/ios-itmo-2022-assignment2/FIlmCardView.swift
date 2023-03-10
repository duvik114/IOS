import SwiftUI

struct FIlmCardView: View {
    let rate: Int
    let filmName: String
    let director: String
    let imageName: String
    @State private var isShareOpened: Bool = false
    
    init(_ filmName: String, _ director: String, _ rate: Int, _ imageName: String) {
        self.rate = rate
        self.filmName = filmName
        self.director = director
        self.imageName = imageName
    }
    
    var body: some View {
        GeometryReader { info in
            ZStack{
                Image(imageName)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                
                Button(action: { self.isShareOpened = true }) { Image("share") }
                .sheet(isPresented: $isShareOpened, onDismiss: {}, content: {
                    SharedViewController(sharedItems: [URL(string: "https://www.apple.com")!])
                })
                .offset(x: (info.size.width / 2) - 30, y:  20 - (info.size.height / 2))
                .frame(width: 40, height: 50)
                
                VStack{
                    HStack{}.padding(.bottom, info.size.height / 1.25)
                    Text(filmName)
                        .font(.headline)
                        .padding(.bottom, 4.0)
                        .foregroundColor(Color.white)
                    Text(director)
                        .font(.headline)
                        .padding(.bottom, 8.0)
                        .foregroundColor(Color.gray)
                    HStack{
                        Text(String(rate) + "/5")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        ForEach(0..<rate){_ in
                            Image("smallStar")
                        }
                    }
                }
            }
        }
    }
}

struct SharedViewController: UIViewControllerRepresentable {
    var sharedItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<SharedViewController>) -> UIActivityViewController {
        let controll = UIActivityViewController(activityItems: sharedItems,
                                                applicationActivities: applicationActivities)
        return controll
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<SharedViewController>) {}
}
