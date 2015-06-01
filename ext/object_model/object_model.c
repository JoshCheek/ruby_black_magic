#include <ruby.h>

// casting to a poitner of one of these, and changing the class fucked Ruby up >.<
typedef struct {
  VALUE flags;
  VALUE klass;
} MyRBasic;

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

  IncludedClass = rb_define_class_under(ObjectModel, "IncludedClass", rb_cObject);
  rb_define_method(IncludedClass, "initialize", init_included_class, 1);
  rb_define_method(IncludedClass, "wrapped", wrapped, 0);

  Wtf = rb_define_module("Wtf");
  rb_define_singleton_method(Wtf, "lol", lol, 1);
}
