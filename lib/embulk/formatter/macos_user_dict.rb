module Embulk
  module Formatter

    class MacosUserDict < FormatterPlugin
      HEADER=<<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
EOS

      FOOTER=<<-EOS
</array>
</plist>
EOS

      Plugin.register_formatter("macos_user_dict", self)

      def self.transaction(config, schema, &control)
        # configuration code:
        task = {
          "phrase_column" => config.param("phrase_name",:string, default: "phrase"),
          "shortcut_column" => config.param("shortcut_name",:string, default: "shortcut")
        }

        yield(task)
      end

      def init
        # initialization code:
        @phrase_name = task["phrase_column"]
        @shortcut_name = task["shortcut_column"]

        # your data
        @current_file == nil
        @current_file_size = 0
      end

      def close
      end

      def add(page)
        # output code:
        page.each do |record|
          if @current_file == nil 

            @current_file = file_output.next_file
            @current_file.write HEADER
            @current_file_size = 0

          elsif @current_file_size > 32*1024*1024
            @current_file.write FOOTER

            @current_file = file_output.next_file
            @current_file.write HEADER
            @current_file_size = 0

          end
          schema = page.schema.map { |s| s.name }
          record_hash = Hash[schema.zip record]

          @current_file.write <<-EOS
	<dict>
		<key>phrase</key>
		<string>#{record_hash[@phrase_name]}</string>
		<key>shortcut</key>
		<string>#{record_hash[@shortcut_name]}</string>
	</dict>
EOS
        end

      end

      def finish
        if @current_file != nil
          @current_file.write FOOTER
        end

        file_output.finish
      end
    end

  end
end
