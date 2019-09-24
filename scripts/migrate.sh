ls scripts/migrate/ | while read script; do
  ./scripts/migrate/$script;
done
