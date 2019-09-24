ls content/channel/ | while read data; do
  if [[ $data != *"_"* ]]
  then
    page="content/channel/${data}";
    slug=`echo $data | sed -e "s/.md$//";`;
    echo $slug;

    mkdir content/channels/$slug;
    mv $page content/channels/$slug/index.md;
    mv static/img/channels/$slug.jpg content/channels/$slug/logo.jpg;
  fi
done

