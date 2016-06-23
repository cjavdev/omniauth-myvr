require 'multi_json'
require 'jwt'
require 'omniauth/strategies/oauth2'
require 'uri'
require 'httplog'
require 'byebug'

module OmniAuth
  module Strategies
    class Myvr < OmniAuth::Strategies::OAuth2
      BASE_SCOPE_URL = "http://local.api.myvr.com:8000/auth/"
      BASE_SCOPES = %w[property_read]
      DEFAULT_SCOPE = 'property_read'

      option :name, 'myvr'
      option :authorize_params, {grant_type: 'authorization_code'}
      option :client_options, {
        :site          => 'http://local.myvr.com:8000/',
        :authorize_url => 'http://local.myvr.com:8000/connect/oauth/auth',
        :token_url     => 'http://api.local.myvr.com:8000/oauth/token/'
      }

      # uid { raw_info['sub'] || verified_email }
      #
      # info do
      #   prune!({
      #     :name       => raw_info['name'],
      #     :email      => verified_email,
      #     :first_name => raw_info['given_name'],
      #     :last_name  => raw_info['family_name'],
      #     :image      => image_url,
      #     :urls => {
      #       'Google' => raw_info['profile']
      #     }
      #   })
      # end
      #
      # extra do
      #   hash = {}
      #   hash[:id_token] = access_token['id_token']
      #   if !options[:skip_jwt] && !access_token['id_token'].nil?
      #     hash[:id_info] = JWT.decode(
      #       access_token['id_token'], nil, false, {
      #         :verify_iss => true,
      #         'iss' => 'accounts.google.com',
      #         :verify_aud => true,
      #         'aud' => options.client_id,
      #         :verify_sub => false,
      #         :verify_expiration => true,
      #         :verify_not_before => true,
      #         :verify_iat => true,
      #         :verify_jti => false,
      #         :leeway => options[:jwt_leeway]
      #       }).first
      #   end
      #   hash[:raw_info] = raw_info unless skip_info?
      #   hash[:raw_friend_info] = raw_friend_info(raw_info['sub']) unless skip_info? || options[:skip_friends]
      #   hash[:raw_image_info] = raw_image_info(raw_info['sub']) unless skip_info? || options[:skip_image_info]
      #   prune! hash
      # end
      #
      # def raw_info
      #   @raw_info ||= access_token.get('https://www.googleapis.com/plus/v1/people/me/openIdConnect').parsed
      # end
      #
      # def raw_friend_info(id)
      #   @raw_friend_info ||= access_token.get("https://www.googleapis.com/plus/v1/people/#{id}/people/visible").parsed
      # end
      #
      # def raw_image_info(id)
      #   @raw_image_info ||= access_token.get("https://www.googleapis.com/plus/v1/people/#{id}?fields=image").parsed
      # end


      def build_access_token
        token_params = {
          :client_secret => client.secret,
          :grant_type => 'authorization_code',
          :parse => true
        }
        verifier = request.params['code']
        client.auth_code.get_token(verifier, token_params)
      end

      private

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

      def get_token_options(redirect_uri)
        { :redirect_uri => redirect_uri }.merge(token_params.to_hash(:symbolize_keys => true))
      end
    end
  end
end
