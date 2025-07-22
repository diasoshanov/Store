import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showWelcome = false

    let onboardingPages = [
        OnboardingPage(
            imageName1: "pg1Img1",
            imageName2: "pg1Img2",
            imageName3: "pg1Img3",
            title: "Fast shipping",
            subtitle: "Get all of your desired sneakers in one place."
        ),
        OnboardingPage(
            imageName1: "pg2Img1",
            imageName2: "pg2Img2",
            imageName3: "pg2Img3",
            title: "Fast shipping",
            subtitle: "Get all of your desired sneakers in one place."
        ),
        OnboardingPage(
            imageName1: "pg3Img1",
            imageName2: "pg3Img2",
            imageName3: "pg3Img3",
            title: "Fast shipping",
            subtitle: "Get all of your desired sneakers in one place."
        )
    ]

    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingPages.count, id: \ .self) { index in
                    OnboardingPageView(page: onboardingPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            VStack {
                Spacer()
                HStack(spacing: 24) {
                    ForEach(0..<onboardingPages.count, id: \ .self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 220)
            }

            VStack {
                Spacer()
                Button(action: {
                    if currentPage < onboardingPages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        showWelcome = true
                    }
                }) {
                    Text(currentPage == onboardingPages.count - 1 ? "Start" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 358, height: 54)
                        .background(Color.black)
                        .cornerRadius(32)
                        .padding(.horizontal, 16)
                }
                .padding(.bottom, 58)
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showWelcome) {
            WelcomePageView()
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            // Слой с кроссовками
            ZStack {
                Image(page.imageName1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 398, height: 532)
                    .offset(x: -45, y: -80)
                Image(page.imageName2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 272, height: 192)
                    .offset(x: 85, y: -170)
                Image(page.imageName3)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 580, height: 442)
                    .offset(x: 10, y: 360)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 80)

            // Bottom sheet
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.gray.opacity(0.9), Color.gray.opacity(1)],
                                startPoint: .top, endPoint: .bottom
                            )
                        ).overlay(content: {
                            VStack(spacing: 16) {
                                Text(page.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(page.subtitle)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom,24)
                            }
                            .padding(.bottom,90)
                        })
                        .frame(width:410, height: 288)
                        .padding(.top,600)
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
} 
