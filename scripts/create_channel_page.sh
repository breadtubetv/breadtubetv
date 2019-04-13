ls data/channels/ | while read data; do
  page="content/${data%.yml}.md";
  if [ ! -e "$page" ]; then
    name=`sed -n -e 's/^name: //p' data/channels/${data}`;
    slug=`sed -n -e 's/^slug: //p' data/channels/${data}`;
    echo "---
title: $name
type: channels
channel: $slug
menu:
  main:
    parent: "Channels"
vides:
---" >> "$page";
  fi
done
