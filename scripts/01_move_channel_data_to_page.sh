ls data/channels/ | while read data; do
  yml="data/channels/${data}";
  slug=`echo $data | sed -e "s/.yml$//";`;

  echo $slug;

  page="content/channel/${slug}.md";
  description=`sed -n "/^description:/,/^name:/p" $yml`;
  providers=`sed '1,/providers/d' $yml`;

  if [ -e "$page" ]; then
    if ! grep -q "^providers:" $page ; then
      sed -i -e '$ d' $page; # remove bottom line
        echo "providers:
$providers
---
" >> $page;
      sed -i '/^slug/d' $page;
    fi

    if grep -q "^providers:" $yml ; then
      sed -i '/^providers/,$d' $yml;
      echo "slug: $slug" >> $yml;
    fi

    if ! grep -q "^description:" $page ; then
      sed -i '1d' $page;
      echo -e "---\n$description\n$(cat $page)" > $page;
      sed -i '/^name/d' $page;
    fi
  fi

  rm $yml;
done
