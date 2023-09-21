A proof-of-concept to demonstrate the behavior of Mongoid persisting child records to disk despite never being explicitly commanded to be saved.

## Requirements

* Ruby 3.2.2
* Docker

## Running

Install ruby dependencies & start mongodb instance

```shell
bundle
docker compose up -d
```

To see output:

```shell
ruby main.rb
```
