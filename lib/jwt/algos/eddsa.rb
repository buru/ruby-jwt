module JWT
  module Algos
    module Eddsa
      module_function

      SUPPORTED = %w[ED25519 Ed25519 EDDSA EdDSA].freeze

      def sign(to_sign)
        algorithm, msg, key = to_sign.values
        raise EncodeError, "Key given is a #{key.class} but has to be an RbNaCl::Signatures::Ed25519::SigningKey" if key.class != RbNaCl::Signatures::Ed25519::SigningKey
        raise IncorrectAlgorithm, "payload algorithm is #{algorithm} but #{key.primitive} signing key was provided" unless valid_algorithm?(algorithm, key)
        key.sign(msg)
      end

      def verify(to_verify)
        algorithm, public_key, signing_input, signature = to_verify.values
        raise IncorrectAlgorithm, "payload algorithm is #{algorithm} but #{public_key.primitive} verification key was provided" unless valid_algorithm?(algorithm, public_key)
        raise DecodeError, "key given is a #{public_key.class} but has to be a RbNaCl::Signatures::Ed25519::VerifyKey" if public_key.class != RbNaCl::Signatures::Ed25519::VerifyKey
        public_key.verify(signature, signing_input)
      end

      def valid_algorithm?(algorithm, key)
        algorithm.downcase.to_sym == key.primitive ||
          (SUPPORTED.include?(algorithm) && SUPPORTED.map(&:to_sym).map(&:downcase).include?(key.primitive))
      end
    end
  end
end
