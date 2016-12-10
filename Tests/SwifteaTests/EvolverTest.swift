//
// EvolverTest.swift
// Copyright © 2016 David Piper.
//
// This file is part of Swiftea.
//
// Swiftea is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// Swiftea is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//

import XCTest
@testable import Swiftea

/// A simple EvolutionaryAlgorithm featuring only recombination.
class TestRecombinator: EvolutionaryAlgorithm {
    var counter = 0;
    func initialPopulationSize() -> Int {
        return 5
    }
    final func generateInitialGenotype() -> Int {
        return 1
    }
    final func phenotypeFrom(genotype: Int) -> String {
        return String(genotype)
    }
    final func genotypeFrom(phenotype: String) -> Int {
        return Int(phenotype)!
    }
    final func evaluate(genotype: Int) -> Double {
        return Double(genotype) + 0.5
    }
    final func shouldTerminate() -> Bool {
        counter += 1
        return counter >= 5
    }
    func recombinationProbability() -> Double {
        return 1
    }
    final func selectParentsFrom(population: [(Int, Double)]) -> [(Int, Double)] {
        return population
    }
    func recombine(parents: [(Int, Double)], withProbability probability: Double) -> [Int] {
        return parents.map{ $0.0 + 1 }
    }
    func mutationProbability() -> Double {
        return 0
    }
    func onlyMutateOffspring() -> Bool {
        return false
    }
    func mutate(candidates: [(Int, Double)], withProbability probability: Double) -> [Int] {
        return candidates.map{ $0.0 + 1 }
    }
    final func selectNextGeneration(from evolvedPopulation: [(Int, Double)]) -> [(Int, Double)] {
        let ints = evolvedPopulation.map{ $0.0 }
        let maximum = ints.max()
        return evolvedPopulation.filter{ $0.0 == maximum }
    }
}

/// A simple EvolutionaryAlgorithm featuring only mutation.
class TestMutator: TestRecombinator {
    override func recombinationProbability() -> Double {
        return 0
    }
    override func mutationProbability() -> Double {
        return 1
    }
    override func onlyMutateOffspring() -> Bool {
        return false
    }
}

/// A simple EvolutionaryAlgorithm featuring both recombination and mutation.
class TestBoth: TestRecombinator {
    override func recombinationProbability() -> Double {
        return 1
    }
    override func mutationProbability() -> Double {
        return 1
    }
    override func onlyMutateOffspring() -> Bool {
        return false
    }
}

/// A simple EvolutionaryAlgorithm featuring recombination, and mutation of
/// newly generated offspring only.
class TestMutatingOffspring: TestRecombinator {
    override func recombinationProbability() -> Double {
        return 1
    }
    override func mutationProbability() -> Double {
        return 1
    }
    override func recombine(parents: [(Int, Double)], withProbability probability: Double) -> [Int] {
        return parents.map{ $0.0 }
    }
    override func mutate(candidates: [(Int, Double)], withProbability probability: Double) -> [Int] {
        return candidates.map{ $0.0 - 1 }
    }
    override func onlyMutateOffspring() -> Bool {
        return true
    }
}

class EvolverTests: XCTestCase {

    func testRecombinationOnly() {
        let r = TestRecombinator()
        let result = evolve(algorithm: r)
        let expectedPhenotypes = ["5", "5", "5", "5", "5"]
        let expectedEvalutations = [5.5, 5.5, 5.5, 5.5, 5.5]

        XCTAssertEqual(result.map{ $0.0 }, expectedPhenotypes)
        XCTAssertEqual(result.map{ $0.1 }, expectedEvalutations)
    }

    func testMutationOnly() {
        let m = TestMutator()
        let result = evolve(algorithm: m)
        let expectedPhenotypes = ["5", "5", "5", "5", "5"]
        let expectedEvalutations = [5.5, 5.5, 5.5, 5.5, 5.5]

        XCTAssertEqual(result.map{ $0.0 }, expectedPhenotypes)
        XCTAssertEqual(result.map{ $0.1 }, expectedEvalutations)
    }

    func testRecombindationAndMutation() {
        let b = TestBoth()
        let result = evolve(algorithm: b)
        let expectedPhenotypes = ["9", "9", "9", "9", "9"]
        let expectedEvalutations = [9.5, 9.5, 9.5, 9.5, 9.5]

        XCTAssertEqual(result.map{ $0.0 }, expectedPhenotypes)
        XCTAssertEqual(result.map{ $0.1 }, expectedEvalutations)
    }

    func testOnlyMutatingOffspring() {
        let o = TestMutatingOffspring()
        let result = evolve(algorithm: o)
        let expectedPhenotypes = Array(repeating: "1", count: 80)
        let expectedEvalutations = Array(repeating: 1.5, count: 80)

        XCTAssertEqual(result.map{ $0.0 }, expectedPhenotypes)
        XCTAssertEqual(result.map{ $0.1 }, expectedEvalutations)
    }

    static var allTests : [(String, (EvolverTests) -> () throws -> Void)] {
        return [
            ("testRecombinationOnly", testRecombinationOnly),
            ("testMutationOnly", testMutationOnly),
            ("testRecombindationAndMutation", testRecombindationAndMutation),
            ("testOnlyMutatingOffspring", testOnlyMutatingOffspring)
        ]
    }
}
