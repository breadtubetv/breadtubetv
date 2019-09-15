ls content/channels/*/index.md | while read page; do
 id=$(echo "$page" | sed 's/\/\index.md//g');
 id=$(echo "$id" | sed 's/content\/channels\///g');

 echo $id;
 mv content/channels/$id/index.md content/channels/$id/_index.md;
done
