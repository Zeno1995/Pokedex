//
//  MappingOperation.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

final class MappingOperation<Model: Decodable>: StandardOperation<NetworkResponse, Model, ServiceError> {
    private func dateDecodingStrategy(decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let property = try container.decode(String.self)
        
        guard let date = DateFormatter.iso8601Full.date(from: property) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "MappingOperation: Invalid date!")
        }
        
        return date
    }
    
    override func perform() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(dateDecodingStrategy)
        do {
            let model = try decoder.decode(Model.self, from: input.body)
            return finish(output: model)
        } catch let DecodingError.dataCorrupted(context) {
            #if DEBUG
            print("\n\n☢️☢️☢️ JSONDecoder DataCorrupted \(context)\n\n")
            #endif
        } catch let DecodingError.keyNotFound(key, context) {
            #if DEBUG
            print("\n\n☢️☢️☢️ Key '\(key)' not found: \(context.debugDescription)\ncodingPath:\(context.codingPath)\n\n")
            #endif
        } catch let DecodingError.valueNotFound(value, context) {
            #if DEBUG
            print("\n\n☢️☢️☢️ Value '\(value)' not found: \(context.debugDescription)\ncodingPath:\(context.codingPath)\n\n")
            #endif
        } catch let DecodingError.typeMismatch(type, context)  {
            #if DEBUG
            print("\n\n☢️☢️☢️ Type '\(type)' mismatch: \(context.debugDescription)\ncodingPath:\(context.codingPath)\n\n")
            #endif
        } catch {
            #if DEBUG
            print("\n\n☢️☢️☢️ JSONDecoderError \(error.localizedDescription)\n\n")
            #endif
        }
        throw ServiceError.invalidServerResponse
    }
}
