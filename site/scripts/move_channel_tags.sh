mkdir content/channel/

ls data/channels/ | while read data; do
	yml="data/channels/${data}";
  page="content/${data%.yml}.md";
  slug=`sed -n -e 's/^slug: //p' data/channels/${data}`;

  # Delete url from yaml (deprecated)
	sed -i '' '/^url/d' $yml;

	# Move all tags to content file
  tags=`sed '1,/tags/d' $yml`;
  if [ -e "$page" ]; then
	sed -i '' -e '$ d' $page;
    echo "tags:
$tags
url: /$slug/
---
" >> "$page";
	mv "$page" "content/channel/${data%.yml}.md"
  fi

  # Delete all tags in yaml
  sed -i '' '/^tags/,$d' $yml;
done
