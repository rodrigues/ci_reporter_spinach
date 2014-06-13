# CI::Reporter::Spinach

Connects [Spinach][spin] to [CI::Reporter][ci], and then to your CI
system.

[![Gem Version](https://badge.fury.io/rb/ci_reporter_spinach.svg)](http://badge.fury.io/rb/ci_reporter_spinach)
[![Build Status](https://travis-ci.org/ci-reporter/ci_reporter_spinach.svg?branch=master)](https://travis-ci.org/ci-reporter/ci_reporter_spinach)
[![Dependency Status](https://gemnasium.com/ci-reporter/ci_reporter_spinach.svg)](https://gemnasium.com/ci-reporter/ci_reporter_spinach)
[![Code Climate](https://codeclimate.com/github/ci-reporter/ci_reporter_spinach.png)](https://codeclimate.com/github/ci-reporter/ci_reporter_spinach)

[spin]: https://github.com/codegram/spinach
[ci]: https://github.com/ci-reporter/ci_reporter

## Supported versions

The latest release of Spinach 0.8 is supported.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ci_reporter_spinach'
```

And then install it:

```
$ bundle
```

## Usage

Require the reporter in your Rakefile, and ensure that
`ci:setup:spinach` is a dependency of your RSpec task.

Unlike other CI::Reporter gems, you must **also** explictly tell
Spinach to use the reporter!

```ruby
require 'ci/reporter/rake/spinach'

task :spinach do
  # Note `-r ci_reporter`!
  exec "spinach -r ci_reporter"
end

task :spinach => 'ci:setup:spinach'
```

### Advanced usage

Refer to the shared [documentation][ci] for details on setting up
CI::Reporter.

### Cucumber

If you use both Cucumber and Spinach, you are likely to see strange
errors due to `gherkin` and `gherkin-ruby` both being loaded. Choose
only one of these frameworks.

## Contributing

1. Fork it ( https://github.com/ci-reporter/ci_reporter_spinach/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add a failing test.
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Ensure tests pass.
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request
