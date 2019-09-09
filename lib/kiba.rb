# encoding: utf-8
require 'kiba/version'

require 'kiba/register'
require 'kiba/checkpoint'
require 'kiba/control'
require 'kiba/context'
require 'kiba/parser'
require 'kiba/runner'
require 'kiba/streaming_runner'
require 'kiba/dsl_extensions/config'

Kiba.extend(Kiba::Parser)
module Kiba
  include Kiba::Register

  def self.run(job)
    # NOTE: use Hash#dig when Ruby 2.2 reaches EOL
    runner = job.config.fetch(:kiba, {}).fetch(:runner, Kiba::Runner)
    runner.run(job)
  end
end
