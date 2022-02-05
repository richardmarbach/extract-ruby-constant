module Test
  class A
    module S
      module C
        class << self
          ABC = "TEST"
        end
        TEST = "test"
        a = "test"
        def test
        end
      end
    end

    class B
    end
  end
end
