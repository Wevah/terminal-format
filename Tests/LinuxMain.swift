import XCTest

import CommandLineFormatTests

var tests = [XCTestCaseEntry]()
tests += CommandLineFormatTests.allTests()
XCTMain(tests)
