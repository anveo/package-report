require "spec_helper"

describe "Reporter" do
  let(:reporter) { PackageReport::Reporter.new }

  before(:each) do
    reporter.stub(:raw_apt_upgrade_text).and_return(<<-EOS.strip_heredoc
      NOTE: This is only a simulation!
            apt-get needs root privileges for real execution.
            Keep also in mind that locking is deactivated,
            so don't depend on the relevance to the real current situation!
      Reading package lists... Done
      Building dependency tree
      Reading state information... Done
      The following packages will be upgraded:
        cloud-init grub-legacy-ec2 libudev0 udev
      4 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
      Inst libudev0 [175-0ubuntu9.4] (175-0ubuntu9.5 Ubuntu:12.04/precise-updates [amd64])
      Inst udev [175-0ubuntu9.4] (175-0ubuntu9.5 Ubuntu:12.04/precise-updates [amd64])
      Inst cloud-init [0.6.3-0ubuntu1.11] (0.6.3-0ubuntu1.12 Ubuntu:12.04/precise-updates [all])
      Inst grub-legacy-ec2 [0.6.3-0ubuntu1.11] (0.6.3-0ubuntu1.12 Ubuntu:12.04/precise-updates [all])
      Conf libudev0 (175-0ubuntu9.5 Ubuntu:12.04/precise-updates [amd64])
      Conf udev (175-0ubuntu9.5 Ubuntu:12.04/precise-updates [amd64])
      Conf cloud-init (0.6.3-0ubuntu1.12 Ubuntu:12.04/precise-updates [all])
      Conf grub-legacy-ec2 (0.6.3-0ubuntu1.12 Ubuntu:12.04/precise-updates [all])
    EOS
    )
  end

  describe ".package_upgrades_available" do
    it "extracts package information" do
      expect(reporter.package_upgrades_available.map(&:name)).to include("libudev0")
    end
  end
end
