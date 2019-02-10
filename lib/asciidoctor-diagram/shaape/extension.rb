require_relative '../extensions'
require_relative '../util/cli_generator'
require_relative '../util/platform'

module Asciidoctor
  module Diagram
    # @private
    module Shaape
      include CliGenerator

      def self.included(mod)
        [:png, :svg].each do |f|
          mod.register_format(f, :image) do |parent, source|
            shaape(source, f)
          end
        end
      end

      def shaape(source, format)
        generate_stdin(source.find_command('shaape'), format.to_s, source.to_s) do |tool_path, output_path|
          [tool_path, '-o', Platform.native_path(output_path), '-t', format.to_s, '-']
        end
      end
    end

    class ShaapeBlockProcessor < Extensions::DiagramBlockProcessor
      include Shaape
    end

    class ShaapeBlockMacroProcessor < Extensions::DiagramBlockMacroProcessor
      include Shaape
    end
  end
end
