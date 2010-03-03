$:.unshift( File.join( File.dirname(__FILE__), '..', 'lib' ))
require 'test/unit'
require 'bk'

class BKTreeImportAndExportTest < Test::Unit::TestCase
  def test_should_give_correct_results_after_exporting_and_reimporting
    tree = BK::Tree.new
    terms = %w[
      lorem ipsum dolor sit amet consectetuer adipiscing elit donec eget lectus vivamus nec
      odio non ipsum adipiscing ornare etiam sapien
    ].uniq
    terms.each do |term|
      tree.add(term)
    end
    exported = tree.export

    tree = BK::Tree.import(exported)

    search_term = 'sapient'
    threshold = 1
    expected = terms.inject({}){ |acc, t|
      d = Text::Levenshtein.distance(t, search_term)
      acc[t] = d if d <= threshold
      acc
    }
    assert expected.any?
    assert_equal expected, tree.query(search_term, threshold)
  end
end