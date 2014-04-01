module PackageReport
  class Package
    attr_accessor :name, :installed_version, :latest_version, :changelog

    def initialize(package_name, upstream_version)
      @name = package_name
      @latest_version = upstream_version

      # get installed version
      # get latest version
      # get changelog
    end

    def installed_version
      raw_intalled_version.split[1]
    end

    def changelog_parts
      parts = []
      raw_changelog.each_line do |line|
        if line =~ /^\S/
          parts << line
        else
          parts.last << line
        end
      end
      parts
    end

    private

    def raw_intalled_version
      `\dpkg -s #{package_name} | \grep '^Version'`
    end

    def raw_changelog
      `\aptitude changelog #{package_name}`
    end
  end
end
