#include <ruby.h>

VALUE method_fucking_around(VALUE self, VALUE n) {
  return INT2NUM(NUM2INT(n) * 2);
}

void Init_fucking_around() {
  VALUE FuckingAround = rb_define_module("FuckingAround");
  rb_define_singleton_method(FuckingAround, "times2",  method_fucking_around, 1);
}
