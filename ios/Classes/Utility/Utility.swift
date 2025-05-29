//
//  CustomFont.swift
//  Pods
//
//  Created by Yriy Malyts on 12.05.2025.
//

final class Utility {
    enum CustomFonts {
        static let circularStdBold = "CircularStd-Bold"
        static let circularStdBook = "CircularStd-Book"
        static let circularStdMedium = "CircularStd-Medium"
    }
    
    static func registerAllCustomFonts() {
        registerCustomFont(withName: CustomFonts.circularStdBold)
        registerCustomFont(withName: CustomFonts.circularStdBook)
        registerCustomFont(withName: CustomFonts.circularStdMedium)
    }
    
    private static func registerCustomFont(withName name: String, fileExtension: String = "ttf") {
        let bundle = Bundle(for: Self.self) // Use the current class for plugin context
        
        guard let fontPath = bundle.path(forResource: name, ofType: "ttf"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: fontPath)),
              let provider = CGDataProvider(data: data as CFData),
              let font = CGFont(provider) else {
            print("❌ Could not load font '\(name)' from bundle.")
            return
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if !success {
            if let cfError = error?.takeUnretainedValue() {
                print("❌ Failed to register font '\(name)': \(cfError.localizedDescription)")
            } else {
                print("❌ Failed to register font '\(name)': Unknown error.")
            }
            return
        }
        
        print("✅ Successfully registered font '\(name)'")
        return
    }
}
