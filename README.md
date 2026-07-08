# rubocop-enertia

Omakase Ruby styling for Enertia projects.

Shared RuboCop configuration distributed as a gem, so every Rails app and plain Ruby gem at Enertia inherits the same style instead of copy-pasting a `.rubocop.yml`. This gem ships config only — no custom cops, no plugin code. Consuming repos pull it in via `inherit_gem`.

This gem is private to Enertia's own repos. It isn't published to RubyGems — it's distributed via git tag, referenced directly from each consuming app's `Gemfile`.

## What's inside

- `default.yml` — base `Layout`/`Lint`/`Metrics`/`Style` rules. No Rails or RSpec required. Use this alone for plain Ruby gems.
- `rails.yml` — `Rails/*` cop overrides. Requires `rubocop-rails` (pulled in automatically as a dependency of this gem).
- `rspec.yml` — `RSpec/*`, `FactoryBot/*`, `Capybara/*` cop overrides. Requires `rubocop-rspec`, `rubocop-factory_bot`, `rubocop-capybara` (also pulled in automatically).

Adding this one gem to your `Gemfile` pulls in `rubocop`, `rubocop-rails`, `rubocop-rspec`, `rubocop-factory_bot`, and `rubocop-capybara` transitively — you no longer need to list each of them separately. Unused layers (e.g. `rails.yml` in a plain gem) cost nothing: the extra cop gems are installed but never loaded unless referenced in a `plugins:` list.

## Installation

Add to your `Gemfile`, pinned to a tag from this repo's [releases](https://github.com/enertia-world/rubocop-enertia/tags):

```ruby
gem 'rubocop-enertia', git: 'git@github.com:enertia-world/rubocop-enertia.git', tag: 'v1.0.1', require: false, group: [:development, :test]
```

If your `Gemfile` already defines the `github:` shorthand (`git_source(:github) { |repo| "https://github.com/#{repo}.git" }`), this also works:

```ruby
gem 'rubocop-enertia', github: 'enertia-world/rubocop-enertia', tag: 'v1.0.1', require: false, group: [:development, :test]
```

### Rails apps

`.rubocop.yml`:

```yaml
inherit_gem:
  rubocop-enertia:
    - default.yml
    - rails.yml
    - rspec.yml

inherit_from: .rubocop_todo.yml

inherit_mode:
  merge:
    - Exclude

AllCops:
  TargetRubyVersion: 3.4
  TargetRailsVersion: 8.1

# Repo-specific overrides go below, e.g.:
# Rails:
#   Exclude:
#     - 'gems/some_vendored_gem/**/*'
```

### Plain Ruby gems (no Rails, no RSpec extensions)

`.rubocop.yml`:

```yaml
inherit_gem:
  rubocop-enertia: default.yml

inherit_from: .rubocop_todo.yml

inherit_mode:
  merge:
    - Exclude

AllCops:
  TargetRubyVersion: 3.4
```

If the gem's specs use FactoryBot or Capybara, add `rspec.yml` to the `inherit_gem` list too.

Then run `bundle`, then `bundle exec rubocop` to check for compliance, or `bundle exec rubocop -a` to auto-correct.

Keep `.rubocop_todo.yml` local to each repo — it tracks that repo's existing violations to fix over time and should never live in this gem.

### Migrating an existing repo onto this gem

Don't just swap `.rubocop.yml` and keep the old `.rubocop_todo.yml` as-is. `.rubocop_todo.yml` entries take precedence over anything pulled in via `inherit_gem` for cops it doesn't also restate locally — a grandfathered value in the todo file (e.g. a bumped `Layout/LineLength: Max`) can silently override the gem's default once the repo stops restating its own copy of that setting. Regenerate it against the new merged config instead:

```sh
bundle exec rubocop --auto-gen-config
```

This produces a todo file scoped to the repo's actual current violations under the gem's rules, rather than carrying forward exceptions calibrated against the old config.

## Versioning

Releases are cut by hand, no RubyGems push involved. For each release:

1. Bump `spec.version` in `rubocop-enertia.gemspec` to match the new version, and commit it.
2. Tag that commit (e.g. `v1.0.1`) and push the tag.

The gemspec version and the git tag are not linked by any tooling — nothing fails if they drift apart, so keep them in sync by hand. Consuming apps pin an exact `tag:` in their `Gemfile` rather than a version range, so a rule change here never reaches a repo until someone there bumps the tag and runs `bundle update rubocop-enertia` — deliberately, per repo.

The gemspec's `rubocop` dependency is floor-only (`>= 1.88`), so consuming apps can bump their own `gem 'rubocop'` version independently without waiting for a new `rubocop-enertia` tag. `rubocop-rails`, `rubocop-rspec`, `rubocop-factory_bot`, and `rubocop-capybara` stay capped (`~>`), since `rails.yml`/`rspec.yml` reference their cop names directly and an independent bump there risks fragmenting the shared style across apps.

## License

MIT
