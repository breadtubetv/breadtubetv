ls -r content/channels/**/_index.md | while read file; do
  echo $data;
  url=$(echo `yq r $file providers.youtube.url`);
  slug=$(echo `yq r $file url` | sed 's/\///g');

  bake channel import $slug youtube $url;
done
