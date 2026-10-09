#pragma once
#include <X11/XKBlib.h>
#include <cstring>
#include <cstdlib>
inline int X11KeyUsage(const char* name) {
  char key[5]{}; std::memcpy(key, name, 4);
  if (key[0] == 'F' && key[1] == 'K') {
    int number = std::atoi(key + 2);
    if (number >= 1 && number <= 24) return 0x70000 | (number <= 12 ? 0x39 + number : 0x5b + number);
  }
  const char* rows[] = {"AE", "AD", "AC", "AB"};
  const int row0[] = {0x1e,0x1f,0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x2d,0x2e};
  const int row1[] = {0x14,0x1a,0x08,0x15,0x17,0x1c,0x18,0x0c,0x12,0x13,0x2f,0x30};
  const int row2[] = {0x04,0x16,0x07,0x09,0x0a,0x0b,0x0d,0x0e,0x0f,0x33,0x34};
  const int row3[] = {0x1d,0x1b,0x06,0x19,0x05,0x11,0x10,0x36,0x37,0x38};
  const int* tables[] = {row0,row1,row2,row3}; const int lengths[] = {12,12,11,10};
  for (int row = 0; row < 4; ++row) {
    int n = std::atoi(key + 2);
    if (std::strncmp(key, rows[row], 2) == 0 && n > 0 && n <= lengths[row]) return 0x70000 | tables[row][n-1];
  }
  const char* names[] = {"ESC", "RTRN", "BKSP", "TAB", "SPCE", "BKSL", "TLDE", "INS", "HOME", "PGUP", "DELE", "END", "PGDN", "RGHT", "LEFT", "DOWN", "UP", "LCTL", "RCTL", "LALT", "RALT", "LFSH", "RTSH", "LWIN", "RWIN"};
  const int usages[] = {0x29,0x28,0x2a,0x2b,0x2c,0x31,0x35,0x49,0x4a,0x4b,0x4c,0x4d,0x4e,0x4f,0x50,0x51,0x52,0xe0,0xe4,0xe2,0xe6,0xe1,0xe5,0xe3,0xe7};
  for (unsigned i = 0; i < sizeof(usages)/sizeof(usages[0]); ++i) {
    if (std::strncmp(key, names[i], 4) == 0) return 0x70000 | usages[i];
  }
  return 0;
}
