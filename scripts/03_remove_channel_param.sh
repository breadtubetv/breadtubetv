# https://github.com/mikefarah/yq

ls content/channels/*/index.md | while read page; do
  yq d -i $page channel
done
