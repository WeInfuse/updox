# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.0.0] - [UNRELEASED]
### Added
- Aliases canceled to cancelled
- Patient#exists?

### Fixed
- `failure_action = :raise` works better
- README fix for `failure_action` method

## [0.12.0] - [2020-02-21]
### Added
- Configuration to `raise` on non-success response
- Configuration to call a lambda on non-success response

### Fixed
- Bug with `as_json` method
- Bug when no date returns on statuses

## [0.11.0] - [2020-02-19]
### Added
- More fields to User model

## [0.10.0] - [2020-02-19]
### Fixed
- Bug with User#exists? always returning true

## [0.9.0] - [2020-02-19]
### Fixed
- User#create had wrong authorization
- User#exists? had bug in call type

## [0.8.0] - [2020-02-19]
### Added
- Model#exists? for all models to share if `find` is implemented

### Fixed
- Rails uses `as_json` to serialize so date in appointment was incorrect string

## [0.7.0] - [2020-02-14]
### Added
- AppointmentStatus
- Reminder
- Status
- Can batch sync requests
- Response with statuses is automatically converted into status objects

## [0.6.0] - 2020-02-13
### Added
- Calendar#query
- Calendar#find
- Calendar#exists?
- Patient#exists?
- Appointment#query
- Appointment#find
- Appointment#exists?
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

[1.0.0]: https://github.com/WeInfuse/updox/compare/v0.12.0...HEAD
[0.12.0]: https://github.com/WeInfuse/updox/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/WeInfuse/updox/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/WeInfuse/updox/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/WeInfuse/updox/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/WeInfuse/updox/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/WeInfuse/updox/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/WeInfuse/updox/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/WeInfuse/updox/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/WeInfuse/updox/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/WeInfuse/updox/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/WeInfuse/updox/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/WeInfuse/updox/compare/v0.1.0
