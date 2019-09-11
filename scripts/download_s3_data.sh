[ ! -d "/srv/shared/deep_stac/data" ] && mkdir -p /srv/shared/deep_stac/data
aws s3 sync s3://geohackweek/2019/deep_stack/data /srv/shared/deep_stac/data