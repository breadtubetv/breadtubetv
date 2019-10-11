ls data/videos/ | while read channel; do
  mkdir -p content/channels/$channel/videos/;

  ls data/videos/$channel/ | while read video; do
    id=$(echo "$video" | sed 's/\.yml//g');
    data="data/videos/$channel/$id.yml";
    path="channels/$channel/videos/$id.md";
    page="content/$path";

    if [ ! -f "$page" ]; then
      hugo new --kind video $path;
    else
      echo "${page} exists";
    fi

    description=$(echo `yq r $data description`);
    title=$(echo `yq r $data title`);
    series=$(echo `yq r $data series`);
    publishdate=$(echo `yq r $data publishdate`);
    url="/$channel/$id/";

    yq w -i $page title -- "$title";

    if [ "$description" != "null" ]; then
      yq w -i $page description -- "$description";
    fi

    if [ "$series" != "null" ]; then
      yq w -i $page series -- "$series";
    fi

    if [ "$publishDate" != "null" ]; then
      yq w -i $page publishdate -- "$publishdate";
    fi

    yq w -i $page url -- "/$channel/$id/";
    yq w -i $page providers.youtube.id -- "$id";

    yq d -i $page draft;

    echo -e "---\n$(cat $page)" > $page;
    sed -i -e 's/--- null/---/g' $page;
  done
done
