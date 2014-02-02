class AnonymousUser
  def known?
    false
  end

  def anonymous?
    true
  end

  def watching?(proposal)
    false
  end
end
