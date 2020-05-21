# Decidim::Notify

A note-taker feature focused on conversations.

## Usage

Notify will be available as a Component for a Participatory
Space.

> Module in development! Not ready to use!

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
