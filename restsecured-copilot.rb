# Documentation: https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula

class RestsecuredCopilot < Formula
  desc "Rest Secured Copilot - Security Consultant at your service"
  homepage "https://www.restsecured.xyz"
  url "https://github.com/stankiewicz/restsecured-copilot/archive/0.0.2.tar.gz"
  version "0.0.2"
  sha256 "cb32a9276627d12d6c5677315b5e52f4cf6f3ab5c02298bb3c1e726e215fc67f"

  # depends_on "cmake" => :build
  depends_on :python
  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.1.tar.gz"
    sha1 "f906c441be2f0e7a834cbf701a72788d3ac3d144"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[requests].each do |r|
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
