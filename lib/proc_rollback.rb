# check fo tracing of attr_* methods
c = Class.new do
  attr_accessor :foo
end
o = c.new
Thread.new do
  result = false
  Thread.current.set_trace_func lambda {|type, file, line, mth, bnd, cls|
    result = true if mth == :foo= and eval('self',bnd) == o
  }
  o.foo=o.foo
  Thread.current.set_trace_func nil
  result
end.value || puts("Tracing of attr_* methods does not work. Check http://redmine.ruby-lang.org/issues/4583 to see which ruby version you can use. Proc_rollback will not work in some cases.")

# add rollbackablility to Proc
class Proc
  def call_rollbackable(*args, &b)
    vars = {}
    in_trace = false
    tf = proc{ |action, file, line, mth, bnd, cls|
      unless in_trace or (file == __FILE__)
        in_trace = true
        obj = eval("self", bnd)
        vars[obj] ||= obj.instance_variables.inject({}){ |r, n| r.merge n => obj.instance_variable_get(n)}
        in_trace = false
      end
    }

    set_trace_func tf
    result = call(*args, &b)
    set_trace_func nil

    class << self; self; end.send :define_method, :rollback do
      vars.each_pair do |obj, vars|
        vars.each_pair do |n, v|
          obj.instance_variable_set(n, v)
        end
      end
    end
    result
  end
end
