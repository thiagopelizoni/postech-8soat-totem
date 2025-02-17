require 'json'
require 'httparty'
require 'webmock/cucumber'

Given(/^the API endpoint is set to "([^"]*)"$/) do |endpoint|
  ENV['API_CLIENTE'] = endpoint
end

Given(/^a valid cliente payload:$/) do |table|
  @payload = { "cliente" => table.hashes.first }
end

Given(/^a cliente payload missing "([^"]*)":?$/) do |missing_key, table|
  @payload = { "cliente" => table.hashes.first }
  @payload["cliente"].delete(missing_key)
end

Given(/^a valid update payload:$/) do |table|
  @update_payload = table.hashes.first
end

Given(/^a cliente with ID "([^"]*)" exists$/) do |id|
  @existing_cliente_id = id
end

Given(/^valid login credentials:$/) do |table|
  @login_payload = table.hashes.first
end

Given(/^login credentials missing "([^"]*)":?$/) do |missing_key, table|
  @login_payload = table.hashes.first
  @login_payload.delete(missing_key)
end

When(/^I send a request to create the cliente$/) do
  if @payload && @payload["cliente"] && @payload["cliente"].has_key?("email")
    stub_request(:post, "#{ENV['API_CLIENTE']}/clientes")
      .with(body: @payload.to_json, headers: { 'Content-Type' => 'application/json' })
      .to_return(status: 201, body: @payload.to_json, headers: { 'Content-Type' => 'application/json' })
  end
  begin
    @response = ClienteService.create_cliente(@payload)
  rescue ArgumentError => e
    @error_message = e.message
  end
end

Then(/^the response status should be (\d+)$/) do |status|
  expect(@response.code).to eq(status.to_i)
end

Then(/^the response should contain the cliente data$/) do
  parsed = JSON.parse(@response.body)
  expect(parsed["cliente"]).to eq(@payload["cliente"])
end

Then(/^I should receive an error message containing "([^"]*)"$/) do |msg|
  expect(@error_message).to include(msg)
end

When(/^I send a request to fetch all clientes$/) do
  stub_request(:get, "#{ENV['API_CLIENTE']}/clientes")
    .to_return(
      status: 200,
      body: '[{"id":1,"cliente":{"nome":"Joao da Silva"}}]',
      headers: { 'Content-Type' => 'application/json' }
    )
  @response = ClienteService.fetch_clientes
end

Then(/^the response should be a list of clientes$/) do
  parsed = JSON.parse(@response.body)
  expect(parsed).to be_an(Array)
end

When(/^I send a request to fetch the cliente with ID "([^"]*)"$/) do |id|
  stub_request(:get, "#{ENV['API_CLIENTE']}/clientes/#{id}")
    .to_return(
      status: 200,
      body: '{"id":1,"cliente":{"nome":"Joao da Silva"}}',
      headers: { 'Content-Type' => 'application/json' }
    )
  begin
    @response = ClienteService.fetch_cliente(id)
  rescue ArgumentError => e
    @error_message = e.message
  end
end

When(/^I send a request to fetch the cliente with a blank ID$/) do
  begin
    @response = ClienteService.fetch_cliente("")
  rescue ArgumentError => e
    @error_message = e.message
  end
end

Then(/^the response should contain the cliente with ID "([^"]*)"$/) do |id|
  parsed = JSON.parse(@response.body)
  expect(parsed["id"].to_s).to eq(id)
end

When(/^I send a request to update the cliente with ID "([^"]*)" with the payload$/) do |id|
  stub_request(:patch, "#{ENV['API_CLIENTE']}/clientes/#{id}")
    .with(body: @update_payload.to_json, headers: { 'Content-Type' => 'application/json' })
    .to_return(
      status: 200,
      body: '{"id":1}',
      headers: { 'Content-Type' => 'application/json' }
    )
  begin
    @response = ClienteService.update_cliente(id, @update_payload)
  rescue ArgumentError => e
    @error_message = e.message
  end
end

When(/^I send a request to update the cliente with a blank ID with the payload$/) do
  begin
    @response = ClienteService.update_cliente("", @update_payload)
  rescue ArgumentError => e
    @error_message = e.message
  end
end

When(/^I send a login request with the credentials$/) do
  stub_request(:post, "#{ENV['API_CLIENTE']}/login")
    .with(headers: { 'Content-Type' => 'application/json' })
    .to_return(
      status: 200,
      body: '{"token":"abc123"}',
      headers: { 'Content-Type' => 'application/json' }
    )
  begin
    @response = ClienteService.login(@login_payload)
  rescue ArgumentError => e
    @error_message = e.message
  end
end

Then(/^the response should contain an authentication token$/) do
  parsed = JSON.parse(@response.body)
  expect(parsed).to have_key("token")
end
