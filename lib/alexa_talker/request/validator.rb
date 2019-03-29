# frozen_string_literal: true

require 'net/http'
require 'openssl'
require 'base64'
require 'addressable'

module AlexaTalker
  class Request
    class Validator
      attr_reader :request
      attr_reader :certificate_url
      attr_reader :certificate
      attr_reader :signature
      attr_reader :received
      attr_reader :timestamp_tolerance

      def initialize(request, certificate_url: nil, certificate: nil,
                     signature: nil, received: Time.now,
                     timestamp_tolerance: 120)
        if certificate
          raise ArgumentError unless certificate
                                       .is_a?(OpenSSL::X509::Certificate)
        end

        @request = request
        @received = received
        @certificate_url = Addressable::URI.parse(certificate_url).normalize!
        @certificate = certificate
        @timestamp_tolerance = timestamp_tolerance
        @signature = signature
      end

      def valid?
        timestamp_valid?
        certificate_url_valid?
        certificate_valid?
        signature_valid?
        true
      end

      def timestamp_valid?
        time_lower = @received - timestamp_tolerance
        time_upper = @received + timestamp_tolerance
        unless request_timestamp.between?(time_lower, time_upper)
          raise StandardError, 'Invalid timestamp'
        end

        true
      end

      def certificate_valid?
        @certificate ||= download_certificate

        certificate_unexpired?
        certificate_subject_valid?
        certificate_chain_trusted?

        true
      end

      def signature_valid?
        raise ArgumentError unless @certificate
                                     .is_a?(OpenSSL::X509::Certificate)

        pkey = @certificate.public_key
        signature_decoded = Base64.decode64(@signature)
        unless pkey.verify(OpenSSL::Digest::SHA1.new, signature_decoded,
                           @request)
          raise ArgumentError
        end

        true
      end

      def certificate_url_valid?
        raise ArgumentError unless @certificate_url

        unless @certificate_url.scheme == 'https'
          raise StandardError, 'Invalid protocol'
        end

        unless @certificate_url.host == 's3.amazonaws.com'
          raise StandardError, 'Invalid host'
        end

        unless @certificate_url.path[0..9] == '/echo.api/'
          raise StandardError, 'Invalid path'
        end

        unless @certificate_url.inferred_port == 443
          raise StandardError, 'Invalid port'
        end

        true
      end

      def download_certificate(overwrite: false)
        raise StandardError if @certificate && overwrite == false
        raise ArgumentError unless @certificate_url

        certificate_url_valid?
        certificate = nil
        Net::HTTP.start(@certificate_url.host) do |http|
          resp = http.get(@certificate_url.path)
          certificate = OpenSSL::X509::Certificate.new(resp.body)
        end
        certificate
      end

      private

      def request_timestamp
        request_json = JSON.parse(@request, symbolize_names: true)
        Time.parse(request_json[:request][:timestamp])
      end

      def certificate_unexpired?
        unless request_timestamp
                 .between?(@certificate.not_before, @certificate.not_after)
          raise StandardError, 'Certificate expired'
        end

        true
      end

      def certificate_chain_trusted?
        cert_store = OpenSSL::X509::Store.new
        cert_store.set_default_paths

        unless cert_store.verify(@certificate)
          raise StandardError, 'Invalid certificate chain'
        end

        true
      end

      def certificate_subject_valid?
        unless @certificate.subject.to_a.flatten
                 .include?('echo-api.amazon.com')
          raise StandardError, 'Invalid certificate subject'
        end

        true
      end
    end
  end
end
