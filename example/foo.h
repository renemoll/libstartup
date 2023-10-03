#ifndef FOO_H
#define FOO_H

struct Foo {
  Foo(Foo *other) : x(other->x) { }
  Foo() : x(42) { }

  int x;

private:
  Foo(const Foo&);
};

extern Foo foo_global;

#endif
