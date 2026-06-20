require "spec_helper"

RSpec.describe "bin/dockermancer CLI subprocess" do
  before { setup_aruba }

  it "shows help when no arguments" do
    run_command("ruby bin/dockermancer")
    stop_all_commands
puts "xxxxxx#{last_command_started}"
    expect(last_command_started).to have_output(/dockermancer: backup & restore docker-compose stacks/)

                                                 #dockermancer: backup & restore docker-compose stacks
  end

  it "exits with error on unknown command" do
    run_command("ruby bin/dockermancer unknown")
    stop_all_commands
    expect(last_command_started).to have_exit_status(1)
  end
end

