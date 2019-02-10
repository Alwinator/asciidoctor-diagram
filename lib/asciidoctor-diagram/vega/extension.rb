require_relative '../extensions'
require_relative '../util/cli_generator'
require_relative '../util/platform'

module Asciidoctor
  module Diagram
    # @private
    module Vega
      include CliGenerator

      def self.included(mod)
        [:svg, :png].each do |f|
          mod.register_format(f, :image) do |parent, source|
            vega(source, f)
          end
        end
      end

      def vega(source, format)
        base_dir = source.base_dir

        code = source.to_s

        if code.include?('/schema/vega-lite/') || name.to_s.include?('lite') || source.attr('vegalite')
          vega_code = generate_stdin_stdout(souce.find_command("vl2vg"), code)
        else
          vega_code = code
        end

        generate_file(source.find_command("vg2#{format}"), "json", format.to_s, vega_code) do |tool_path, input_path, output_path|
          args = [tool_path, '--base', Platform.native_path(base_dir)]
          if format == :svg
            args << '--header'
          end

          args << Platform.native_path(input_path)
          args << Platform.native_path(output_path)
        end
      end
    end

    class VegaBlockProcessor < Extensions::DiagramBlockProcessor
      include Vega
    end

    class VegaBlockMacroProcessor < Extensions::DiagramBlockMacroProcessor
      include Vega
    end
  end
end
