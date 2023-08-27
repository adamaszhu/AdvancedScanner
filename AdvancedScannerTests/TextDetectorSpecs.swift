// TextDetectorSpecs.swift
// AdvancedScanner
//
// Created by Adamas Zhu on  12/5/2023
// 

import Nimble
import Quick
@testable import AdvancedScanner

final class TextDetectorSpecs: QuickSpec {
    
    override func spec() {
        describe("calls detect()") {
            context("Initialize with creditCardNumber") {
                let textDetector = TextDetector(textTypes: [TextFormat.creditCardNumber])
                context("with a credit card string") {
                    let string = "4444333322221111"
                    it("returns a detection") {
                        let textDetection = textDetector.detect(string)
                        expect(textDetection.textFormat?.name) == TextFormat.creditCardNumber.name
                    }
                }
            }
        }
    }
}
