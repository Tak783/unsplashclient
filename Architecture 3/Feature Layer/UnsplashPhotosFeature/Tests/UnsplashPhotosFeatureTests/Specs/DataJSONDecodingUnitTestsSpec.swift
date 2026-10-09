//
//  DataJSONDecodingUnitTestsSpec.swift
//  UnsplashPhotosFeature
//
//  Created on 09/10/2026.
//

protocol DataJSONDecodingUnitTestsSpec {
    func test_decodeJSON_decodesValidJSONIntoTheRequestedType() throws
    func test_decodeJSON_convertsSnakeCaseKeysToCamelCase() throws
    func test_decodeJSON_throwsTheGivenFailureWhenDataIsNotJSON()
    func test_decodeJSON_throwsTheGivenFailureWhenARequiredKeyIsMissing()
}
