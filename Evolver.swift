//
// Evolver.swift
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

public class Evolver<T: EvolutionaryAlgorithm> {
    public static func evolve(algorithm: T) -> [(T.Phenotype, T.Evaluation)] {

        // Generate and evaluate the initial population
        var population: [(chromosome: T.Genotype, evaluation: T.Evaluation)] = []

        let initialPopulationSize = algorithm.initialPopulationSize()
        population.reserveCapacity(initialPopulationSize)
        for _ in 0 ..< initialPopulationSize {
            let genotype = algorithm.generateInitialGenotype()
            let evaluation = algorithm.evaluate(genotype: genotype)
            population.append((genotype, evaluation))
        }

        // Evolve the population
        while !algorithm.shouldTerminate() {
            let matingProbability = algorithm.recombinationProbability()
            let mutatingProbability = algorithm.mutationProbability()

            // Recombination
            let offspring: [(chromosome: T.Genotype, evaluation: T.Evaluation)]
            if matingProbability > 0 {
                let parents = algorithm.selectParentsFrom(population: population)
                let children = algorithm.recombine(parents: parents, withProbability: matingProbability)
                offspring = children.map{ ($0, algorithm.evaluate(genotype: $0)) }
            }
            else {
                offspring = []
            }

            // Mutation
            let mutants: [(chromosome: T.Genotype, evaluation: T.Evaluation)]
            if mutatingProbability > 0 {
                let onlyOffspring = algorithm.onlyMutateOffspring()
                let possibleMutants = (onlyOffspring) ? offspring : population + offspring
                let mutantChildren = algorithm.mutate(offspring: possibleMutants, withProbability: mutatingProbability)
                mutants = mutantChildren.map{ ($0, algorithm.evaluate(genotype: $0)) }
            }
            else {
                mutants = []
            }
            
            // Next generation
            population = algorithm.selectNextGeneration(from: population + offspring + mutants)
        }
        
        // Final population
        return population.map{ (algorithm.phenotypeFrom(genotype: $0.chromosome), $0.evaluation) }
    }
}
