import SwiftUI

struct SFEmoji: View {
    
    let systemName: String
    let color: Color
    var size: CGFloat = 36
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.5, weight: .semibold))
            .foregroundColor(color)
            .frame(width: size, height: size)
            .background(
                color.opacity(0.15)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SFEmojiCapsule: View {
    
    let systemName: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemName)
            Text(text)
        }
        .font(.caption.bold())
        .foregroundColor(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.15))
        .clipShape(Capsule())
    }
}

struct SFEmojiHeader: View {
    
    let systemName: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            SFEmoji(systemName: systemName, color: color)
            Text(title)
                .font(.headline)
        }
    }
}
