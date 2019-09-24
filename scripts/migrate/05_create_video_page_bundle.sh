ls data/videos/ | while read channel; do
  mkdir -p content/channel/$channel/videos/;

  ls data/videos/$channel/ | while read video; do
    id=$(echo "$video" | sed 's/\.yml//g');
    data="data/videos/$channel/$id.yml";
    path="channels/$channel/videos/$id.md";
    page="content/$path";

    rm -rf $page;

    hugo new --kind video $path;

    description=$(echo `yq r $data description`);
    title=$(echo `yq r $data title`);
    series=$(echo `yq r $data series`);
    publishDate=$(echo `yq r $data publishDate`);
    url="/$channel/$id/";

    yq w -i $page title -- "$title";
    yq w -i $page type video;
    yq d -i $page draft;

    if [ "$description" != "null" ]; then
      yq w -i $page description -- "$description";
    fi

    if [ "$series" != "null" ]; then
      yq w -i $page series -- "$series";
    fi

    if [ "$publishDate" != "null" ]; then
      yq w -i $page publishDate -- "$publishDate";
    fi

    yq w -i $page url -- "/$channel/$id/";
    yq w -i $page providers.youtube.id -- "$id";

    echo -e "---\n$(cat $page)" > $page;
    sed -i -e 's/--- null/---/g' $page;

    rm -rf $data;
  done

  rm -rf data/videos/$channel/;
done
