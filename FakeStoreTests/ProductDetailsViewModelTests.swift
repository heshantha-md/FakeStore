//
//  ProductDetailsViewModelTests.swift
//  FakeStoreTests
//
//  Created by Heshantha Don on 10/01/2024.
//

import XCTest
@testable import FakeStore

final class ProductDetailsViewModelTests: XCTestCase {

    // MARK: - PROPERTIES
    var viewModel: ProductDetailsViewModel?
    
    override func setUpWithError() throws {
        viewModel = ProductDetailsViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    // MARK: - FUNCTIONS
    func testProductDetailsViewModeladdToCartValidProductSuccess() async {
        guard let viewModel else { return XCTFail() }
        viewModel.product = StoreService.mocProducts[0]
        
        do {
            try await viewModel.addToCart()
            XCTAssertGreaterThan(viewModel.cartItems.count, 0)
        } catch {
            XCTFail()
        }
    }
    
    func testProductDetailsViewModeladdToCartInvalidProductFail() async {
        guard let viewModel else { return XCTFail() }
        
        do {
            try await viewModel.addToCart()
            XCTAssertEqual(viewModel.cartItems.count, 0)
        } catch {
            XCTAssertEqual(error as? ValidationError, ValidationError.emptyProduct)
        }
    }
}
