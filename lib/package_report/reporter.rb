module PackageReport
  class Reporter
    def report
    end

    def package_upgrades_available
      packages = []

      raw_apt_upgrade_text.each_line do |line|
        # skip lines that don't contain a package name
        if line =~ /^Inst|Conf/
          packages << line.split[1]
        end
      end

      packages.uniq
    end

    def raw_apt_upgrade_text
      `apt-get --just-print upgrade`.split("\n")
    end
  end
end
