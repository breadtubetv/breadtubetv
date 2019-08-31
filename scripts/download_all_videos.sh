ls data/channels/ | while read channel; do
  slug=$(echo "$channel" | sed 's/\.yml//g');

  bake channel update $slug;
done
