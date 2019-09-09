# https://github.com/mikefarah/yq

ls content/channels/*/index.md | while read page; do
  yq d -i $page channel;
  yq d -i $page providers.youtube.videos;
  echo -e "---\n$(cat $page)" > $page;
  sed -i -e 's/--- null/---/g' $page;
done
