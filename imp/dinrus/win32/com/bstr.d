// This module is deprecated and will be removed in 0.4.2.
module win32.com.bstr;

import win32.com.core;

deprecated шим* изТкст(ткст s) {
  return toBstr(s);
}

deprecated ткст вТкст(шим* s) {
  return изБткст(s);
}

deprecated бцел дайДлину(шим* s) {
  return bstrLength(s);
}

deprecated проц освободи(шим* s) {
  freeBstr(s);
}