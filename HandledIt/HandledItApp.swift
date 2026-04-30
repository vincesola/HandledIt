import SwiftUI

@main
struct HandledItApp: App {
    @StateObject private var store = HandledItStore()

    // TODO: Cross-check future refinements against Brand/, Splash/, and Docs/ before changing in-app branding.
    var body: some Scene {
        WindowGroup {
            LaunchRootView()
                .environmentObject(store)
        }
    }
}

private struct LaunchRootView: View {
    @State private var showsSplash = true
    @State private var splashIsVisible = false

    var body: some View {
        ZStack {
            ContentView()
                .opacity(showsSplash ? 0 : 1)

            if showsSplash {
                SplashScreenView(isVisible: splashIsVisible)
                    .transition(.opacity)
            }
        }
        .task {
            guard showsSplash else {
                return
            }

            withAnimation(.easeOut(duration: 0.35)) {
                splashIsVisible = true
            }

            try? await Task.sleep(for: .seconds(1.2))

            withAnimation(.easeInOut(duration: 0.3)) {
                showsSplash = false
            }
        }
    }
}

private struct SplashScreenView: View {
    let isVisible: Bool

    var body: some View {
        ZStack {
            Color.handledBackground
                .ignoresSafeArea()

            VStack(spacing: 16) {
                BrandMarkView(size: 64)

                VStack(spacing: 6) {
                    Text("HandledIt")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.handledTextPrimary)

                    Text("Life, handled.")
                        .font(.headline)
                        .foregroundColor(.handledPrimary)
                }
            }
            .scaleEffect(isVisible ? 1 : 0.96)
            .opacity(isVisible ? 1 : 0)
        }
    }
}
