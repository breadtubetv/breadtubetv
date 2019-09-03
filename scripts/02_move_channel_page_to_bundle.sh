ls content/channels/ | while read data; do
  if [ $data != "_index.md" ]
  then
    page="content/channel/${data}";
    slug=`sed -n -e 's/^channel: //p' $page`;
    slug=`echo $slug | tr -d '"'`;
    echo $slug;

    mkdir content/channels/$slug
    mv $page content/channels/$slug/_index.md
    mv static/img/channels/$slug.jpg content/channels/$slug/logo.jpg
  fi
done
