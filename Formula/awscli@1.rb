class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/d6/f4/100d38b2b277682b2d155e15f8fb7acfad658efe72367965616efaa39453/awscli-1.27.50.tar.gz"
  sha256 "d13c112b34f0b4c8740fa0bfd5eca482698ae586f989e281b0c69859c54f4ef3"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d872081a8d44598365c3c91f5e891434581be8dbfe231e3cda69d86cfb8c82fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a235e7ae0d551aff5d728860c66a196ed441075572c1d79cc8fd4d02a17bfde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5a6f2868261ad9de3070e5f943fd3280f2b20e3c442c7d7d08bef660115e61d"
    sha256 cellar: :any_skip_relocation, ventura:        "cb11d3b07523394e596ee2619775d3171251943011e9861a84f5e4107bc742a0"
    sha256 cellar: :any_skip_relocation, monterey:       "de0c8564f76394532f9edfe05215b455955e85fbc451a8efbca48e42a16d5b18"
    sha256 cellar: :any_skip_relocation, big_sur:        "375fac020f80121a3533040fd2452823391b7fd70763714455b3b5ec09b8afba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a239080d4095d59c0d173cacbe50df56e928e8b1482c2d16829c6bddd285c4df"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # Remove this dependency when the version is at or above 1.27.6
  # and replace with `uses_from_macos "mandoc"`
  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2f/90/6ef8ae718153f970fa28e019d4768b2767ec03dd8701d7df1036bf7ed4d9/botocore-1.29.50.tar.gz"
    sha256 "5cc68b78a48217550c18b4639420b7c3b48ed9e09e749343143acbfa423ceec5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
