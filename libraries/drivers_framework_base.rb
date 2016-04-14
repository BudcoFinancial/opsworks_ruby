# frozen_string_literal: true
module Drivers
  module Framework
    class Base < Drivers::Base
      include Drivers::Dsl::Output

      def out
        handle_output(raw_out)
      end

      def raw_out
        node['defaults']['framework'].merge(
          node['deploy'][app['shortname']]['framework'] || {}
        ).symbolize_keys
      end

      def validate_app_engine
      end
    end
  end
end
