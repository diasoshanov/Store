import SwiftUI

struct WelcomePageView: View {
    @State private var showAuth = false
    @State private var isSignUp = false

    var body: some View {
        ZStack {
            if !showAuth {
                Image("welcomeImg1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 228, height: 228)
                    .offset(x: -85, y: 30)
                Image("welcomeImg2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 246, height: 246)
                    .offset(x: 75, y: -50)
                Image("welcomeImg3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 390, height: 560)
                    .ignoresSafeArea()
                    .offset(x: 40,y: -280)
                VStack {
                    Spacer()
                    Text("Welcome to the biggest \nsneakers store app")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 24)
                    VStack(spacing: 8) {
                        Button(action: {
                            isSignUp = true
                            showAuth = true
                        }) {
                            Text("Sign Up")
                                .font(.headline)
                                .frame(width: 358, height: 54)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(32)
                        }
                        Button(action: {
                            isSignUp = false
                            showAuth = true
                        }) {
                            Text("I already have an account")
                                .font(.headline)
                                .frame(width: 358, height: 54)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .fullScreenCover(isPresented: $showAuth) {
            AuthViewWithMode(isSignUp: isSignUp, onDismiss: { showAuth = false })
        }
    }
}



