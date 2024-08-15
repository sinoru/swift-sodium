//
//  shims.h
//
//
//  Created by Jaehong Kang on 8/12/24.
//

#ifndef shims_h
#define shims_h

// Endian

#if !(defined(_WIN32) || defined(WIN32))

#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
#define NATIVE_BIG_ENDIAN 1
#elif __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#define NATIVE_LITTLE_ENDIAN 1
#else
#error Unknown Byte Order.
#endif

#else

#define NATIVE_LITTLE_ENDIAN 1

#endif

// Arch specific features

#if defined(__x86_64__) || defined(_M_X64)

#if !(defined(_WIN32) || defined(WIN32))
#define HAVE_AMD64_ASM 1
#define HAVE_AVX_ASM 1
#define HAVE_RDRAND 1
#endif

#define HAVE_CPUID 1
#define HAVE_MMINTRIN_H 1
#define HAVE_EMMINTRIN_H 1
#define HAVE_PMMINTRIN_H 1
#define HAVE_TMMINTRIN_H 1
#define HAVE_SMMINTRIN_H 1
#define HAVE_AVXINTRIN_H 1
#define HAVE_AVX2INTRIN_H 1
#define HAVE_AVX512FINTRIN_H 1
#define HAVE_WMMINTRIN_H 1

#elif defined(__aarch64__) || defined(_M_ARM64)

#define HAVE_ARMCRYPTO 1

#endif

#endif /* shims_h */
