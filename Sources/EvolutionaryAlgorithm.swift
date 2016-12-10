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

/// A protocol that allows the specification of all required statistics
/// and actions to perform any kind of evolutionary algorithm.
public protocol EvolutionaryAlgorithm {
    associatedtype Genotype
    associatedtype Phenotype
    associatedtype Evaluation

    /// The initial population size.
    func initialPopulationSize() -> Int

    /// This function is used to create the initial population. It will be
    /// called the number of times returned by initialPopulationSize().
    func generateInitialGenotype() -> Genotype

    /// The functions for converting between genotype to phenotype spaces.
    func phenotypeFrom(genotype: Genotype) -> Phenotype
    func genotypeFrom(phenotype: Phenotype) -> Genotype

    /// The fitness function. Note that as Evaluation is an associatedtype,
    /// the callee can define any kind of evaluation result and include other
    /// statistics such as the age of each chromosome, for example.
    /// An individual chromosome will only be evaluated once, immediately
    /// after it is created, though can be modified later by the callee.
    func evaluate(genotype: Genotype) -> Evaluation

    /// This function is the stopping condition of the evolution. It will be
    /// called once before every generational step.
    func shouldTerminate() -> Bool

    /// The probability of recombination. Should be a value in [0.0, 1.0].
    func recombinationProbability() -> Double

    /// Allows the callee to select recombination parents from the current
    /// population. Will only be called if the probability of recombination
    /// is non-zero.
    func selectParentsFrom(population: [(Genotype, Evaluation)]) -> [(Genotype, Evaluation)]

    /// In this function the callee should perform recombination based on
    /// the parent selection and the probability of recombination. Will only
    /// be called if the probability of recombination is non-zero.
    func recombine(parents: [(Genotype, Evaluation)], withProbability probability: Double) -> [Genotype]

    /// The probability of recombination. Should be a value in [0.0, 1.0].
    func mutationProbability() -> Double

    /// Indicates whether only new offspring from recombination should be
    /// considered candidates for mutation. If false, the entire population
    /// is considered. Will only be called if the probability of mutation
    /// is non-zero.
    func onlyMutateOffspring() -> Bool

    /// In this function the callee should perform mutation based on the
    /// mutation probability. Will only be called if the probability of
    /// recombination is non-zero.
    func mutate(candidates: [(Genotype, Evaluation)], withProbability probability: Double) -> [Genotype]

    /// Once all recombination and mutations are performed, the callee must
    /// decide which chromosomes survive for the next generation. The callee
    /// need not restrict the new population size to the initial population
    /// size, though this is a common convention.
    /// It is in this function (and others where a chromosome's evaluation
    /// is accessible) that the callee may wish to modify a chromosome's
    /// evaluation - for example updating a chromosome's age. This power is
    /// given to the callee with the understanding that directly modifying
    /// the actual fitness of a given chromosome is an irreversible and
    /// incorrect practice, as a chromosome is only ever evaluated with the
    /// fitness function once, immediately after creation.
    func selectNextGeneration(from evolvedPopulation: [(Genotype, Evaluation)]) -> [(Genotype, Evaluation)]
}
