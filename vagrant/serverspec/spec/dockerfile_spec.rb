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
end
