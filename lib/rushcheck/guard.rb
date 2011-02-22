# = guard.rb
# This provides module functions guard and its friends

module RushCheck

  class GuardException < StandardError; end

  def guard
    raise RushCheck::GuardException unless yield
  end

  def guard_raise(c)
    begin
      yield
    rescue Exception => ex
      case ex
      when c
        raise RushCheck::GuardException
      else
        raise ex
      end
    end
  end
  module_function :guard, :guard_raise

end
