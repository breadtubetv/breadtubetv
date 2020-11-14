DB="breadtubetv_development"
DUMP="tmp/breadtubetv.dump"

if [ ! -e $DUMP ]
then
  curl -o $DUMP `heroku pg:backups:public-url`;
fi

docker-compose run web rails db:drop db:create;

docker-compose exec postgres pg_restore --no-acl --no-owner -U postgres -h postgres -d $DB app/$DUMP;

docker-compose run web rails db:environment:set RAILS_ENV=development;