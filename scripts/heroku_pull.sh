DB="breadtubetv_development"
DUMP="tmp/breadtubetv.dump"

if [ ! -e $DUMP ]
then
  curl -o $DUMP `heroku pg:backups:public-url`;
fi

rails db:drop db:create;

pg_restore --no-acl --no-owner -h localhost -d $DB $DUMP || true;

rails db:environment:set RAILS_ENV=development;