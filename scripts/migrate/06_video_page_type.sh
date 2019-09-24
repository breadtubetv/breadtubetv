ls content/channels/**/videos/*.md | while read page; do
  echo $page;
  yq w -i $page type video;
  yq d -i $page draft;

  echo -e "---\n$(cat $page)" > $page;
  sed -i -e 's/--- null/---/g' $page;
done
