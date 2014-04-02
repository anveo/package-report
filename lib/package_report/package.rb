module PackageReport
  class Package
    attr_accessor :name, :current_version, :latest_version, :changelog

    def initialize(package_name = nil, current_version = nil, latest_version = nil)
      @name = package_name
      @current_version = current_version
      @latest_version = latest_version

      # get installed version
      # get latest version
      # get changelog
    end

    def self.from_apt_line(line)
      parts = line.split
      name = parts[1]
      current_version = parts[2].gsub(/\[|\]/, "")
      latest_version = parts[3].gsub(/\(/, "")

      self.new name, current_version, latest_version
    end

    def fetch_version!
      @current_version = raw_installed_version.split[1]
    end

    def newer_changes
      newer = []
      changelog_parts.each do |part|
      end
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

    def raw_installed_version
      `\dpkg -s #{@name} | \grep '^Version'`
    end

    def raw_changelog
      `aptitude changelog #{@name}`
    end
  end
end
