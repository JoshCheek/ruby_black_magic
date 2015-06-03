// A bit out of date, but pretty helpful:
//   http://www.eqqon.com/index.php/Ruby_C_Extension_API_Documentation_%28Ruby_1.8%29
#include <ruby.h>

VALUE BlackMagic;
VALUE IncludedClass;

VALUE real_superclass(VALUE self, VALUE klass) {
  VALUE super = RCLASS_SUPER(klass);
  if(!super) return super;
  if(BUILTIN_TYPE(super) == T_ICLASS) {
    return rb_funcall(IncludedClass, rb_intern("new"), 1, RBASIC(super)->klass);
  } else return super;
}


VALUE set_superclass(VALUE self, VALUE target, VALUE new_superclass) {
  RCLASS(target)->super = new_superclass;
  return target;
}


VALUE real_class(VALUE self, VALUE obj) {
  return CLASS_OF(obj);
}


// RBasic without the `const` on klass
typedef struct {
  VALUE flags;
  VALUE klass;
} MutableRBasic;

VALUE set_class(VALUE self, VALUE target, VALUE newklass) {
  // Record the current ivars
  //   This is because one of the optimizations is to have the class track ivar offsets
  //   When we swap the class, it fucks up the offsets, so we'll just explicitly add each one
  VALUE ivar_names  = rb_funcall(target, rb_intern("instance_variables"), 0);
  VALUE ivar_values = rb_ary_new();

  int num_ivars = FIX2INT(rb_funcall(ivar_names, rb_intern("length"), 0));
  int i;
  for(i = 0; i < num_ivars; ++i) {
    VALUE ivar_name  = rb_funcall(ivar_names, rb_intern("at"), 1, INT2FIX(i));
    VALUE ivar_value = rb_funcall(target, rb_intern("instance_variable_get"), 1, ivar_name);
    rb_ary_push(ivar_values, ivar_value);
  }

  // Update the class
  ((MutableRBasic*)target)->klass = newklass;

  // Reset the ivars
  for(i = 0; i < num_ivars; ++i) {
    VALUE ivar_name  = rb_funcall(ivar_names,  rb_intern("at"), 1, INT2FIX(i));
    VALUE ivar_value = rb_funcall(ivar_values, rb_intern("at"), 1, INT2FIX(i));
    rb_funcall(target, rb_intern("instance_variable_set"), 2, ivar_name, ivar_value);
  }

  // return target;
  return target;
}

VALUE set_ivar(VALUE self, VALUE object, VALUE name, VALUE value) {
  return rb_ivar_set(object, rb_to_id(name), value);
}

VALUE get_ivar(VALUE self, VALUE object, VALUE name) {
  return rb_ivar_get(object, rb_to_id(name));
}

void Init_black_magic() {
  BlackMagic    = rb_define_module("BlackMagic");
  IncludedClass = rb_define_class_under(BlackMagic, "IncludedClass", rb_cObject);

  // class level stuff
  rb_define_singleton_method(BlackMagic, "real_superclass", real_superclass, 1);
  rb_define_singleton_method(BlackMagic, "set_superclass",  set_superclass,  2);

  // instance level stuff
  rb_define_singleton_method(BlackMagic, "real_class",      real_class,      1);
  rb_define_singleton_method(BlackMagic, "set_class",       set_class,       2);
  rb_define_singleton_method(BlackMagic, "set_ivar",        set_ivar,        3);
  rb_define_singleton_method(BlackMagic, "get_ivar",        get_ivar,        2);
}
