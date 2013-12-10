require 'test_helper'
class ModeHelperTest < ActionView::TestCase
  include ModeHelper

  # this is pretty horrid
  def current_user
    @current_user
  end

  context "anyone can" do
    should "render its block for a mode operation which is enabled for everyone" do
      assert_equal "a", anyone(true) { "a" }
    end

    should "not render its block for a mode operation which is not enabled for everyone" do
      assert_equal "", anyone(false) { "a" }
    end
  end

  context "no_one can" do
    should "render its block for a mode operation which is disabled for everyone" do
      assert_equal "a", no_one(false) { "a" }
    end

    should "not render its block for a mode operation which is not disabled for everyone" do
      assert_equal "", no_one(true) { "a" }
    end
  end

  context "with user" do
    setup do
      @current_user = User.new
    end

    context "a_user" do
      should "render its block for a mode operation which is enabled for users" do
        assert_equal "a", a_user(true) { "a" }
      end

      should "not render its block for a mode operation which is not enabled for users" do
        assert_equal "", a_user(false) { "a" }
      end
    end

    context "no_user" do
      should "render its block for a mode operation which is disabled for users" do
        assert_equal "a", no_user(false) { "a" }
      end

      should "not render its block for a mode operation which is not disabled for users" do
        assert_equal "", no_user(true) { "a" }
      end
    end
  end

  context "with anonymous user" do
    setup do
      @current_user = AnonymousUser.new
    end

    context "anonymous" do
      should "render its block for a mode operation which is enabled for anonymous users" do
        assert_equal "a", anonymous(true) { "a" }
      end

      should "not render its block for a mode operation which is not enabled for anonymous users" do
        assert_equal "", anonymous(false) { "a" }
      end
    end

    context "no_anonymous" do
      should "render its block for a mode operation which is disabled for anonymous users" do
        assert_equal "a", no_anonymous(false) { "a" }
      end

      should "not render its block for a mode operation which is not disabled for anonymous users" do
        assert_equal "", no_anonymous(true) { "a" }
      end
    end
  end
end
