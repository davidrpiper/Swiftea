//
// EvolutionaryAlgorithm.swift
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

public protocol EvolutionaryAlgorithm {
    associatedtype Genotype
    associatedtype Phenotype
    associatedtype Evaluation

    /// Say 'n'
    func initialPopulationSize() -> Int

    /// Called n times
    func generateInitialGenotype() -> Genotype

    /// Convert between genotype and phenotype spaces
    func phenotypeFrom(genotype: Genotype) -> Phenotype
    func genotypeFrom(phenotype: Phenotype) -> Genotype

    /// Fitness function and other stats (e.g. age)
    func evaluate(genotype: Genotype) -> Evaluation

    /// Stopping condition of evoluation
    func shouldTerminate() -> Bool

    /// Select parents from the evaluated population
    /// [0.0, 1.0]
    func recombinationProbability() -> Double
    func selectParentsFrom(population: [(Genotype, Evaluation)]) -> [(Genotype, Evaluation)]
    func recombine(parents: [(Genotype, Evaluation)], withProbability: Double) -> [Genotype]

    /// [0.0, 1.0]
    /// Should not depend on the evaluation of the provided genotypes
    func mutationProbability() -> Double
    func onlyMutateOffspring() -> Bool
    func mutate(offspring: [(Genotype, Evaluation)], withProbability: Double) -> [Genotype]

    // Left to the implementation to restrict size
    func selectNextGeneration(from evolvedPopulation: [(Genotype, Evaluation)]) -> [(Genotype, Evaluation)]
}
