// swift-tools-version: 5.9

import PackageDescription

let applePlatforms: [Platform] = [.macOS, .macCatalyst, .iOS, .watchOS, .tvOS, .visionOS, .driverKit]
let posixPlatforms = applePlatforms + [.linux]

let commonLibSodiumDefines: [CSetting] = [
    .define("_GNU_SOURCE"),
    .define("CONFIGURED"),
    .define("DEV_MODE"),
    .define("HAVE_ATOMIC_OPS"),
    .define("HAVE_C11_MEMORY_FENCES"),
    .define("HAVE_CET_H"),
    .define("HAVE_GCC_MEMORY_FENCES"),
    .define("HAVE_INLINE_ASM"),
    .define("HAVE_INTTYPES_H"),
    .define("HAVE_STDINT_H"),
    .define("HAVE_TI_MODE"),
]

let platformSpecificLibSodiumDefines: [CSetting] = [
    .define("__wasi__", .when(platforms: [.wasi])),
    .define("ASM_HIDE_SYMBOL", to: ".hidden", .when(platforms: [.linux])),
    .define("ASM_HIDE_SYMBOL", to: ".private_extern", .when(platforms: applePlatforms)),
    .define("TLS", to: "_Thread_local", .when(platforms: posixPlatforms)),
    .define("HAVE_ARC4RANDOM", .when(platforms: applePlatforms + [.wasi])),
    .define("HAVE_ARC4RANDOM_BUF", .when(platforms: applePlatforms + [.wasi])),
    .define("HAVE_CATCHABLE_ABRT", .when(platforms: posixPlatforms)),
    .define("HAVE_CATCHABLE_SEGV", .when(platforms: posixPlatforms)),
    .define("HAVE_CLOCK_GETTIME", .when(platforms: posixPlatforms + [.wasi])),
    .define("HAVE_GETENTROPY", .when(platforms: [.linux])),
    .define("HAVE_GETPID", .when(platforms: posixPlatforms)),
    .define("HAVE_MADVISE", .when(platforms: posixPlatforms)),
    .define("HAVE_MLOCK", .when(platforms: posixPlatforms)),
    .define("HAVE_MMAP", .when(platforms: posixPlatforms)),
    .define("HAVE_MPROTECT", .when(platforms: posixPlatforms)),
    .define("HAVE_NANOSLEEP", .when(platforms: posixPlatforms + [.wasi])),
    .define("HAVE_POSIX_MEMALIGN", .when(platforms: posixPlatforms + [.wasi])),
    .define("HAVE_PTHREAD", .when(platforms: posixPlatforms)),
    .define("HAVE_PTHREAD_PRIO_INHERIT", .when(platforms: posixPlatforms)),
    .define("HAVE_RAISE", .when(platforms: posixPlatforms + [.windows])),
    .define("HAVE_SYSCONF", .when(platforms: posixPlatforms)),
    .define("HAVE_SYS_AUXV_H", .when(platforms: [.linux, .wasi])),
    .define("HAVE_SYS_MMAN_H", .when(platforms: posixPlatforms)),
    .define("HAVE_SYS_PARAM_H", .when(platforms: posixPlatforms + [.windows, .wasi])),
    .define("HAVE_SYS_RANDOM_H", .when(platforms: posixPlatforms + [.wasi])),
    .define("HAVE_WEAK_SYMBOLS", .when(platforms: posixPlatforms)),
]

let package = Package(
    name: "swift-sodium",
    products: [
        .library(
            name: "Sodium",
            targets: ["Sodium"]),
        .library(
            name: "SodiumFoundationCompat",
            targets: ["SodiumFoundationCompat"]),
        .library(
            name: "SodiumNIOCompat",
            targets: ["SodiumNIOCompat"]),
        .library(
            name: "Clibsodium",
            targets: ["Clibsodium"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "Sodium",
            dependencies: [
                "Clibsodium",
            ]),
        .target(
            name: "SodiumFoundationCompat",
            dependencies: [
                "Sodium",
            ]),
        .target(
            name: "SodiumNIOCompat",
            dependencies: [
                "Sodium",
                .product(name: "NIOCore", package: "swift-nio")
            ]),
        .target(
            name: "Clibsodium",
            cSettings: [
                .headerSearchPath("include/sodium")
            ] + commonLibSodiumDefines + platformSpecificLibSodiumDefines),
        .testTarget(
            name: "SodiumTests",
            dependencies: ["Sodium"]),
    ]
)
