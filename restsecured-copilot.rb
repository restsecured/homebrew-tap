# Documentation: https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula

class RestsecuredCopilot < Formula
  desc "Rest Secured Copilot - Security Consultant at your service"
  homepage "https://www.restsecured.xyz"
  url "https://github.com/stankiewicz/restsecured-copilot/archive/0.1.0.tar.gz"
  version "0.1.0"
  sha256 "19589b020e7464c4c32d92ba5faa06fecf50dd15b318c81a23f55667c824968b"

  # depends_on "cmake" => :build
  depends_on :python
  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.1.tar.gz"
    sha1 "f906c441be2f0e7a834cbf701a72788d3ac3d144"
  end
  resource "transitions" do
    url "https://github.com/tyarkoni/transitions/archive/0.4.0.tar.gz"
    sha1 "065611458c52e58fd40cc35f57167972fc627035"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[requests transitions].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec
    # ENV.deparallelize  # if your formula fails when building in parallel
    bin.install "rsc"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/rsc", "-h"
  end
end
