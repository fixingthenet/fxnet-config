RSpec.describe Fxnet::Config do
  let(:config) {
    Fxnet::Config.new(dirs: [FIXTURES.join('config')],
                  env: {"FXNET__MASTER_LOGGING__LEVEL": "debug"},
                  add: {"FXNET__ADD":677})

  }

  it "has a version number" do
    expect(Fxnet::Config::VERSION).not_to be nil
  end

  it "digs for values and hashes" do
    expect(config.dig(:master_logging)).to eq({"level" => "debug"})
    expect(config.dig(:master_logging,:level)).to eq("debug")
  end

  it "adds a value" do
    config.add(344,:something,:new)
    expect(config.dig(:something,:new)).to eq(344)
  end
end
