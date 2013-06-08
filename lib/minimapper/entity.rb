# Look at minimapper/entity/core for the required API.
require 'minimapper/entity/core'
require 'minimapper/entity/attributes'
require 'minimapper/entity/validation'
require 'minimapper/entity/rails'

module Minimapper
  module Entity
    include Minimapper::Entity::Core

    def initialize(attributes = {})
      self.attributes = attributes
    end

    def attributes=(new_attributes)
      super(new_attributes)
      new_attributes.each_pair { |name, value| self.send("#{name}=", value) }
    end

    def ==(other)
      super || (
        other.instance_of?(self.class) &&
        self.id &&
        other.id == self.id
      )
    end

    def self.included(klass)
      klass.send(:include, Minimapper::Entity::Validation)
      klass.send(:include, Minimapper::Entity::Rails)
      klass.send(:extend, Minimapper::Entity::Attributes)
      klass.attributes(
        [ :id, :integer ],
        [ :created_at, :date_time ],
        [ :updated_at, :date_time ]
      )
    end
  end
end
