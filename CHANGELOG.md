# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.6.0] - [UNRELEASED]
### Added
- Calendar#query
- Calendar#find
- Calendar#exists?
- Models now have `error_message` class that returns string with code and message

### Changed
- All models now return and instance of `Model` for consistency

## [0.5.0] - 2020-02-13
### Added
- Practice#find
- Practice#exists?
- Location#query
- Location#find
- Location#exists?
- User#find
- Locaiton find and exists? have `cache` option

### Changed
- Any model class returned has `successful?`, `response_code` and `response_message`

## [0.4.0] - 2020-02-11
### Changed
- Minor grammar fixes
- Added `alias_method` to models for snake to camel case

## [0.3.0] - 2020-02-06
### Added
- Calendar
- Patient
- Location
- User
- Appointment
- Application

## [0.2.0] - 2020-02-06
### Added

## [0.1.0] - 2020-01-21
### Added
- Initial Release with ability to ping Updox api

[0.6.0]: https://github.com/WeInfuse/updox/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/WeInfuse/updox/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/WeInfuse/updox/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/WeInfuse/updox/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/WeInfuse/updox/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/WeInfuse/updox/compare/v0.1.0
