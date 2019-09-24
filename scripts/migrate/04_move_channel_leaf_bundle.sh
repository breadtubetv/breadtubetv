ls content/channels/*/index.md | while read page; do
 id=$(echo "$page" | sed 's/\/\index.md//g' | sed 's/content\/channels\///g');

 if [ -f content/channels/$id/index.md ]; then
   mv content/channels/$id/index.md content/channels/$id/_index.md;
 fi
done
