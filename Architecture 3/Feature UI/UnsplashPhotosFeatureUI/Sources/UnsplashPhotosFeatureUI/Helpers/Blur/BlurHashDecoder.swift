//
//  BlurHashDecoder.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import UIKit
import CoreNetworking
import UnsplashPhotosFeature

public nonisolated enum BlurHashDecoder {
    private static let base83Characters = Array(
        "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~"
    )

    public static func decode(_ blurHash: String, outputSize: CGSize) -> UIImage? {
        let blurHashCharacters = Array(blurHash)
        guard blurHashCharacters.count >= 6 else { return nil }

        guard let encodedComponentCounts = decodeBase83(blurHashCharacters[0 ..< 1]) else {
            return nil
        }
        let componentColumnCount = (encodedComponentCounts % 9) + 1
        let componentRowCount = (encodedComponentCounts / 9) + 1
        let totalComponentCount = componentColumnCount * componentRowCount

        guard blurHashCharacters.count == 4 + 2 * totalComponentCount else { return nil }
        guard let quantisedMaximumValue = decodeBase83(blurHashCharacters[1 ..< 2]) else {
            return nil
        }
        let maximumComponentValue = Float(quantisedMaximumValue + 1) / 166

        var colourComponents: [(Float, Float, Float)] = []
        colourComponents.reserveCapacity(totalComponentCount)

        for componentIndex in 0 ..< totalComponentCount {
            if componentIndex == 0 {
                guard let encodedValue = decodeBase83(blurHashCharacters[2 ..< 6]) else {
                    return nil
                }
                colourComponents.append(averageColour(fromEncodedValue: encodedValue))
            } else {
                let characterStartIndex = 4 + componentIndex * 2
                guard let encodedValue = decodeBase83(
                    blurHashCharacters[characterStartIndex ..< characterStartIndex + 2]
                ) else {
                    return nil
                }
                colourComponents.append(
                    detailColour(
                        fromEncodedValue: encodedValue,
                        maximumComponentValue: maximumComponentValue
                    )
                )
            }
        }

        return renderImage(
            from: colourComponents,
            componentColumnCount: componentColumnCount,
            componentRowCount: componentRowCount,
            outputSize: outputSize
        )
    }
}

// MARK: - Rendering
public nonisolated extension BlurHashDecoder {
    private static func renderImage(
        from colourComponents: [(Float, Float, Float)],
        componentColumnCount: Int,
        componentRowCount: Int,
        outputSize: CGSize
    ) -> UIImage? {
        let pixelWidth = Int(outputSize.width)
        let pixelHeight = Int(outputSize.height)
        guard pixelWidth > 0, pixelHeight > 0 else { return nil }

        let bytesPerRow = pixelWidth * 4
        var pixelBytes = [UInt8](repeating: 255, count: bytesPerRow * pixelHeight)

        for pixelY in 0 ..< pixelHeight {
            for pixelX in 0 ..< pixelWidth {
                var redTotal: Float = 0
                var greenTotal: Float = 0
                var blueTotal: Float = 0

                for componentRow in 0 ..< componentRowCount {
                    for componentColumn in 0 ..< componentColumnCount {
                        let horizontalWave = cos(
                            Float.pi * Float(pixelX) * Float(componentColumn) / Float(pixelWidth)
                        )
                        let verticalWave = cos(
                            Float.pi * Float(pixelY) * Float(componentRow) / Float(pixelHeight)
                        )
                        let waveStrength = horizontalWave * verticalWave
                        let colourComponent = colourComponents[
                            componentColumn + componentRow * componentColumnCount
                        ]
                        redTotal += colourComponent.0 * waveStrength
                        greenTotal += colourComponent.1 * waveStrength
                        blueTotal += colourComponent.2 * waveStrength
                    }
                }

                let byteOffset = pixelY * bytesPerRow + pixelX * 4
                pixelBytes[byteOffset] = linearToSRGB(redTotal)
                pixelBytes[byteOffset + 1] = linearToSRGB(greenTotal)
                pixelBytes[byteOffset + 2] = linearToSRGB(blueTotal)
            }
        }

        guard let pixelDataProvider = CGDataProvider(data: Data(pixelBytes) as CFData) else {
            return nil
        }
        guard let decodedCGImage = CGImage(
            width: pixelWidth,
            height: pixelHeight,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
            provider: pixelDataProvider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            return nil
        }

        return UIImage(cgImage: decodedCGImage)
    }
}

// MARK: - Base 83 Decoding
public nonisolated extension BlurHashDecoder {
    private static func decodeBase83(_ encodedCharacters: ArraySlice<Character>) -> Int? {
        var decodedValue = 0
        for encodedCharacter in encodedCharacters {
            guard let digitValue = base83Characters.firstIndex(of: encodedCharacter) else {
                return nil
            }
            decodedValue = decodedValue * 83 + digitValue
        }
        return decodedValue
    }
}

// MARK: - Colour Components
public nonisolated extension BlurHashDecoder {
    private static func averageColour(fromEncodedValue encodedValue: Int) -> (Float, Float, Float) {
        (
            sRGBToLinear(encodedValue >> 16),
            sRGBToLinear((encodedValue >> 8) & 255),
            sRGBToLinear(encodedValue & 255)
        )
    }

    private static func detailColour(
        fromEncodedValue encodedValue: Int,
        maximumComponentValue: Float
    ) -> (Float, Float, Float) {
        let quantisedRed = encodedValue / (19 * 19)
        let quantisedGreen = (encodedValue / 19) % 19
        let quantisedBlue = encodedValue % 19
        return (
            signPreservingSquare((Float(quantisedRed) - 9) / 9) * maximumComponentValue,
            signPreservingSquare((Float(quantisedGreen) - 9) / 9) * maximumComponentValue,
            signPreservingSquare((Float(quantisedBlue) - 9) / 9) * maximumComponentValue
        )
    }

    private static func signPreservingSquare(_ value: Float) -> Float {
        (value < 0 ? -1 : 1) * value * value
    }
}

// MARK: - Colour Space Conversion
public nonisolated extension BlurHashDecoder {
    private static func sRGBToLinear(_ eightBitValue: Int) -> Float {
        let normalisedValue = Float(eightBitValue) / 255
        return normalisedValue <= 0.04045
            ? normalisedValue / 12.92
            : pow((normalisedValue + 0.055) / 1.055, 2.4)
    }

    private static func linearToSRGB(_ linearValue: Float) -> UInt8 {
        let clampedValue = max(0, min(1, linearValue))
        let sRGBValue = clampedValue <= 0.0031308
            ? clampedValue * 12.92
            : 1.055 * pow(clampedValue, 1 / 2.4) - 0.055
        return UInt8(max(0, min(255, sRGBValue * 255 + 0.5)))
    }
}
