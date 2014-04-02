require "spec_helper"

describe "Package" do
  let(:package) { PackageReport::Package.new }

  before(:each) do
    package.stub(:raw_installed_version).and_return("Version: 1.8.3p1-1ubuntu3.3")
    package.stub(:raw_changelog).and_return(<<-EOS.strip_heredoc
      sudo (1.8.3p1-1ubuntu3.6) precise-security; urgency=medium

        * SECURITY UPDATE: security policy bypass when env_reset is disabled
          - debian/patches/CVE-2014-0106.patch: fix logic inversion in
            plugins/sudoers/env.c.
          - CVE-2014-0106
        * debian/sudo.sudo.init, debian/sudo-ldap.sudo.init: Set timestamps to
          epoch in init scripts so they are properly invalidated. (LP: #1223297)

       -- Marc Deslauriers <marc.deslauriers@ubuntu.com>  Tue, 11 Mar 2014 07:56:53 -0400

      sudo (1.8.3p1-1ubuntu3.4) precise-security; urgency=low

        * SECURITY UPDATE: authentication bypass via clock set to epoch
          - debian/patches/CVE-2013-1775.patch: ignore time stamp file if it is
            set to epoch in plugins/sudoers/check.c.
          - CVE-2013-1775

       -- Marc Deslauriers <marc.deslauriers@ubuntu.com>  Wed, 27 Feb 2013 13:34:15 -0500

      sudo (1.8.3p1-1ubuntu3.3) precise-proposed; urgency=low

        * debian/patches/pam_env_merge.patch: Merge the PAM environment into the
          user environment (LP: #982684)
        * debian/sudo.pam: Use pam_env to read /etc/environment and
          /etc/default/locale environment files. Reading ~/.pam_environment is not
          permitted due to security reasons.

       -- Tyler Hicks <tyhicks@canonical.com>  Mon, 21 May 2012 00:48:10 -0500

      sudo (1.8.3p1-1ubuntu3.2) precise-security; urgency=low

        * SECURITY UPDATE: Properly handle multiple netmasks in sudoers Host and
          Host_List values
          - debian/patches/CVE-2012-2337.patch: Don't perform IPv6 checks on IPv4
            addresses. Based on upstream patch.
          - CVE-2012-2337

       -- Tyler Hicks <tyhicks@canonical.com>  Tue, 15 May 2012 23:28:04 -0500

      sudo (1.8.3p1-1ubuntu3.1) precise-proposed; urgency=low

        * Fix Abort in some PAM modules when timestamp is valid. (LP: #927828)

       -- TJ (Ubuntu Contributions) <ubuntu@tjworld.net>  Mon, 30 Apr 2012 18:05:21 +0100
   EOS
    )
  end

  describe "#new" do
  end

  describe "#from_apt_line" do
    it "extracts package information" do
      package = PackageReport::Package.from_apt_line("Inst libudev0 [175-0ubuntu9.4] (175-0ubuntu9.5 Ubuntu:12.04/precise-updates [amd64])")
      expect(package.name).to eq("libudev0")
      expect(package.current_version).to eq("175-0ubuntu9.4")
      expect(package.latest_version).to eq("175-0ubuntu9.5")
    end
  end

  describe ".changelog_parts" do
    it "parses the correct amount of changes" do
      expect(package.changelog_parts.count).to be(5)
    end
  end

  describe ".fetch_version!" do
    it "parses the correct version" do
      package.current_version = nil
      package.fetch_version!
      expect(package.current_version).to eq("1.8.3p1-1ubuntu3.3")
    end
  end

  describe ".newer_changes" do
    it "only returns parts of the changelog that contain newer versions" do
      package.current_version = "1.8.3p1-1ubuntu3.3"
      expect(package.newer_changes.count).to be(2)
    end
  end
end
