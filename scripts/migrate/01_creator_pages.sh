ls data/channels/ | while read data; do
  yml="data/channels/${data}";
  slug=$(echo `yq r $yml slug`);
  oldpage="content/channel/${slug}.md";

  echo $slug;

  mkdir content/channels/$slug/;
  mv static/img/channels/$slug.jpg content/channels/$slug/logo.jpg;

  page="content/channels/${slug}/_index.md";

  hugo new --kind channel-bundle "channels/${slug}";

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

  echo -e "---\n$(cat $page)" > $page;
  sed -i -e 's/--- null/---/g' $page;

  rm $yml;
  rm $oldpage;
done
