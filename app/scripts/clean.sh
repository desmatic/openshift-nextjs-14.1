gunzip -c $1 | iconv -f ISO-8859-1 -t UTF-8 > $2
echo "success"
