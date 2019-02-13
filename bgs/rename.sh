a=1
for i in *.jpg; do
	new=$(printf "bg%d.jpg" "$a")
	mv -i -- "$i" "$new"
	let a=a+1
done
