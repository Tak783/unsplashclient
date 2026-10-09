//
//  URLRequestHTTPMethodUnitTestsSpec.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

protocol URLRequestHTTPMethodUnitTestsSpec {
    func test_httpMethodRawValues_areUppercased()
    func test_initWithMethod_setsHTTPMethodAndURL() throws
    func test_setValueForHeaderFieldName_setsTheNamedHeader() throws
}
