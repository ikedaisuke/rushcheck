# malformed format string bug for sprintf
# see also a recent news
# http://k-tai.impress.co.jp/cda/article/news_toppage/30484.html
# this news tells that a japanese handy-phone hungs when it receives
# an email which contains the special format string "%s".

require 'rushcheck'

def malformed_format_string
  RushCheck::Assertion.new(String) { |s|
    sprintf(s)
    true
  }
end

def malformed_format_string2
  # SpecialString is used to find special format more likely
  RushCheck::Assertion.new(SpecialString) { |s|
    sprintf(s)
    true
  }
end
