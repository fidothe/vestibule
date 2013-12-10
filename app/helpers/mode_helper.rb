require 'feature_flag'

module ModeHelper
  include FeatureFlag
  def anyone(can_query, &block)
    return "" unless can_query
    capture(&block)
  end

  def no_one(can_query, &block)
    return "" if can_query
    capture(&block)
  end

  def a_user(can_query, &block)
    return "" unless current_user.known?
    anyone(can_query, &block)
  end

  def no_user(can_query, &block)
    return "" unless current_user.known?
    no_one(can_query, &block)
  end

  def anonymous(can_query, &block)
    return "" unless current_user.anonymous?
    anyone(can_query, &block)
  end

  def no_anonymous(can_query, &block)
    return "" unless current_user.anonymous?
    no_one(can_query, &block)
  end
end
