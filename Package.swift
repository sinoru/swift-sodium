// swift-tools-version: 5.9

import PackageDescription

var applePlatforms: [Platform] {
    [.macOS, .macCatalyst, .iOS, .watchOS, .tvOS, .visionOS]
}
let posixPlatforms = applePlatforms + [.linux]

let commonLibSodiumDefines: [CSetting] = [
    .define("_GNU_SOURCE", to: "1"),
    .define("CONFIGURED", to: "1"),
    .define("DEV_MODE", to: "1"),
    .define("HAVE_ATOMIC_OPS", to: "1"),
    .define("HAVE_C11_MEMORY_FENCES", to: "1"),
    .define("HAVE_CET_H", to: "1"),
    .define("HAVE_GCC_MEMORY_FENCES", to: "1"),
    .define("HAVE_INLINE_ASM", to: "1"),
    .define("HAVE_INTTYPES_H", to: "1"),
    .define("HAVE_STDINT_H", to: "1"),
    .define("HAVE_TI_MODE", to: "1"),
]

let platformSpecificLibSodiumDefines: [CSetting] = [
    .define("__wasi__", to: "1",  .when(platforms: [.wasi])),
    .define("ASM_HIDE_SYMBOL", to: ".hidden", .when(platforms: [.linux])),
    .define("ASM_HIDE_SYMBOL", to: ".private_extern", .when(platforms: applePlatforms)),
    .define("TLS", to: "_Thread_local", .when(platforms: posixPlatforms)),
    .define("HAVE_ARC4RANDOM", to: "1", .when(platforms: applePlatforms + [.wasi])),
    .define("HAVE_ARC4RANDOM_BUF", to: "1", .when(platforms: applePlatforms + [.wasi])),
    .define("HAVE_CATCHABLE_ABRT", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_CATCHABLE_SEGV", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_CLOCK_GETTIME", to: "1", .when(platforms: posixPlatforms + [.wasi])),
    .define("HAVE_GETENTROPY", to: "1", .when(platforms: [.linux])),
    .define("HAVE_GETPID", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_MADVISE", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_MLOCK", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_MMAP", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_MPROTECT", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_NANOSLEEP", to: "1", .when(platforms: posixPlatforms + [.wasi])),
    .define("HAVE_POSIX_MEMALIGN", to: "1", .when(platforms: posixPlatforms + [.wasi])),
    .define("HAVE_PTHREAD", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_PTHREAD_PRIO_INHERIT", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_RAISE", to: "1", .when(platforms: posixPlatforms + [.windows])),
    .define("HAVE_SYSCONF", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_SYS_AUXV_H", to: "1", .when(platforms: [.linux, .wasi])),
    .define("HAVE_SYS_MMAN_H", to: "1", .when(platforms: posixPlatforms)),
    .define("HAVE_SYS_PARAM_H", to: "1", .when(platforms: posixPlatforms + [.wasi])),
    .define("HAVE_SYS_RANDOM_H", to: "1", .when(platforms: [.macOS, .macCatalyst, .linux, .wasi])),
    .define("HAVE_WEAK_SYMBOLS", to: "1", .when(platforms: posixPlatforms)),
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
                "SodiumCore",
                "SodiumSecretBox",
                "SodiumSecretStream",
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
                .headerSearchPath("."),
                .headerSearchPath("include/sodium"),
            ] + commonLibSodiumDefines + platformSpecificLibSodiumDefines),
        .target(
            name: "SodiumCore",
            dependencies: [
                "Clibsodium",
            ]),
        .target(
            name: "SodiumSecretBox",
            dependencies: [
                "SodiumCore",
            ]),
        .target(
            name: "SodiumSecretStream",
            dependencies: [
                "SodiumCore",
            ]),
        .testTarget(
            name: "SodiumCoreTests",
            dependencies: ["SodiumCore"]),
        .testTarget(
            name: "SodiumSecretBoxTests",
            dependencies: ["SodiumSecretBox"]),
        .testTarget(
            name: "SodiumSecretStreamTests",
            dependencies: ["SodiumSecretStream"]),
    ]
)
