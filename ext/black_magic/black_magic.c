#include <ruby.h>

VALUE BlackMagic;
VALUE BlackMagicObject;

// basically just copy/pasted the implementation of rb_obj_ivar_get
void Init_black_magic() {
  BlackMagic       = rb_define_module("BlackMagic");
  BlackMagicObject = rb_define_class_under(BlackMagic, "Object", rb_cObject);

  /* rb_define_singleton_method(BlackMagicObject, "get_ivar", get_ivar, 2); */
}
