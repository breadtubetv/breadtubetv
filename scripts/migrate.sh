ls scripts/_migrate/ | while read script; do
  ./scripts/_migrate/$script;
done
