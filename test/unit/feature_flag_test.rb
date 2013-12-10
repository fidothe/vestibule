require 'test_helper'
require 'feature_flag'

class FeatureFlagTest < ActiveSupport::TestCase
  context "can?" do
    setup do
      Vestibule.mode_of_operation = :cfp
    end

    should "return true for making proposals in cfp mode" do
      assert FeatureFlag.can?(:make, :proposal)
    end

    should "return false for seeing the agenda in cfp mode" do
      refute FeatureFlag.can?(:see, :agenda)
    end
  end

  context "anyone and no_one" do
    context "within class definition or routing" do
      setup do
        @klass_proc = Proc.new {
          include FeatureFlag
          anyone(can?(:see, :agenda)) do
            def anyone_method
            end
          end

          no_one(can?(:see, :agenda)) do
            def no_one_method
            end
          end
        }
      end

      context "anyone" do
        should "define a method if anyone can perform the action on the object" do
          Vestibule.mode_of_operation = :agenda
          klass = Class.new(&@klass_proc)

          assert klass.new.respond_to?(:anyone_method)
        end

        should "not define a method if a no-one can perform the action on the object" do
          Vestibule.mode_of_operation = :cfp
          klass = Class.new(&@klass_proc)

          refute klass.new.respond_to?(:anyone_method)
        end
      end

      context "no_one" do
        should "define a method if no-one can perform the action on the object" do
          Vestibule.mode_of_operation = :cfp
          klass = Class.new(&@klass_proc)

          assert klass.new.respond_to?(:no_one_method)
        end

        should "not define a method if anyone can perform the action on the object" do
          Vestibule.mode_of_operation = :agenda
          klass = Class.new(&@klass_proc)

          refute klass.new.respond_to?(:no_one_method)
        end
      end

      context "within a method" do
        setup do
          klass = Class.new do
            include FeatureFlag
            def anyone_method
              result = false
              anyone(can?(:see, :agenda)) { result = true }
              result
            end

            def no_one_method
              result = false
              no_one(can?(:see, :agenda)) { result = true }
              result
            end
          end
          @obj = klass.new
        end

        context "anyone" do
          should "execute code if anyone can perform the action on the object" do
            Vestibule.mode_of_operation = :agenda

            assert @obj.anyone_method
          end

          should "not execute code if no-one can perform the action on the object" do
            Vestibule.mode_of_operation = :cfp

            refute @obj.anyone_method
          end
        end

        context "no_one_can" do
          should "execute code if no-one can perform the action on the object" do
            Vestibule.mode_of_operation = :cfp

            assert @obj.no_one_method
          end

          should "not execute code if anyone can perform the action on the object" do
            Vestibule.mode_of_operation = :agenda

            refute @obj.no_one_method
          end
        end
      end
    end
  end
end
