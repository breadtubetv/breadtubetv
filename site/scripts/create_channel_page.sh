ls data/channels/ | while read data; do
  name=`sed -n -e 's/^name: //p' data/channels/${data}`;
  slug=`sed -n -e 's/^slug: //p' data/channels/${data}`;
  page="content/${data%.yml}.md";
  if [ ! -e "$page" ]; then
    echo "---
title: $name
type: channel
channel: $slug
menu:
  main:
    parent: "Channels"
videos:
---" >> "$page";
    echo "permalink: $slug" >> "data/channels/${data}";
  fi
done
