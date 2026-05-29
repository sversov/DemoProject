import SwiftUI

/// Renders text if non-nil, otherwise an animated shimmer placeholder.
struct SkeletonText: View {
    let text: String?
    var width: CGFloat = 120
    var height: CGFloat = 16

    @State private var phase: CGFloat = 0

    var body: some View {
        if let text {
            Text(text)
        } else {
            RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient(
                    colors: [.gray.opacity(0.15), .gray.opacity(0.30), .gray.opacity(0.15)],
                    startPoint: .init(x: phase - 0.3, y: 0),
                    endPoint: .init(x: phase + 0.3, y: 0)
                ))
                .frame(width: width, height: height)
                .onAppear {
                    withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                        phase = 1.3
                    }
                }
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        SkeletonText(text: "Concrete value")
        SkeletonText(text: nil, width: 180)
        SkeletonText(text: nil, width: 90, height: 22)
    }
    .padding()
}
