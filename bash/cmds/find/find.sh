
touch old_file -t 199001011200.00 # [[CC]YY]MMDDhhmm[.ss]
touch foo_hello
touch prefix_foo_postfix

mkdir dir
mkdir dir/subdir
touch dir/subdir/foo_hello

mkdir dir2
touch dir2/file
ln -s `readlink -f .` dir2/link

ls -l

# demo begin
tree .
echo ""

echo  1. find dir 
find dir
echo 

echo 2. find . -name "foo*"
find . -name "foo*"
echo 

echo 3. find . -type l
find . -type l
echo

echo 4. find . -type l -exec readlink -f {} \;
find . -type l -exec readlink -f {} \;
echo 

echo 5. find  . -type d -atime +10 
find  . -type f -atime +10 
echo

# this will give nothing, because the inode of old_file is just created
echo 6. find  . -type d -ctime +10 
find  . -type f -ctime +10 
echo

# clean
set +x
echo begin cleanning ...

rm old_file
rm foo_hello
rm prefix_foo_postfix

rm -r dir

rm -r dir2

