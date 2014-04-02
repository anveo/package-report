module PackageReport
  class Reporter
    def run!
      package_upgrades_available.each do |pkg|
        puts pkg.name
        puts pkg.current_version
        puts pkg.latest_version
        puts pkg.changelog_parts.count
      end
    end

    def package_upgrades_available
      packages = []

      raw_apt_upgrade_text.split("\n").each do |line|
        # skip lines that don't contain a package name
        if line =~ /^Inst/
          packages << Package.from_apt_line(line)
        end
      end

      packages
    end

    def raw_apt_upgrade_text
      `apt-get --just-print upgrade`
    end
  end
end
