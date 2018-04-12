module Fastlane
  module Actions
    class CodecovReporterAction < Action
      def self.run(params)
        UI.message "I am Getting the latest bash script from Codecov.io"
        sh "curl -s -N https://Codecov.io/bash > #{ENV['PWD']}/codecov_reporter.sh"

        params[:token] ||= false

        codecov_args = ["-K"]

        if params[:token] != false
          UI.message "It looks like I'm working with a private repository"
          codecov_args << "-t" << params[:token]
        else
          UI.message "It looks like I'm working with a public repository"
        end

        if params[:derived_data_path]
          UI.message "Setting Derived Data directory to #{params[:derived_data_path]}"
          codecov_args << "-D" << params[:derived_data_path]
        end

        sh "bash #{ENV['PWD']}/codecov_reporter.sh #{codecov_args.join(" ")}"

        UI.message "Removing the bash script I got from Codecov.io"
        sh "rm #{ENV['PWD']}/codecov_reporter.sh"
        UI.message "Removing the created coverage.txt files, if any."
        sh "rm -f *.coverage.txt"
        UI.message "All was well"
      end

      def self.description
        "Uploads coverage report to Codecov.io"
      end

      def self.authors
        ["BinaryBeard"]
      end

      def self.details
        # Optional:
        "Uploads coverage report, from a public or private repository, to Codecov.io"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :token,
                                       env_name: "CODECOV_TOKEN",
                                       description: "Codecov.io private repo token",
                                       is_string: true,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :derived_data_path,
                                       env_name: "DERIVED_DATA_PATH",
                                       description: "Derived Data Path for Coverage.profdata and gcov processing",
                                       is_string: true,
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
