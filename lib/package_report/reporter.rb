require "erb"
require "fog"

module PackageReport
  class Reporter
    def run!
      packages_info = {}

      package_upgrades_available.sort_by { |pkg| pkg.name }.each do |pkg|
        packages_info[pkg.name] = {
          current_version: pkg.current_version,
          latest_version: pkg.latest_version,
          changelog: pkg.newer_changes
        }
      end

      json = packages_info.to_json
      #puts json

      #connection = Fog::Storage.new({
        #:provider                 => "AWS",
        #:aws_access_key_id        => ENV["AWS_ACCESS_KEY_ID"],
        #:aws_secret_access_key    => ENV["AWS_SECRET_ACCESS_KEY"]
      #})
      connection = Fog::Storage.new({
        provider: "Local",
        local_root: "/vagrant/fog",
        endpoint: "http://example.com"
      })

      dir = connection.directories.create({
        key: "crowdtilt-sysops/2013-04-02"
      })
      dir.files.create(
        key: `hostname`.strip + ".json",
        body: json,
      )
    end

    def build_website!
      # connect to s3
      # each json file
      #   render template or something
      connection = Fog::Storage.new({
        provider: "Local",
        local_root: "/vagrant/fog",
        endpoint: "http://example.com"
      })

      dir = connection.directories.create({
        key: "crowdtilt-sysops/2013-04-02"
      })

      instances = {}
      dir.files.each do |file|
        next if file.key == "index.html"
        instances[file.key] = JSON.parse file.body
      end

      template_path = File.expand_path("../../templates/report.html.erb", __FILE__)
      template_string = File.read(template_path)
      html = ERB.new(template_string).result(binding)

      dir.files.create(
        key: "index.html",
        body: html
      )
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
