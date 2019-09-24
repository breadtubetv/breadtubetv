ls data/channels/ | while read data; do
  yml="data/channels/${data}";
  slug=`echo $data | sed -e "s/.yml$//";`;

  echo $slug;

  mkdir content/channels/$slug/;
  mv static/img/channels/$slug.jpg content/channels/$slug/logo.jpg;

  page="content/channels/${slug}/_index.md";

  hugo new --kind channel-bundle $path;

  description=$(echo `yq r $yml providers.youtube.description`);
  providers=$(echo `yq r $yml providers`);
  slug=$(echo `yq r $yml slug`);

  if [ "$description" != "null" ]; then
    yq w -i $page description -- "$description";
  fi

  if [ "$providers" != "null" ]; then
    yq w -i $page providers -- "$providers";
  fi

  if [ "$slug" != "null" ]; then
    yq w -i $page slug -- "$slug";
  fi

  echo -e "---\n$(cat $page)" > $page;
  sed -i -e 's/--- null/---/g' $page;

  rm $yml;
done
