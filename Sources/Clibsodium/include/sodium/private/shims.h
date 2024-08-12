//
//  shims.h
//
//
//  Created by Jaehong Kang on 8/12/24.
//

#ifndef shims_h
#define shims_h

// Endian

#ifdef __APPLE__
#include <machine/endian.h>

#if BYTE_ORDER == BIG_ENDIAN
#define NATIVE_BIG_ENDIAN
#elif BYTE_ORDER == LITTLE_ENDIAN
#define NATIVE_LITTLE_ENDIAN
#else
#error Unknown Byte Order.
#endif

#else
#include <endian.h>

#if __BYTE_ORDER == __BIG_ENDIAN
#define NATIVE_BIG_ENDIAN
#elif __BYTE_ORDER == __LITTLE_ENDIAN
#define NATIVE_LITTLE_ENDIAN
#else
#error Unknown Byte Order.
#endif
#endif

// Arch specific features

#if defined(__x86_64__) || defined(_M_X64)

#if !(defined(_WIN32) || defined(WIN32))
#define HAVE_AMD64_ASM
#define HAVE_AVX_ASM
#endif

#define HAVE_CPUID
#define HAVE_MMINTRIN_H
#define HAVE_EMMINTRIN_H
#define HAVE_PMMINTRIN_H
#define HAVE_TMMINTRIN_H
#define HAVE_SMMINTRIN_H
#define HAVE_AVXINTRIN_H
#define HAVE_AVX2INTRIN_H
#define HAVE_AVX512FINTRIN_H
#define HAVE_WMMINTRIN_H
#define HAVE_RDRAND

#elif defined(__aarch64__) || defined(_M_ARM64)

#define HAVE_ARMCRYPTO

#endif

#endif /* shims_h */
