# Importing

Data lives in `/data/vhost/specialist-publisher.#{ENVIRONMENT}.alphagov.co.uk/*-import-data` on `backend-1.backend.#{ENVIRONMENT}`

# updating data

* AS THE DEPLOY USER (sudo -u deploy -i)
* obtain new metadata AND downloads url from scraperwiki
* remove (or move out of the way) the old downloads and metadata folders.
* wget the zip file into /data/vhost/specialist-/<type>-import-data
* unzip it with: unzip filename.zip
* ensure the folders are called 'downloads' and 'metadata'

# performing the import

Again, as the deploy user run:

`$ govuk_setenv specialist-publisher bundle exec bin/import_maib_reports /data/vhost/specialist-publisher.#{ENVIRONMENT}.alphagov.co.uk/maib-import-data/metadata/ /data/vhost/specialist-publisher.#{ENVIRONMENT}.alphagov.co.uk/maib-import-data/ 2>&1 | tee ~/import_logs/maib_import_output.txt`

Swap out the paths, bin script and log file as required.

# importing ALL THE THINGS

```
$ ssh backend-1.backend.#{ENVIRONMENT}
$ sudo -u deploy -i
$ ./import-dsu-maib-msa-raib.sh
```
