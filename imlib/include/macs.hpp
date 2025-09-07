#ifndef MACS__
#define MACS__
#include "system.h"
#include <stdio.h>
#define ERROR(x,st) { if (!(x)) \
   { printf("Error on line %d of %s : %s\n", \
     __LINE__,__FILE__,st); exit(1); } }

// These macros should be removed for the non-debugging version
#ifdef NO_CHECK
#define CONDITION(x,st) 
#define CHECK(x) 
#else
#define CONDITION(x,st) ERROR(x,st)
#define CHECK(x) CONDITION(x,"Check stop");
#endif


#if !defined(__cplusplus)
# ifndef min
#  define min(x,y) (x<y ? x:y)
# endif
# ifndef max
#  define max(x,y) (x>y ? x:y)
# endif
#else
/*
 * When compiling as C++ we must not define global macros named `min`/`max`
 * because they conflict with the C++ standard library (std::min/std::max)
 * and break inclusion of <limits>, <algorithm>, etc.  Older C code expected
 * the macros; in C++ builds prefer using std::min/std::max instead.
 */
#endif

#ifndef uchar
typedef unsigned char uchar;
#endif
#ifndef schar
typedef signed char schar;
#endif
#ifndef ushort
typedef unsigned short ushort;
#endif
#ifndef sshort
typedef signed short sshort;
#endif
#ifndef ulong
typedef unsigned long ulong;
#endif

#ifdef __cplusplus
#include <type_traits>
// Provide global min/max function templates that accept mixed argument
// types by returning the common_type between them. This mirrors the old
// C-style macros while remaining safe for C++ headers.
template<typename A, typename B>
inline std::common_type_t<A,B> min(const A &a, const B &b) {
  return a < b ? static_cast<std::common_type_t<A,B>>(a)
               : static_cast<std::common_type_t<A,B>>(b);
}
template<typename A, typename B>
inline std::common_type_t<A,B> max(const A &a, const B &b) {
  return a > b ? static_cast<std::common_type_t<A,B>>(a)
               : static_cast<std::common_type_t<A,B>>(b);
}
#endif

#endif
