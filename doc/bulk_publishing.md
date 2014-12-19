# Bulk publishing documents

The "publish_<format>" scripts in `bin/` allow bulk publishing of all draft
documents for a given format. They are executed as the deploy user, like:

`$ sudo -u deploy govuk_setenv specialist-publisher bundle exec
bin/publish_aaib_reports`.

They take approximately 3 seconds per document being published to run, and are
idempotent so they can be restarted if they time out.

## Publishing order

Each script publishes all draft documents in a specific order, sorting by a
metadata field.

* AAIB reports: `date_of_occurrence` 
* MAIB reports: `date_of_occurrence`
* RAIB reports: `date_of_occurrence`
* Drug Safety Update: `first_published_at`
* Medical Safety Alert: `issued_date`
