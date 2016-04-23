# frozen_string_literal: true
RSpec.shared_examples 'db parameters and connection' do |rdbms, options = {}|
  it 'receives and exposes app, node and database bag' do
    driver = described_class.new(aws_opsworks_app, node, rds: aws_opsworks_rds_db_instance(engine: rdbms))

    expect(driver.app).to eq aws_opsworks_app
    expect(driver.node).to eq node
    expect(driver.options[:rds]).to eq aws_opsworks_rds_db_instance(engine: rdbms)
  end

  it 'raises error when no rds is present' do
    expect do
      described_class.new(aws_opsworks_app, node, dummy_option: true).out
    end.to raise_error ArgumentError, ':rds option is not set.'
  end

  context 'connection data' do
    it 'taken from engine' do
      item = described_class.new(
        aws_opsworks_app,
        node(deploy: { dummy_project: { database: { adapter: rdbms } } }),
        rds: aws_opsworks_rds_db_instance(engine: rdbms)
      )
      expect(item.out).to eq(
        encoding: 'utf8',
        reconnect: true,
        adapter: options[:adapter] || rdbms,
        username: 'dbuser',
        password: '03c1bc98cdd5eb2f9c75',
        host: 'dummy-project.c298jfowejf.us-west-2.rds.amazon.com',
        database: 'dummydb'
      )
    end

    it 'taken from adapter' do
      item = described_class.new(
        aws_opsworks_app,
        node(deploy: { dummy_project: { database: { adapter: rdbms } } }),
        rds: aws_opsworks_rds_db_instance(engine: nil)
      )
      expect(item.out).to eq(
        encoding: 'utf8',
        reconnect: true,
        adapter: options[:adapter] || rdbms,
        host: 'localhost',
        database: 'dummydb'
      )
    end
  end
end
