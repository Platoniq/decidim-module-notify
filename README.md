# Decidim::Notify

![[CI] Build Status](https://github.com/Platoniq/decidim-module-notify/workflows/%5BCI%5D%20Test%20Notify/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/a00b6c950199d3530dc9/maintainability)](https://codeclimate.com/github/Platoniq/decidim-module-notify/maintainability)
[![Codecov](https://codecov.io/gh/Platoniq/decidim-module-notify/branch/master/graph/badge.svg)](https://codecov.io/gh/Platoniq/decidim-module-notify)


A note-taker feature focused on conversations. This module provides a component for any participatory space in Decidim.

## Usage

Notify will be available as a Component for a Participatory
Space.

> This module is under development!

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-notify", git: "https://github.com/Platoniq/decidim-module-notify"
```

And then execute:

```bash
bundle
bundle exec rails decidim_notify:install:migrations
bundle exec rails db:migrate
```

### Configuration

Notify uses [ActionCable](https://guides.rubyonrails.org/action_cable_overview.html) to display real time notes.

By default uses [PostgreSQL NOTIFY](https://www.postgresql.org/docs/9.0/sql-notify.html) as a backend for ActionCable. However, it is recommended to use Redis because PostgreSQL is limited to a 8000 characters to send messages.

To configure Redis use a custom initializer in you application, for instance `config/initializers/notify_config.rb`:

```ruby
Decidim::Notify.configure do |config|
  config.cable_adapter = "redis"
  config.cable_url = "redis://localhost:6379/1"
end
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
