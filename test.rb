require 'test/unit'
load 'nolate.rb'

class NolateTest < Test::Unit::TestCase
    def test_basic
        assert_equal(nolate(""),"")
        assert_equal(nolate("nosub"),"nosub")
        assert_equal(nolate("simple <%= 'sub' %>"),"simple sub")
        assert_equal(nolate("hash sub <%#x%>",{:x => 1}),"hash sub 1")
    end

    def test_view
        assert_equal(<<-OUTPUT, nlt("test_view.nolate", :x => 1))
nosub
simple sub
hash sub 1
OUTPUT
    end
end
