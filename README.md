# amazon-isbn

## How to use
```sh
# ISBN=$(pbpaste) && make @isbn/$ISBN && cat dist/tsv/$ISBN.tsv | tee >(pbcopy)
ISBN=9784000223942 && make @isbn/$ISBN && cat dist/tsv/$ISBN.tsv | tee >(pbcopy)
```
```sh
# ISBN=$(pbpaste) && make @isbn/$ISBN
ISBN=9784000223942 && make @isbn/$ISBN
ISBN=9784473032553 && make @isbn/$ISBN
make dist/all.tsv && cat $_ | tee >(pbcopy)
```
```sh
for ISBN in $(cat ISBN-LIST.txt); do make @isbn/$ISBN; done
```
```sh
make clean
```

## App
* [JAN Reader](https://apps.apple.com/jp/app/jan-reader/id1447222187)
