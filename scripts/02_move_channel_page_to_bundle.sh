ls content/channel/ | while read data; do
  if [ $data != "_index.md" ]
  then
    page="content/channel/${data}";
    slug=`sed -n -e 's/^channel: //p' $page`;
    slug=`echo $slug | tr -d '"'`;
    echo $slug;

    mkdir content/$slug
    mv $page content/$slug/index.md
    mv static/img/channels/$slug.jpg content/$slug/logo.jpg
  fi
done
