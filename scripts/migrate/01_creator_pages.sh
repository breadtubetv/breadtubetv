ls data/channels/ | while read data; do
  yml="data/channels/${data}";
  slug=$(echo `yq r $yml slug`);
  oldpage="content/channel/${slug}.md";
  folder="content/channels/${slug}/";
  page="content/channels/${slug}/_index.md";

  echo $slug;

  if [ ! -d "$folder" ]; then
    mkdir $folder;
    hugo new --kind channel-bundle "channels/${slug}";
  else
    echo "${folder} exists;"
  fi

  mv static/img/channels/$slug.jpg content/channels/$slug/logo.jpg;

  ytname=$(echo `yq r $yml providers.youtube.name`);
  ytslug=$(echo `yq r $yml providers.youtube.slug`);
  yturl=$(echo `yq r $yml providers.youtube.url`);
  ytdescription=$(echo `yq r $yml providers.youtube.description`);
  ytsubscribers=$(echo `yq r $yml providers.youtube.subscribers`);

  yq w -i $page description -- "$ytdescription";
  yq w -i $page providers.youtube.name -- "$ytname";
  yq w -i $page providers.youtube.slug -- "$ytslug";
  yq w -i $page providers.youtube.url -- "$yturl";
  yq w -i $page providers.youtube.description -- "$ytdescription";
  yq w -i $page providers.youtube.subscribers -- "$ytsubscribers";

  yq d -i $page draft;
  yq d -i $page videos;

  echo -e "---\n$(cat $page)" > $page;
  sed -i -e 's/--- null/---/g' $page;

  rm $oldpage;
done
