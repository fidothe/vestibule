require 'active_support/concern'

module FeatureFlag
  extend ActiveSupport::Concern

  def self.can?(action, object)
    Vestibule.mode_of_operation.can?(action, object)
  end

  def can?(*args)
    FeatureFlag.can?(*args)
  end

  def anyone(can_query, &block)
    instance_exec(&block) if can_query
  end

  def no_one(can_query, &block)
    instance_exec(&block) if !can_query
  end

  module ClassMethods
    def can?(*args)
      FeatureFlag.can?(*args)
    end

    def anyone(can_query, &block)
      class_exec(&block) if can_query
    end

    def no_one(can_query, &block)
      class_exec(&block) if !can_query
    end
  end
end
