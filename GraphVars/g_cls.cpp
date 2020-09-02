#ifdef m_type
#undef m_type
#endif
#define m_type double
#include <matlib.h>



main() {
  initM(cin,cout,cerr);
  #include "cls.cpp"
  exitM();
  return 0;
}
