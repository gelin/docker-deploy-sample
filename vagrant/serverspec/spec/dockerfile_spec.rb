require 'spec_helper'
require 'serverspec'
require 'docker'
require 'pry'

describe "Dockerfile" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.')

    set :os, :family => :debian
    set :backend, :docker
    set :docker_image, @image.id
  end
  
  it "should have working directory" do
    expect(@image.json["Config"]["WorkingDir"]).to eq("/data")
  end

  it "should expose mongodb ports" do
    ports = [27017, 28017]

    ports.each do |port|
      expect(@image.json["Config"]["ExposedPorts"].has_key?("#{port}/tcp")).to eq(true)
    end
  end

  describe package('mongodb-org') do
    it { should be_installed }
  end

  describe service('mongod') do
    it { should be_enabled }
  end
  
  describe service('mongod') do
    it { should be_running }
  end
end
