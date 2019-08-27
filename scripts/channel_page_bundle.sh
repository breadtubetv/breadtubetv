mv content/channel/_index.md content/channels/_index.md

ls content/channel/ | while read channel; do
  if [ $channel != "_index.md" ]
  then
    page="content/channel/${channel}";
    slug=$(echo "$channel" | sed 's/\.md//g');
    echo $slug;

    mkdir -p content/channel/$slug/;
    mv $page content/channel/$slug/_index.md;
    mv static/img/channels/$slug.jpg content/channel/$slug/logo.jpg;
  fi
done

ls data/videos/ | while read channel; do
  ls data/videos/$channel/ | while read video; do
    id=$(echo "$video" | sed 's/\.yml//g');

    mkdir -p content/channel/$channel/videos/;
    data="data/videos/$channel/$id.yml";
    page="content/channel/$channel/videos/$id.md";

    echo "---" > $page;
    echo "$(cat $data)" >> $page;
    echo "type: video" >> $page;
    echo "url: /$channel/videos/$id/" >> $page;
    echo "---" >> $page;
  done
done

mv content/channels/_index.md content/channel/_index.md
