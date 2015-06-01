#include <ruby.h>

// A bit out of date, but pretty helpful:
//   http://www.eqqon.com/index.php/Ruby_C_Extension_API_Documentation_%28Ruby_1.8%29

VALUE ObjectModel;
VALUE IncludedClass;
VALUE Wtf;

/* ObjectModel */

VALUE ancestry(VALUE self, VALUE obj) {
  VALUE ary  = rb_ary_new();
  VALUE crnt = CLASS_OF(obj);

  while(1) {
    if(BUILTIN_TYPE(crnt) == T_ICLASS) {
      rb_ary_push(ary,
        rb_funcall(IncludedClass, rb_intern("new"), 1, RBASIC(crnt)->klass)
      );
    } else {
      rb_ary_push(ary, crnt);
    }

    if(crnt == rb_cBasicObject) break;
    crnt = RCLASS_SUPER(crnt);
  }

  return ary;
}

VALUE real_class(VALUE self, VALUE obj) {
  VALUE crnt = CLASS_OF(obj);
  if(BUILTIN_TYPE(crnt) == T_ICLASS) {
    return rb_funcall(IncludedClass, rb_intern("new"), 1, RBASIC(crnt)->klass);
  } else return crnt;
}

VALUE real_superclass(VALUE self, VALUE klass) {
  return RCLASS_SUPER(klass);
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


/* ObjectModel::IncludedClass */
VALUE init_included_class(VALUE self, VALUE klass) {
  rb_iv_set(self, "@wrapped", klass);
  return self;
}

VALUE wrapped(VALUE self) {
  return rb_iv_get(self, "@wrapped");
}

/* Wtf */
VALUE lol(VALUE self, VALUE klass) {
  return rb_define_class_under(Wtf, "lol", rb_cObject);
}


void Init_object_model() {
  ObjectModel = rb_define_module("ObjectModel");
  rb_define_singleton_method(ObjectModel, "ancestry",  ancestry, 1);
  rb_define_singleton_method(ObjectModel, "real_class",  real_class, 1);
  rb_define_singleton_method(ObjectModel, "real_superclass",  real_superclass, 1);
  rb_define_singleton_method(ObjectModel, "set_class", set_class, 2);

  IncludedClass = rb_define_class_under(ObjectModel, "IncludedClass", rb_cObject);
  rb_define_method(IncludedClass, "initialize", init_included_class, 1);
  rb_define_method(IncludedClass, "wrapped", wrapped, 0);

  Wtf = rb_define_module("Wtf");
  rb_define_singleton_method(Wtf, "lol", lol, 1);
}
